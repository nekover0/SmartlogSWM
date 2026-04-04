import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:smartlog_swm_mobile/app/router/app_router.dart';
import 'package:smartlog_swm_mobile/app/router/app_route_paths.dart';
import 'package:smartlog_swm_mobile/features/scan/application/controllers/scan_session_controller.dart';
import 'package:smartlog_swm_mobile/features/scan/domain/models/scan_launch_context.dart';
import 'package:smartlog_swm_mobile/features/scan/presentation/widgets/receive_scan_form_sheet.dart';
import 'package:smartlog_swm_mobile/shared/contracts/shared_contracts.dart';
import 'package:smartlog_swm_mobile/shared/theme/app_colors.dart';
import 'package:smartlog_swm_mobile/shared/theme/app_spacing.dart';
import 'package:smartlog_swm_mobile/shared/widgets/app_forbidden_state.dart';

class BarcodeScanPage extends ConsumerStatefulWidget {
  const BarcodeScanPage({super.key, required this.launchContext});

  final ScanLaunchContext launchContext;

  @override
  ConsumerState<BarcodeScanPage> createState() => _BarcodeScanPageState();
}

class _BarcodeScanPageState extends ConsumerState<BarcodeScanPage> {
  late final TextEditingController _lookupController;
  late final TextEditingController _referenceController;
  late final TextEditingController _warehouseController;
  late final TextEditingController _locationController;
  late final TextEditingController _quantityController;
  bool _didReturnResult = false;
  String? _cameraRuntimeError;

