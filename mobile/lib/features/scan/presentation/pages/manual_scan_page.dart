import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:smartlog_swm_mobile/app/router/app_route_paths.dart';
import 'package:smartlog_swm_mobile/app/router/app_router.dart';
import 'package:smartlog_swm_mobile/features/scan/application/controllers/scan_session_controller.dart';
import 'package:smartlog_swm_mobile/features/scan/domain/models/scan_launch_context.dart';
import 'package:smartlog_swm_mobile/shared/contracts/shared_contracts.dart';
import 'package:smartlog_swm_mobile/shared/theme/app_colors.dart';
import 'package:smartlog_swm_mobile/shared/theme/app_spacing.dart';

class ManualScanPage extends ConsumerStatefulWidget {
  const ManualScanPage({super.key, required this.launchContext});

  final ScanLaunchContext launchContext;

  @override
  ConsumerState<ManualScanPage> createState() => _ManualScanPageState();
}

class _ManualScanPageState extends ConsumerState<ManualScanPage> {
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

    final session = scanState.session;
    final isLookingUp = session.state == ScanSessionState.scanning;
    final isSubmitting = session.state == ScanSessionState.submitting;
    final canShowForm = _showReceiveForm(session.state);

    return Scaffold(
      backgroundColor: const Color(0xFFF4FAFF),
      appBar: AppBar(
        title: const Text('Nhập mã thủ công'),
        centerTitle: true,
        leading: IconButton(
          tooltip: 'Đóng nhập tay',
          onPressed: () => _closePage(context),
          icon: const Icon(Icons.arrow_back_rounded),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: AppSpacing.pagePadding,
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 760),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _ScanModeStrip(selectedMode: widget.launchContext.mode),
                  const SizedBox(height: AppSpacing.md),
                  Card(
                    child: Padding(
                      padding: AppSpacing.cardPadding,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Tra cứu mã bằng tay',
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(fontWeight: FontWeight.w700),
                          ),
                          const SizedBox(height: AppSpacing.xs),
                          Text(
                            'Nhập mã giao dịch / SKU để mở nhanh form xác nhận.',
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(color: AppColors.textSecondary),
                          ),
                          const SizedBox(height: AppSpacing.md),
                          TextField(
                            key: const Key('manual_scan_lookup_field'),
                            controller: _lookupController,
                            enabled: !isLookingUp && !isSubmitting,
                            decoration: const InputDecoration(
                              labelText: 'Mã tra cứu',
                              hintText: 'Ví dụ: RCV-240325-001',
                              prefixIcon: Icon(Icons.search_rounded),
                            ),
                            textInputAction: TextInputAction.search,
                            onSubmitted: (_) => _handleLookup(),
                          ),
                          const SizedBox(height: AppSpacing.md),
                          Row(
                            children: [
                              Expanded(
                                child: ElevatedButton.icon(
                                  key: const Key('manual_scan_lookup_button'),
                                  onPressed: isLookingUp || isSubmitting
                                      ? null
                                      : _handleLookup,
                                  icon: isLookingUp
                                      ? const SizedBox(
                                          width: 18,
                                          height: 18,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                          ),
                                        )
                                      : const Icon(Icons.search_rounded),
                                  label: Text(
                                    isLookingUp
                                        ? 'Đang tra cứu...'
                                        : 'Tra cứu mã',
                                  ),
                                ),
                              ),
                              const SizedBox(width: AppSpacing.sm),
                              OutlinedButton(
                                key: const Key('manual_scan_not_found_button'),
                                onPressed: isLookingUp || isSubmitting
                                    ? null
                                    : _lookupNotFoundScenario,
                                child: const Text('Giả lập không tìm thấy'),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (session.state == ScanSessionState.lookupNotFound)
                    Padding(
                      padding: const EdgeInsets.only(top: AppSpacing.md),
                      child: _StatusBanner(
                        icon: Icons.warning_amber_rounded,
                        toneColor: AppColors.danger,
                        message:
                            session.errorMessage ??
                            'Không tìm thấy mã đã nhập, hãy kiểm tra lại.',
                        actionLabel: 'Thử lại',
                        onAction: _handleLookup,
                      ),
                    ),
                  if (session.state == ScanSessionState.submitFailed)
                    Padding(
                      padding: const EdgeInsets.only(top: AppSpacing.md),
                      child: _StatusBanner(
                        icon: Icons.error_outline_rounded,
                        toneColor: AppColors.danger,
                        message:
                            session.errorMessage ??
                            'Gửi giao dịch thất bại, vui lòng thử lại.',
                        actionLabel: 'Gửi lại',
                        onAction: _handleSubmit,
                      ),
                    ),
                  if (canShowForm) ...[
                    const SizedBox(height: AppSpacing.md),
                    Card(
                      child: Padding(
                        padding: AppSpacing.cardPadding,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: AppSpacing.sm,
                                    vertical: AppSpacing.xxs,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.brand.withValues(
                                      alpha: 0.1,
                                    ),
                                    borderRadius: BorderRadius.circular(999),
                                  ),
                                  child: Text(
                                    'VALID',
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelSmall
                                        ?.copyWith(
                                          color: AppColors.brand,
                                          fontWeight: FontWeight.w800,
                                        ),
                                  ),
                                ),
                                const Spacer(),
                                Text(
                                  'SKU: ${session.resolvedItemCode ?? '--'}',
                                  style: Theme.of(context).textTheme.labelMedium
                                      ?.copyWith(
                                        color: AppColors.textSecondary,
                                        fontWeight: FontWeight.w700,
                                      ),
                                ),
                              ],
                            ),
                            const SizedBox(height: AppSpacing.sm),
                            Text(
                              'Mã đã chọn: ${session.lookupCode ?? '--'}',
                              style: Theme.of(context).textTheme.titleMedium
                                  ?.copyWith(fontWeight: FontWeight.w700),
                            ),
                            const SizedBox(height: AppSpacing.xs),
                            Text(
                              'Vị trí hiện tại: ${session.resolvedLocationCode ?? 'A-12-04'}',
                              style: Theme.of(context).textTheme.bodyMedium
                                  ?.copyWith(color: AppColors.textSecondary),
                            ),
                            const SizedBox(height: AppSpacing.lg),
                            TextField(
                              key: const Key('manual_scan_reference_field'),
                              controller: _referenceController,
                              enabled: !isSubmitting,
                              decoration: const InputDecoration(
                                labelText: 'Mã chứng từ tham chiếu',
                                hintText: 'Ví dụ: RCV-240325-001',
                              ),
                            ),
                            const SizedBox(height: AppSpacing.md),
                            TextField(
                              key: const Key('manual_scan_warehouse_field'),
                              controller: _warehouseController,
                              enabled: !isSubmitting,
                              decoration: const InputDecoration(
                                labelText: 'Mã kho',
                                hintText: 'Ví dụ: WH-HCM-01',
                              ),
                            ),
                            const SizedBox(height: AppSpacing.md),
                            TextField(
                              key: const Key('manual_scan_location_field'),
                              controller: _locationController,
                              enabled: !isSubmitting,
                              decoration: const InputDecoration(
                                labelText: 'Vị trí đích',
                                hintText: 'Ví dụ: A-12-04',
                              ),
                            ),
                            const SizedBox(height: AppSpacing.md),
                            TextField(
                              key: const Key('manual_scan_quantity_field'),
                              controller: _quantityController,
                              enabled: !isSubmitting,
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                    decimal: true,
                                  ),
                              decoration: const InputDecoration(
                                labelText: 'Số lượng',
                                hintText: 'Ví dụ: 12',
                              ),
                            ),
                            const SizedBox(height: AppSpacing.lg),
                            Row(
                              children: [
                                Expanded(
                                  child: OutlinedButton(
                                    onPressed: isSubmitting
                                        ? null
                                        : _restartReceiveFlow,
                                    child: const Text('Quét tiếp'),
                                  ),
                                ),
                                const SizedBox(width: AppSpacing.sm),
                                Expanded(
                                  child: ElevatedButton.icon(
                                    key: const Key('manual_scan_submit_button'),
                                    onPressed: isSubmitting
                                        ? null
                                        : _handleSubmit,
                                    icon: isSubmitting
                                        ? const SizedBox(
                                            width: 18,
                                            height: 18,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2,
                                            ),
                                          )
                                        : const Icon(Icons.check_rounded),
                                    label: Text(
                                      isSubmitting
                                          ? 'Đang xác nhận...'
                                          : 'Xác nhận thao tác',
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
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

  void _restartReceiveFlow() {
    ref
        .read(scanSessionControllerProvider(widget.launchContext).notifier)
        .restartScanning();
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
        borderRadius: AppSpacing.controlRadius,
        border: Border.all(color: AppColors.border.withValues(alpha: 0.5)),
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
