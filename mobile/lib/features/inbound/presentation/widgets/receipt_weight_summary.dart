import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:smartlog_swm_mobile/features/inbound/data/contracts/receipt_contract.dart';
import 'package:smartlog_swm_mobile/shared/theme/app_colors.dart';
import 'package:smartlog_swm_mobile/shared/theme/app_spacing.dart';

class ReceiptWeightSummary extends StatelessWidget {
  const ReceiptWeightSummary({
    super.key,
    required this.receipt,
    this.warningThresholdKg = 100,
  });

  final ReceiptEntity receipt;
  final double warningThresholdKg;

  @override
  Widget build(BuildContext context) {
    final showWarning = receipt.varianceWeightKg.abs() >= warningThresholdKg;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Khối lượng',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Row(
          children: [
            Expanded(
              child: _WeightTile(
                label: 'Cân cảng',
                value: receipt.portWeightKg == null
                    ? 'Chưa có'
                    : '${_weightFormat.format(receipt.portWeightKg)} kg',
                valueColor: AppColors.textPrimary,
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: _WeightTile(
                label: 'Dự kiến',
                value: '${_weightFormat.format(receipt.expectedWeightKg)} kg',
                valueColor: AppColors.brand,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        Row(
          children: [
            Expanded(
              child: _WeightTile(
                label: 'Thực nhận',
                value: '${_weightFormat.format(receipt.receivedWeightKg)} kg',
                valueColor: AppColors.success,
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: _WeightTile(
                label: 'Chênh lệch',
                value:
                    '${receipt.varianceWeightKg > 0 ? '+' : ''}${_weightFormat.format(receipt.varianceWeightKg)} kg',
                valueColor: _varianceColor(receipt.varianceWeightKg),
              ),
            ),
          ],
        ),
        if (showWarning) ...[
          const SizedBox(height: AppSpacing.sm),
          Container(
            key: const Key('receipt_variance_warning'),
            padding: AppSpacing.compactPadding,
            decoration: BoxDecoration(
              color: AppColors.danger.withValues(alpha: 0.1),
              borderRadius: AppSpacing.controlRadius,
              border: Border.all(
                color: AppColors.danger.withValues(alpha: 0.24),
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.warning_amber_rounded,
                  color: AppColors.danger,
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Text(
                    'Chênh lệch khối lượng đã vượt ngưỡng ${_weightFormat.format(warningThresholdKg)} kg. Cần xác nhận lại trước khi hoàn tất nhập.',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.danger,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}

class _WeightTile extends StatelessWidget {
  const _WeightTile({
    required this.label,
    required this.value,
    required this.valueColor,
  });

  final String label;
  final String value;
  final Color valueColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: AppSpacing.compactPadding,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppSpacing.controlRadius,
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            value,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: valueColor,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

final NumberFormat _weightFormat = NumberFormat('#,##0.#');

Color _varianceColor(double varianceWeightKg) {
  final absoluteVariance = varianceWeightKg.abs();
  if (absoluteVariance >= 100) {
    return AppColors.danger;
  }
  if (absoluteVariance >= 20) {
    return AppColors.warning;
  }
  return AppColors.textPrimary;
}
