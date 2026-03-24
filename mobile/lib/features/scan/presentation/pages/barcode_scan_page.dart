import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:smartlog_swm_mobile/app/router/app_router.dart';
import 'package:smartlog_swm_mobile/app/router/app_route_paths.dart';
import 'package:smartlog_swm_mobile/features/scan/application/controllers/scan_session_controller.dart';
import 'package:smartlog_swm_mobile/features/scan/data/contracts/scan_session_contract.dart';
import 'package:smartlog_swm_mobile/features/scan/domain/models/scan_launch_context.dart';
import 'package:smartlog_swm_mobile/features/scan/presentation/widgets/receive_scan_form_sheet.dart';
import 'package:smartlog_swm_mobile/features/scan/presentation/widgets/scan_action_selector.dart';
import 'package:smartlog_swm_mobile/features/scan/presentation/widgets/scanner_overlay.dart';
import 'package:smartlog_swm_mobile/shared/contracts/shared_contracts.dart';
import 'package:smartlog_swm_mobile/shared/theme/app_colors.dart';
import 'package:smartlog_swm_mobile/shared/theme/app_spacing.dart';

class BarcodeScanPage extends ConsumerStatefulWidget {
  const BarcodeScanPage({
    super.key,
    required this.launchContext,
  });

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

    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan'),
        leading: IconButton(
          tooltip: 'Dong scan',
          onPressed: () => _closePage(context),
          icon: const Icon(Icons.close_rounded),
        ),
      ),
      body: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: <Color>[
              Color(0xFFE8EEF8),
              AppColors.background,
              Color(0xFFF8FAFD),
            ],
          ),
        ),
        child: Stack(
          children: [
            ListView(
              padding: EdgeInsets.fromLTRB(
                AppSpacing.md,
                AppSpacing.md,
                AppSpacing.md,
                showReceiveForm ? 380 : AppSpacing.xxl,
              ),
              children: [
                ScanActionSelector(
                  selectedMode: widget.launchContext.mode,
                  supportedModes: const <ScanMode>{ScanMode.receive},
                ),
                const SizedBox(height: AppSpacing.lg),
                _PreviewPanel(
                  state: scanState,
                  lookupController: _lookupController,
                  onLookup: _handleLookup,
                  onLookupNotFound: _lookupFixtureNotFound,
                  onRequestPermission: () {
                    ref
                        .read(
                          scanSessionControllerProvider(widget.launchContext)
                              .notifier,
                        )
                        .requestCameraAccess();
                  },
                ),
                if (scanState.session.state == ScanSessionState.lookupNotFound)
                  Padding(
                    padding: const EdgeInsets.only(top: AppSpacing.md),
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
                  padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom,
                  ),
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

  Future<void> _lookupFixtureNotFound() async {
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
}

class _PreviewPanel extends StatelessWidget {
  const _PreviewPanel({
    required this.state,
    required this.lookupController,
    required this.onLookup,
    required this.onLookupNotFound,
    required this.onRequestPermission,
  });

  final ScanSessionControllerState state;
  final TextEditingController lookupController;
  final Future<void> Function() onLookup;
  final Future<void> Function() onLookupNotFound;
  final VoidCallback onRequestPermission;

  @override
  Widget build(BuildContext context) {
    final session = state.session;
    final theme = Theme.of(context);
    final cameraReady = session.cameraGranted;
    final isPending = session.state == ScanSessionState.permissionPending;
    final isDenied = session.state == ScanSessionState.cameraDenied;
    final isWorking = session.state == ScanSessionState.submitting;

    return Container(
      key: const Key('barcode_scan_preview_panel'),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(32),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: <Color>[Color(0xFF12253F), Color(0xFF09131F)],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.18),
            blurRadius: 24,
            offset: const Offset(0, 14),
          ),
        ],
      ),
      child: Column(
        children: [
          SizedBox(
            height: 420,
            child: Stack(
              children: [
                Positioned.fill(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(32),
                      ),
                      gradient: RadialGradient(
                        center: const Alignment(-0.3, -0.7),
                        radius: 1.2,
                        colors: [
                          AppColors.brandAccent.withValues(alpha: 0.46),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                ),
                if (cameraReady) ...[
                  const Positioned(
                    left: AppSpacing.lg,
                    top: AppSpacing.lg,
                    child: _TopPreviewBadge(
                      icon: Icons.bolt_rounded,
                      label: 'Demo receive fixture',
                    ),
                  ),
                  if (session.resolvedItemCode != null)
                    Positioned(
                      right: AppSpacing.lg,
                      top: AppSpacing.lg,
                      child: _TopPreviewBadge(
                        icon: Icons.inventory_2_rounded,
                        label: session.resolvedItemCode!,
                      ),
                    ),
                  ScannerOverlay(
                    title: _overlayTitle(session.state),
                    subtitle: _overlaySubtitle(session),
                  ),
                ] else if (isPending)
                  const Center(
                    child: _PermissionState(
                      key: Key('barcode_scan_permission_pending'),
                      icon: Icons.videocam_rounded,
                      title: 'Dang xin quyen camera',
                      message:
                          'Ban build dau tien dung preview gia lap nhung van render day du state permission.',
                      loading: true,
                    ),
                  )
                else if (isDenied)
                  Center(
                    child: _PermissionState(
                      key: const Key('barcode_scan_permission_denied'),
                      icon: Icons.no_photography_rounded,
                      title: 'Can quyen camera',
                      message:
                          session.errorMessage ??
                          'Hay cap quyen camera de tiep tuc barcode receive.',
                      actionLabel: 'Cap quyen lai',
                      onAction: onRequestPermission,
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
              ],
            ),
          ),
          Container(
            padding: AppSpacing.cardPadding,
            decoration: BoxDecoration(
              color: AppColors.surface.withValues(alpha: 0.08),
              borderRadius: const BorderRadius.vertical(
                bottom: Radius.circular(32),
              ),
              border: Border(
                top: BorderSide(
                  color: AppColors.surface.withValues(alpha: 0.08),
                ),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Tra ma tu preview gia lap',
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: AppColors.surface,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  cameraReady
                      ? 'Nhap barcode/QR de goi fixture lookup cho luong receive.'
                      : 'Action lookup se mo sau khi state permission cho phep quet.',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: AppColors.surface.withValues(alpha: 0.74),
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        key: const Key('barcode_scan_lookup_field'),
                        controller: lookupController,
                        enabled: cameraReady && !isWorking,
                        textInputAction: TextInputAction.search,
                        onSubmitted: (_) {
                          onLookup();
                        },
                        decoration: const InputDecoration(
                          hintText: 'RCV-240325-001 hoac NOT-FOUND',
                          prefixIcon: Icon(Icons.document_scanner_outlined),
                        ),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    ElevatedButton.icon(
                      key: const Key('barcode_scan_lookup_button'),
                      onPressed: cameraReady && !isWorking
                          ? () {
                              onLookup();
                            }
                          : null,
                      icon: const Icon(Icons.center_focus_strong_rounded),
                      label: const Text('Tra'),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.md),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        key: const Key('barcode_scan_not_found_button'),
                        onPressed: cameraReady && !isWorking
                            ? () {
                                onLookupNotFound();
                              }
                            : null,
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.surface,
                          side: BorderSide(
                            color: AppColors.surface.withValues(alpha: 0.16),
                          ),
                        ),
                        icon: const Icon(Icons.error_outline_rounded),
                        label: const Text('Fixture loi'),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    _ToolBadge(
                      icon: Icons.flashlight_off_rounded,
                      label: 'Flash',
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    _ToolBadge(
                      icon: Icons.cameraswitch_outlined,
                      label: 'Cam',
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
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
    this.actionLabel,
    this.onAction,
  });

  final IconData icon;
  final String title;
  final String message;
  final bool loading;
  final String? actionLabel;
  final VoidCallback? onAction;

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
          if (actionLabel != null && onAction != null) ...[
            const SizedBox(height: AppSpacing.md),
            ElevatedButton.icon(
              onPressed: onAction,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.surface,
                foregroundColor: AppColors.brand,
              ),
              icon: const Icon(Icons.camera_alt_rounded),
              label: Text(actionLabel!),
            ),
          ],
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

class _TopPreviewBadge extends StatelessWidget {
  const _TopPreviewBadge({
    required this.icon,
    required this.label,
  });

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.34),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: AppColors.surface),
          const SizedBox(width: AppSpacing.xs),
          Text(
            label,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: AppColors.surface,
                  fontWeight: FontWeight.w700,
                ),
          ),
        ],
      ),
    );
  }
}

class _ToolBadge extends StatelessWidget {
  const _ToolBadge({
    required this.icon,
    required this.label,
  });

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: AppColors.surface.withValues(alpha: 0.08),
        borderRadius: AppSpacing.controlRadius,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18, color: AppColors.surface),
          const SizedBox(width: AppSpacing.xs),
          Text(
            label,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: AppColors.surface,
                  fontWeight: FontWeight.w700,
                ),
          ),
        ],
      ),
    );
  }
}

String _overlayTitle(ScanSessionState state) {
  return switch (state) {
    ScanSessionState.lookupSuccess => 'Ma hop le',
    ScanSessionState.formReady => 'Form receive san sang',
    ScanSessionState.submitting => 'Dang chot phien scan',
    ScanSessionState.submitSuccess => 'Nhap kho thanh cong',
    ScanSessionState.lookupNotFound => 'Khong tim thay ma',
    _ => 'Dua ma vao khung',
  };
}

String _overlaySubtitle(ScanSessionEntity session) {
  return switch (session.state) {
    ScanSessionState.formReady ||
    ScanSessionState.submitting ||
    ScanSessionState.submitSuccess =>
      'SKU ${session.resolvedItemCode ?? 'unknown'} dang cho xac nhan so luong va vi tri.',
    ScanSessionState.lookupSuccess =>
      'Lookup hoan tat, chuan bi mo bottom sheet nhap kho.',
    ScanSessionState.lookupNotFound =>
      session.errorMessage ?? 'Khong co du lieu fixture khop voi ma vua nhap.',
    _ => 'Ban demo nay dung text input de gia lap barcode/QR receive.',
  };
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
