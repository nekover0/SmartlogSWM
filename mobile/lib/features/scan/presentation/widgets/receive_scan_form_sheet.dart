import 'package:flutter/material.dart';
import 'package:smartlog_swm_mobile/features/scan/application/controllers/scan_session_controller.dart';
import 'package:smartlog_swm_mobile/shared/contracts/shared_contracts.dart';
import 'package:smartlog_swm_mobile/shared/theme/app_colors.dart';
import 'package:smartlog_swm_mobile/shared/theme/app_spacing.dart';

class ReceiveScanFormSheet extends StatelessWidget {
  const ReceiveScanFormSheet({
    super.key,
    required this.state,
    required this.referenceController,
    required this.warehouseController,
    required this.locationController,
    required this.quantityController,
    required this.onReferenceChanged,
    required this.onWarehouseChanged,
    required this.onLocationChanged,
    required this.onQuantityChanged,
    required this.onSubmit,
    required this.onRestart,
  });

  final ScanSessionControllerState state;
  final TextEditingController referenceController;
  final TextEditingController warehouseController;
  final TextEditingController locationController;
  final TextEditingController quantityController;
  final ValueChanged<String> onReferenceChanged;
  final ValueChanged<String> onWarehouseChanged;
  final ValueChanged<String> onLocationChanged;
  final ValueChanged<String> onQuantityChanged;
  final VoidCallback onSubmit;
  final VoidCallback onRestart;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final session = state.session;
    final isSubmitting = session.state == ScanSessionState.submitting;
    final hasError =
        session.errorMessage != null &&
        session.errorMessage!.trim().isNotEmpty &&
        session.state != ScanSessionState.lookupNotFound;

    return Material(
      key: const Key('receive_form_sheet'),
      color: AppColors.surface,
      elevation: 24,
      borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.xl,
          AppSpacing.sm,
          AppSpacing.xl,
          AppSpacing.xl,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 44,
                height: 5,
                decoration: BoxDecoration(
                  color: AppColors.border,
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Mã hàng: ${session.lookupCode ?? 'IND-992-BX'}',
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: AppColors.textSecondary,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Hydraulic Valve X-40',
                        style: theme.textTheme.headlineSmall?.copyWith(
                          color: AppColors.brand,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        'SKU: ${session.resolvedItemCode ?? 'SKU-MILK-18L'}',
                        style: theme.textTheme.labelMedium?.copyWith(
                          color: AppColors.brand,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.xs,
                    vertical: AppSpacing.xxs,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.brand.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(2),
                  ),
                  child: Text(
                    'VALID',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: AppColors.brand,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            Container(
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: AppColors.border.withValues(alpha: 0.6),
                  ),
                  bottom: BorderSide(
                    color: AppColors.border.withValues(alpha: 0.6),
                  ),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: _InfoLine(
                      label: 'Vị trí hiện tại',
                      value: session.resolvedLocationCode ?? 'A-12-04',
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  const Expanded(
                    child: _InfoLine(label: 'Tồn kho', value: '124 PCS'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Số lượng',
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: AppColors.textSecondary,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      TextField(
                        key: const Key('receive_form_quantity_field'),
                        controller: quantityController,
                        enabled: !isSubmitting,
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        decoration: const InputDecoration(hintText: '12'),
                        onChanged: onQuantityChanged,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Vị trí đích',
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: AppColors.textSecondary,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      TextField(
                        key: const Key('receive_form_location_field'),
                        controller: locationController,
                        enabled: !isSubmitting,
                        decoration: const InputDecoration(hintText: 'B-05-11'),
                        onChanged: onLocationChanged,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            if (hasError) ...[
              const SizedBox(height: AppSpacing.md),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: AppColors.danger.withValues(alpha: 0.08),
                  borderRadius: AppSpacing.controlRadius,
                  border: Border.all(
                    color: AppColors.danger.withValues(alpha: 0.16),
                  ),
                ),
                child: Text(
                  session.errorMessage!,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: AppColors.danger,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
            const SizedBox(height: AppSpacing.md),
            Offstage(
              offstage: true,
              child: Column(
                children: [
                  TextField(
                    key: const Key('receive_form_reference_field'),
                    controller: referenceController,
                    onChanged: onReferenceChanged,
                  ),
                  TextField(
                    key: const Key('receive_form_warehouse_field'),
                    controller: warehouseController,
                    onChanged: onWarehouseChanged,
                  ),
                ],
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    key: const Key('receive_form_restart_button'),
                    onPressed: isSubmitting ? null : onRestart,
                    icon: const Icon(Icons.qr_code_scanner_rounded),
                    label: const Text('Quét tiếp'),
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: ElevatedButton.icon(
                    key: const Key('receive_form_submit_button'),
                    onPressed: isSubmitting ? null : onSubmit,
                    icon: isSubmitting
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.check_rounded),
                    label: Text(isSubmitting ? 'Đang gửi...' : 'XÁC NHẬN'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoLine extends StatelessWidget {
  const _InfoLine({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: theme.textTheme.labelSmall?.copyWith(
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w700,
            letterSpacing: 1,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: theme.textTheme.titleSmall?.copyWith(
            color: AppColors.brand,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}
