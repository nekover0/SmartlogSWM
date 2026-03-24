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
      elevation: 18,
      borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.lg,
          AppSpacing.sm,
          AppSpacing.lg,
          AppSpacing.lg,
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
            Text(
              'Xac nhan nhap kho',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              'Hoan tat form receive de dong phien scan va tra ket qua cho route goi.',
              style: theme.textTheme.bodySmall?.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            Wrap(
              spacing: AppSpacing.xs,
              runSpacing: AppSpacing.xs,
              children: [
                _InfoPill(label: 'Lookup: ${session.lookupCode ?? 'demo'}'),
                _InfoPill(
                  label: 'SKU: ${session.resolvedItemCode ?? 'chua tim thay'}',
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            TextField(
              key: const Key('receive_form_reference_field'),
              controller: referenceController,
              enabled: !isSubmitting,
              decoration: const InputDecoration(
                labelText: 'Reference ID',
                hintText: 'Nhap id phieu nhap',
              ),
              onChanged: onReferenceChanged,
            ),
            const SizedBox(height: AppSpacing.sm),
            TextField(
              key: const Key('receive_form_warehouse_field'),
              controller: warehouseController,
              enabled: !isSubmitting,
              decoration: const InputDecoration(
                labelText: 'Warehouse ID',
                hintText: 'Kho tiep nhan',
              ),
              onChanged: onWarehouseChanged,
            ),
            const SizedBox(height: AppSpacing.sm),
            TextField(
              key: const Key('receive_form_location_field'),
              controller: locationController,
              enabled: !isSubmitting,
              decoration: const InputDecoration(
                labelText: 'Location',
                hintText: 'Vi tri nhap hang',
              ),
              onChanged: onLocationChanged,
            ),
            const SizedBox(height: AppSpacing.sm),
            TextField(
              key: const Key('receive_form_quantity_field'),
              controller: quantityController,
              enabled: !isSubmitting,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              decoration: const InputDecoration(
                labelText: 'Quantity',
                hintText: 'So luong nhap',
              ),
              onChanged: onQuantityChanged,
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
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    key: const Key('receive_form_restart_button'),
                    onPressed: isSubmitting ? null : onRestart,
                    icon: const Icon(Icons.qr_code_scanner_rounded),
                    label: const Text('Quet lai'),
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
                    label: Text(isSubmitting ? 'Dang gui...' : 'Xac nhan'),
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

class _InfoPill extends StatelessWidget {
  const _InfoPill({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: AppColors.brand.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: AppColors.brand,
              fontWeight: FontWeight.w700,
            ),
      ),
    );
  }
}
