import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:smartlog_swm_mobile/features/inbound/data/contracts/receipt_contract.dart';
import 'package:smartlog_swm_mobile/shared/contracts/shared_contracts.dart';
import 'package:smartlog_swm_mobile/shared/theme/app_colors.dart';
import 'package:smartlog_swm_mobile/shared/theme/app_spacing.dart';

class ReceiptCard extends StatelessWidget {
  const ReceiptCard({super.key, required this.receipt, this.onOpen});

  final ReceiptEntity receipt;
  final VoidCallback? onOpen;

  @override
  Widget build(BuildContext context) {
    final statusColor = _statusColor(receipt.status);
    final theme = Theme.of(context);
    final actionLabel =
        _featuredAction(receipt.availableActions)?.label ?? 'Xem phiếu';
    final statusLabel = _statusLabel(receipt.status);
    final plate = receipt.vehicle.plateNumber?.trim();
    final poOrBl = receipt.purchaseOrderNo?.trim().isNotEmpty == true
        ? receipt.purchaseOrderNo!.trim()
        : (receipt.billOfLadingNo?.trim().isNotEmpty == true
              ? receipt.billOfLadingNo!.trim()
              : '--');

    return Card(
      key: Key('receipt_card_${receipt.id}'),
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(color: statusColor.withValues(alpha: 0.35)),
      ),
      child: InkWell(
        onTap: onOpen,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              receipt.receiptNo,
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            const SizedBox(width: AppSpacing.xs),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: AppSpacing.xs,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: statusColor.withValues(alpha: 0.14),
                                borderRadius: BorderRadius.circular(2),
                              ),
                              child: Text(
                                statusLabel,
                                style: theme.textTheme.labelSmall?.copyWith(
                                  color: statusColor,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 2),
                        Text(
                          receipt.owner.name,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.md),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.sm,
                  vertical: AppSpacing.sm,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFF4FAFF),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: _WeightMetric(label: 'Số PO/BL', value: poOrBl),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: _WeightMetric(
                        label: 'Biển số xe',
                        value: plate == null || plate.isEmpty ? '--' : plate,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: _WeightMetric(
                        label: 'Khối lượng DK',
                        value:
                            '${_weightFormat.format(receipt.expectedWeightKg)} KG',
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: _WeightMetric(
                        label: 'Thực tế',
                        value: receipt.receivedWeightKg > 0
                            ? '${_weightFormat.format(receipt.receivedWeightKg)} KG'
                            : '--',
                        valueColor: receipt.receivedWeightKg > 0
                            ? AppColors.brand
                            : AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  key: Key('receipt_card_open_${receipt.id}'),
                  onPressed: onOpen,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.brand,
                    foregroundColor: AppColors.surface,
                    minimumSize: const Size.fromHeight(42),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  icon: const Icon(Icons.play_arrow_rounded),
                  label: Text(actionLabel.toUpperCase()),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _WeightMetric extends StatelessWidget {
  const _WeightMetric({
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
          style: Theme.of(
            context,
          ).textTheme.bodySmall?.copyWith(color: AppColors.textSecondary),
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

final NumberFormat _weightFormat = NumberFormat('#,##0.#');

String _statusLabel(ReceiptStatus status) {
  return switch (status) {
    ReceiptStatus.draft => 'Tạo mới',
    ReceiptStatus.confirmed => 'Đã xác nhận',
    ReceiptStatus.waitingForWeighing => 'Chờ cân',
    ReceiptStatus.weighing1 => 'Đang cân 1',
    ReceiptStatus.weighing2 => 'Đang cân 2',
    ReceiptStatus.completed => 'Hoàn thành',
    ReceiptStatus.error => 'Lỗi',
    ReceiptStatus.cancelled => 'Đã hủy',
  };
}

Color _statusColor(ReceiptStatus status) {
  return switch (status) {
    ReceiptStatus.draft => AppColors.textSecondary,
    ReceiptStatus.confirmed => AppColors.info,
    ReceiptStatus.waitingForWeighing => AppColors.warning,
    ReceiptStatus.weighing1 => AppColors.brandAccent,
    ReceiptStatus.weighing2 => AppColors.brand,
    ReceiptStatus.completed => AppColors.success,
    ReceiptStatus.error => AppColors.danger,
    ReceiptStatus.cancelled => AppColors.textSecondary,
  };
}

ActionCapability? _featuredAction(List<ActionCapability> actions) {
  for (final action in actions) {
    if (action.enabled) {
      return action;
    }
  }
  return null;
}