  @override
  void initState() {
    super.initState();
    _lookupController = TextEditingController(text: 'RCV-240325-001');
    _referenceController = TextEditingController(
      text: widget.launchContext.referenceId ?? '',
    );
    _warehouseController = TextEditingController(
      text: widget.launchContext.warehouseId ?? '',
    );
    _locationController = TextEditingController();
    _quantityController = TextEditingController();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(scanSessionControllerProvider(widget.launchContext).notifier)
          .requestCameraAccess();
    });
  }

  @override
  void dispose() {
    _lookupController.dispose();
    _referenceController.dispose();
    _warehouseController.dispose();
    _locationController.dispose();
    _quantityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = scanSessionControllerProvider(widget.launchContext);
    final scanState = ref.watch(provider);
    ref.listen<ScanSessionControllerState>(provider, _handleStateChanged);
    _syncControllers(scanState);

    final showReceiveForm = _showReceiveForm(scanState.session.state);
    final keyboardInset = MediaQuery.of(context).viewInsets.bottom;
    final keyboardVisible = keyboardInset > 0;

    return Scaffold(
      backgroundColor: const Color(0xFFF4FAFF),
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('Quét mã'),
        centerTitle: true,
        leading: IconButton(
          tooltip: 'Dong scan',
          onPressed: () => _closePage(context),
          icon: const Icon(Icons.arrow_back_rounded),
        ),
        actions: [
          IconButton(
            tooltip: 'Tuỳ chọn scan',
            onPressed: () {},
            icon: const Icon(Icons.filter_list_rounded),
          ),
        ],
      ),
      body: Stack(
        children: [
          Column(
            children: [
              _ScanModeStrip(selectedMode: widget.launchContext.mode),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(
                    bottom: showReceiveForm ? (keyboardVisible ? 0 : 310) : 0,
                  ),
                  child: _PreviewPanel(
                    state: scanState,
                    lookupController: _lookupController,
                    onLookup: _handleLookup,
                    onLookupNotFound: _lookupNotFoundScenario,
                    onRequestPermission: () {
                      _clearCameraRuntimeError();
                      ref
                          .read(
                            scanSessionControllerProvider(
                              widget.launchContext,
                            ).notifier,
                          )
                          .requestCameraAccess();
                    },
                    onCodeDetected: (code) {
                      return ref
                          .read(
                            scanSessionControllerProvider(
                              widget.launchContext,
                            ).notifier,
                          )
                          .onCodeDetected(code);
                    },
                    cameraRuntimeError: _cameraRuntimeError,
                    onCameraRuntimeError: _setCameraRuntimeError,
                    onRetryCameraRuntimeError: () {
                      _clearCameraRuntimeError();
                      ref
                          .read(
                            scanSessionControllerProvider(
                              widget.launchContext,
                            ).notifier,
                          )
                          .restartScanning();
                    },
                  ),
                ),
              ),
              if (scanState.session.state == ScanSessionState.lookupNotFound)
                Padding(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.md,
                    AppSpacing.md,
                    AppSpacing.md,
                    AppSpacing.sm,
                  ),
                  child: _StatusBanner(
                    icon: Icons.warning_amber_rounded,
                    toneColor: AppColors.danger,
                    message:
                        scanState.session.errorMessage ??
                        'Khong tim thay ma vua quet.',
                    actionLabel: 'Thu lai',
                    onAction: () {
                      ref
                          .read(
                            scanSessionControllerProvider(
                              widget.launchContext,
                            ).notifier,
                          )
                          .restartScanning();
                    },
                  ),
                ),
            ],
          ),
          if (showReceiveForm)
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: EdgeInsets.only(bottom: keyboardInset),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 760),
                  child: ReceiveScanFormSheet(
                    state: scanState,
                    referenceController: _referenceController,
                    warehouseController: _warehouseController,
                    locationController: _locationController,
                    quantityController: _quantityController,
                    onReferenceChanged: (value) {
                      ref
                          .read(
                            scanSessionControllerProvider(
                              widget.launchContext,
                            ).notifier,
                          )
                          .updateReferenceId(value);
                    },
                    onWarehouseChanged: (value) {
                      ref
                          .read(
                            scanSessionControllerProvider(
                              widget.launchContext,
                            ).notifier,
                          )
                          .updateWarehouseId(value);
                    },
                    onLocationChanged: (value) {
                      ref
                          .read(
                            scanSessionControllerProvider(
                              widget.launchContext,
                            ).notifier,
                          )
                          .updateResolvedLocationCode(value);
                    },
                    onQuantityChanged: (value) {
                      ref
                          .read(
                            scanSessionControllerProvider(
                              widget.launchContext,
                            ).notifier,
                          )
                          .updateQuantity(_parseQuantity(value));
                    },
                    onSubmit: _handleSubmit,
                    onRestart: () {
                      FocusScope.of(context).unfocus();
                      ref
                          .read(
                            scanSessionControllerProvider(
                              widget.launchContext,
                            ).notifier,
                          )
                          .restartScanning();
                    },
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Future<void> _handleLookup() async {
    FocusScope.of(context).unfocus();
    final lookupCode = _lookupController.text.trim().isEmpty
        ? 'RCV-240325-001'
        : _lookupController.text.trim();

    final provider = scanSessionControllerProvider(widget.launchContext);
    await ref.read(provider.notifier).lookupReceiveCode(lookupCode);
    final nextState = ref.read(provider);

    if (nextState.session.state == ScanSessionState.lookupSuccess) {
      ref.read(provider.notifier).prepareReceiveForm();
    }
  }

  Future<void> _lookupNotFoundScenario() async {
    _lookupController.text = 'NOT-FOUND';
    await _handleLookup();
  }

  Future<void> _handleSubmit() async {
    FocusScope.of(context).unfocus();

    final notifier = ref.read(
      scanSessionControllerProvider(widget.launchContext).notifier,
    );
    notifier.updateReferenceId(_referenceController.text);
    notifier.updateWarehouseId(_warehouseController.text);
    notifier.updateResolvedLocationCode(_locationController.text);
    notifier.updateQuantity(_parseQuantity(_quantityController.text));

    await notifier.submitReceive();
  }

  void _handleStateChanged(
    ScanSessionControllerState? previous,
    ScanSessionControllerState next,
  ) {
    if (_didReturnResult || next.flowResult == null) {
      return;
    }

    if (next.session.state != ScanSessionState.submitSuccess ||
        next.flowResult!.success != true) {
      return;
    }

    _didReturnResult = true;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }

      final navigator = Navigator.of(context);
      if (navigator.canPop()) {
        navigator.pop(next.flowResult);
        return;
      }

      _goToReturnLocation(context);
    });
  }

  void _syncControllers(ScanSessionControllerState state) {
    _syncControllerValue(
      _referenceController,
      state.session.referenceId ?? widget.launchContext.referenceId ?? '',
    );
    _syncControllerValue(
      _warehouseController,
      state.session.warehouseId ?? widget.launchContext.warehouseId ?? '',
    );
    _syncControllerValue(
      _locationController,
      state.session.resolvedLocationCode ?? '',
    );
    _syncControllerValue(
      _quantityController,
      _formatQuantity(state.session.quantity),
    );
  }

  void _closePage(BuildContext context) {
    final navigator = Navigator.of(context);
    if (navigator.canPop()) {
      navigator.pop();
      return;
    }

    _goToReturnLocation(context);
  }

  void _goToReturnLocation(BuildContext context) {
    try {
      final router = GoRouter.of(context);
      final location = resolveNamedRouteLocation(
        router: router,
        routeName: widget.launchContext.originRouteName,
        pathParameters: widget.launchContext.originRouteParams,
      );
      context.go(location ?? AppRoutePaths.home);
    } catch (_) {}
  }

  bool _showReceiveForm(ScanSessionState sessionState) {
    return sessionState == ScanSessionState.formReady ||
        sessionState == ScanSessionState.submitting ||
        sessionState == ScanSessionState.submitFailed ||
        sessionState == ScanSessionState.submitSuccess;
  }

  void _setCameraRuntimeError(String message) {
    if (!mounted || _cameraRuntimeError == message) {
      return;
    }

    setState(() {
      _cameraRuntimeError = message;
    });
  }

  void _clearCameraRuntimeError() {
    if (!mounted || _cameraRuntimeError == null) {
      return;
    }

    setState(() {
      _cameraRuntimeError = null;
    });
  }
}

