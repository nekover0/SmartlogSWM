import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:smartlog_swm_mobile/features/inbound/data/contracts/receipt_contract.dart';
import 'package:smartlog_swm_mobile/shared/theme/app_colors.dart';
import 'package:smartlog_swm_mobile/shared/theme/app_spacing.dart';

class ReceiptLineTile extends StatelessWidget {
  const ReceiptLineTile({
    super.key,
    required this.line,
  });

  final ReceiptLineEntity line;

  @override
  Widget build(BuildContext context) {
    final varianceColor = _varianceColor(line.varianceQty);

    return Card(
      key: Key('receipt_line_${line.id}'),
      child: Padding(
        padding: AppSpacing.compactPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        line.itemCode,
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          color: AppColors.brand,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        line.itemName,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.sm,
                    vertical: AppSpacing.xs,
                  ),
                  decoration: BoxDecoration(
                    color: varianceColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    _lineStatusLabel(line.varianceQty),
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: varianceColor,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            Row(
              children: [
                Expanded(
                  child: _QtyMetric(
                    label: 'Expected',
                    value: '${_qtyFormat.format(line.expectedQty)} ${line.uomCode}',
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: _QtyMetric(
                    label: 'Actual',
                    value: '${_qtyFormat.format(line.receivedQty)} ${line.uomCode}',
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: _QtyMetric(
                    label: 'Variance',
                    value:
                        '${line.varianceQty > 0 ? '+' : ''}${_qtyFormat.format(line.varianceQty)} ${line.uomCode}',
                    valueColor: varianceColor,
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

class _QtyMetric extends StatelessWidget {
  const _QtyMetric({
    required this.label,
    required this.value,
    this.valueColor = AppColors.textPrimary,
  });

  final String label;
  final String value;
  final Color valueColor;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
            color: valueColor,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }
}

final NumberFormat _qtyFormat = NumberFormat('#,##0.##');

Color _varianceColor(double varianceQty) {
  final absoluteVariance = varianceQty.abs();
  if (absoluteVariance >= 1) {
    return AppColors.danger;
  }
  if (absoluteVariance > 0) {
    return AppColors.warning;
  }
  return AppColors.success;
}

String _lineStatusLabel(double varianceQty) {
  if (varianceQty == 0) {
    return 'Khớp';
  }
  if (varianceQty > 0) {
    return 'Dư';
  }
  return 'Thiếu';
}