class _ScanModeStrip extends StatelessWidget {
  const _ScanModeStrip({required this.selectedMode});

  final ScanMode selectedMode;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border(
          bottom: BorderSide(color: AppColors.border.withValues(alpha: 0.5)),
        ),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            _ModeChip(
              label: 'Nhập kho',
              selected: selectedMode == ScanMode.receive,
            ),
            const SizedBox(width: AppSpacing.xs),
            const _ModeChip(label: 'Xuất kho', selected: false),
            const SizedBox(width: AppSpacing.xs),
            const _ModeChip(label: 'Kiểm kê', selected: false),
            const SizedBox(width: AppSpacing.xs),
            const _ModeChip(label: 'Chuyển vị trí', selected: false),
          ],
        ),
      ),
    );
  }
}

class _ModeChip extends StatelessWidget {
  const _ModeChip({required this.label, required this.selected});

  final String label;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: selected ? AppColors.brand : const Color(0xFFDFF1FB),
        borderRadius: BorderRadius.circular(12),
        boxShadow: selected
            ? const [
                BoxShadow(
                  color: Color(0x0D000000),
                  blurRadius: 2,
                  offset: Offset(0, 1),
                ),
              ]
            : null,
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
          fontWeight: FontWeight.w700,
          color: selected ? AppColors.surface : AppColors.brand,
        ),
      ),
    );
  }
}

class _PreviewPanel extends StatelessWidget {
  const _PreviewPanel({
    required this.state,
    required this.lookupController,
    required this.onLookup,
    required this.onLookupNotFound,
    required this.onRequestPermission,
    required this.onCodeDetected,
    required this.cameraRuntimeError,
    required this.onCameraRuntimeError,
    required this.onRetryCameraRuntimeError,
  });

  final ScanSessionControllerState state;
  final TextEditingController lookupController;
  final Future<void> Function() onLookup;
  final Future<void> Function() onLookupNotFound;
  final VoidCallback onRequestPermission;
  final Future<void> Function(String code) onCodeDetected;
  final String? cameraRuntimeError;
  final ValueChanged<String> onCameraRuntimeError;
  final VoidCallback onRetryCameraRuntimeError;

  @override
  Widget build(BuildContext context) {
    final session = state.session;
    final cameraReady = session.cameraGranted;
    final isPending = session.state == ScanSessionState.permissionPending;
    final isDenied = session.state == ScanSessionState.cameraDenied;
    final isWorking = session.state == ScanSessionState.submitting;
    final hasRuntimeError = cameraRuntimeError != null;
    final manualFallbackEnabled =
        !isWorking && (cameraReady || isDenied || hasRuntimeError);

    return Container(
      key: const Key('barcode_scan_preview_panel'),
      color: const Color(0xFF001C39),
      child: Stack(
        children: [
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: const Alignment(-0.7, -0.9),
                  radius: 1.4,
                  colors: [
                    AppColors.surface.withValues(alpha: 0.12),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          if (cameraReady && !hasRuntimeError)
            Positioned.fill(
              child: _ScannerWidgetAdapter(
                key: Key('barcode_scan_camera_preview'),
                onCodeDetected: onCodeDetected,
                active: session.state == ScanSessionState.scanning,
                onRuntimeError: onCameraRuntimeError,
              ),
            )
          else if (hasRuntimeError)
            KeyedSubtree(
              key: const Key('barcode_scan_camera_runtime_error'),
              child: AppForbiddenState(
                title: 'Camera đang gặp lỗi',
                message:
                    cameraRuntimeError ??
                    'Không thể khởi động camera trong lúc này.',
                retryLabel: 'Khởi động lại camera',
                onRetry: onRetryCameraRuntimeError,
              ),
            )
          else if (isPending)
            const Center(
              child: _PermissionState(
                key: Key('barcode_scan_permission_pending'),
                icon: Icons.videocam_rounded,
                title: 'Dang xin quyen camera',
                message: 'Dang cap quyen de bat dau phien quet.',
                loading: true,
              ),
            )
          else if (isDenied)
            KeyedSubtree(
              key: const Key('barcode_scan_permission_denied'),
              child: AppForbiddenState(
                title: 'Cần quyền camera',
                message:
                    session.errorMessage ??
                    'Hãy cấp quyền camera để tiếp tục barcode receive.',
                retryLabel: 'Cấp quyền lại',
                onRetry: onRequestPermission,
              ),
            )
          else
            const Center(
              child: _PermissionState(
                icon: Icons.qr_code_scanner_rounded,
                title: 'Dang khoi dong phien quet',
                message: 'Moi truong demo dang chuan bi preview gia lap.',
              ),
            ),
          if (cameraReady) const Center(child: _ScanFrame()),
          Positioned(
            left: AppSpacing.md,
            right: AppSpacing.md,
            top: 200,
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md,
                  vertical: AppSpacing.xs,
                ),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.4),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.circle, size: 6, color: AppColors.warning),
                    const SizedBox(width: AppSpacing.xs),
                    Text(
                      'ĐƯA MÃ VÀO KHUNG',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: AppColors.surface,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            left: AppSpacing.md,
            right: AppSpacing.md,
            bottom: AppSpacing.md,
            child: Center(
              child: ElevatedButton.icon(
                key: const Key('barcode_scan_lookup_button'),
                onPressed: manualFallbackEnabled
                    ? () {
                        onLookup();
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.surface.withValues(alpha: 0.14),
                  foregroundColor: AppColors.surface,
                  elevation: 0,
                  side: BorderSide(
                    color: AppColors.surface.withValues(alpha: 0.2),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.xl,
                    vertical: AppSpacing.sm,
                  ),
                ),
                icon: const Icon(Icons.keyboard_alt_rounded),
                label: const Text('Nhập SKU tay'),
              ),
            ),
          ),
          Offstage(
            offstage: true,
            child: Column(
              children: [
                TextField(
                  key: const Key('barcode_scan_lookup_field'),
                  controller: lookupController,
                  enabled: cameraReady && !isWorking,
                ),
                OutlinedButton(
                  key: const Key('barcode_scan_not_found_button'),
                  onPressed: cameraReady && !isWorking
                      ? () {
                          onLookupNotFound();
                        }
                      : null,
                  child: const Text('not-found'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ScannerWidgetAdapter extends StatelessWidget {
  const _ScannerWidgetAdapter({
    super.key,
    required this.onCodeDetected,
    required this.active,
    required this.onRuntimeError,
  });

  final Future<void> Function(String code) onCodeDetected;
  final bool active;
  final ValueChanged<String> onRuntimeError;

  @override
  Widget build(BuildContext context) {
    return _ScannerWidgetAdapterView(
      onCodeDetected: onCodeDetected,
      active: active,
      onRuntimeError: onRuntimeError,
    );
  }
}

class _ScannerWidgetAdapterView extends StatefulWidget {
  const _ScannerWidgetAdapterView({
    required this.onCodeDetected,
    required this.active,
    required this.onRuntimeError,
  });

  final Future<void> Function(String code) onCodeDetected;
  final bool active;
  final ValueChanged<String> onRuntimeError;

  @override
  State<_ScannerWidgetAdapterView> createState() =>
      _ScannerWidgetAdapterViewState();
}

class _ScannerWidgetAdapterViewState extends State<_ScannerWidgetAdapterView> {
  late final bool _useFallbackPreview;
  MobileScannerController? _controller;
  String? _lastErrorMessage;

  @override
  void initState() {
    super.initState();
    _useFallbackPreview = _isWidgetTestRuntime();

    if (_useFallbackPreview) {
      return;
    }

    _controller = MobileScannerController(
      autoStart: false,
      facing: CameraFacing.back,
    );
    unawaited(_syncScannerActivity(widget.active));
  }

  @override
  void didUpdateWidget(covariant _ScannerWidgetAdapterView oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (_useFallbackPreview || oldWidget.active == widget.active) {
      return;
    }

    unawaited(_syncScannerActivity(widget.active));
  }

  @override
  void dispose() {
    if (!_useFallbackPreview && _controller != null) {
      unawaited(_controller!.dispose());
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_useFallbackPreview || _controller == null) {
      return const DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF0D2B4A), Color(0xFF031428)],
          ),
        ),
      );
    }

    return MobileScanner(
      controller: _controller,
      fit: BoxFit.cover,
      onDetect: (capture) {
        for (final barcode in capture.barcodes) {
          final rawValue = barcode.rawValue?.trim();
          if (rawValue == null || rawValue.isEmpty) {
            continue;
          }

          unawaited(widget.onCodeDetected(rawValue));
          break;
        }
      },
      placeholderBuilder: (context, child) {
        return const DecoratedBox(
          decoration: BoxDecoration(color: Color(0xFF031428)),
        );
      },
      errorBuilder: (context, error, child) {
        final errorMessage = error.toString();

        if (_lastErrorMessage != errorMessage) {
          _lastErrorMessage = errorMessage;
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (!mounted) {
              return;
            }

            widget.onRuntimeError(errorMessage);
          });
        }

        return const DecoratedBox(
          decoration: BoxDecoration(color: Color(0xFF031428)),
        );
      },
    );
  }

  Future<void> _syncScannerActivity(bool isActive) async {
    final controller = _controller;
    if (controller == null) {
      return;
    }

    if (isActive) {
      await controller.start();
      return;
    }

    await controller.stop();
  }
}

class _ScanFrame extends StatelessWidget {
  const _ScanFrame();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 256,
      height: 256,
      child: Stack(
        children: [
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: AppColors.surface.withValues(alpha: 0.18),
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          const _CornerMarker(alignment: Alignment.topLeft),
          const _CornerMarker(alignment: Alignment.topRight),
          const _CornerMarker(alignment: Alignment.bottomLeft),
          const _CornerMarker(alignment: Alignment.bottomRight),
          Positioned.fill(
            child: Center(
              child: Icon(
                Icons.qr_code_2_rounded,
                size: 56,
                color: AppColors.surface.withValues(alpha: 0.16),
              ),
            ),
          ),
          Positioned(
            left: -67,
            right: -67,
            top: 130,
            child: Container(
              height: 2,
              decoration: BoxDecoration(
                color: AppColors.warning,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.warning.withValues(alpha: 0.8),
                    blurRadius: 10,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CornerMarker extends StatelessWidget {
  const _CornerMarker({required this.alignment});

  final Alignment alignment;

  @override
  Widget build(BuildContext context) {
    final isTop = alignment.y < 0;
    final isLeft = alignment.x < 0;

    return Align(
      alignment: alignment,
      child: SizedBox(
        width: 32,
        height: 32,
        child: Stack(
          children: [
            Align(
              alignment: isTop ? Alignment.topCenter : Alignment.bottomCenter,
              child: Container(width: 16, height: 3, color: AppColors.warning),
            ),
            Align(
              alignment: isLeft ? Alignment.centerLeft : Alignment.centerRight,
              child: Container(width: 3, height: 16, color: AppColors.warning),
            ),
          ],
        ),
      ),
    );
  }
}

class _PermissionState extends StatelessWidget {
  const _PermissionState({
    super.key,
    required this.icon,
    required this.title,
    required this.message,
    this.loading = false,
  });

  final IconData icon;
  final String title;
  final String message;
  final bool loading;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.all(AppSpacing.xl),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: AppColors.surface.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(24),
            ),
            child: loading
                ? const Padding(
                    padding: EdgeInsets.all(AppSpacing.md),
                    child: CircularProgressIndicator(strokeWidth: 2.4),
                  )
                : Icon(icon, color: AppColors.surface, size: 34),
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            title,
            style: theme.textTheme.titleLarge?.copyWith(
              color: AppColors.surface,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            message,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: AppColors.surface.withValues(alpha: 0.74),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusBanner extends StatelessWidget {
  const _StatusBanner({
    required this.icon,
    required this.toneColor,
    required this.message,
    required this.actionLabel,
    required this.onAction,
  });

  final IconData icon;
  final Color toneColor;
  final String message;
  final String actionLabel;
  final VoidCallback onAction;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: toneColor.withValues(alpha: 0.08),
        borderRadius: AppSpacing.controlRadius,
        border: Border.all(color: toneColor.withValues(alpha: 0.12)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: toneColor),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              message,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          TextButton(onPressed: onAction, child: Text(actionLabel)),
        ],
      ),
    );
  }
}

void _syncControllerValue(TextEditingController controller, String value) {
  if (controller.text == value) {
    return;
  }

  controller.value = TextEditingValue(
    text: value,
    selection: TextSelection.collapsed(offset: value.length),
  );
}

String _formatQuantity(double? value) {
  if (value == null) {
    return '';
  }

  if (value.truncateToDouble() == value) {
    return value.toStringAsFixed(0);
  }

  return value.toString();
}

double _parseQuantity(String value) {
  final normalized = value.trim().replaceAll(',', '.');
  return double.tryParse(normalized) ?? 0;
}

bool _isWidgetTestRuntime() {
  final bindingType = WidgetsBinding.instance.runtimeType.toString();
  return bindingType.contains('TestWidgetsFlutterBinding');
}
