import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:smartlog_swm_mobile/features/inbound/data/contracts/receipt_contract.dart';
import 'package:smartlog_swm_mobile/shared/contracts/shared_contracts.dart';
import 'package:smartlog_swm_mobile/shared/theme/app_colors.dart';
import 'package:smartlog_swm_mobile/shared/theme/app_spacing.dart';

class ReceiptCard extends StatelessWidget {
  const ReceiptCard({
    super.key,
    required this.receipt,
    this.onOpen,
  });

  final ReceiptEntity receipt;
  final VoidCallback? onOpen;

  @override
  Widget build(BuildContext context) {
    final statusColor = _statusColor(receipt.status);
    final theme = Theme.of(context);
    final syncLabel = _syncLabel(receipt.syncState);
    final syncColor = _syncColor(receipt.syncState);
    final featuredAction = _featuredAction(receipt.availableActions);

    return Card(
      key: Key('receipt_card_${receipt.id}'),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onOpen,
        child: Padding(
          padding: AppSpacing.cardPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          receipt.receiptNo,
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        Text(
                          receipt.owner.name,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  _Pill(
                    label: _statusLabel(receipt.status),
                    color: statusColor,
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.md),
              Wrap(
                spacing: AppSpacing.xs,
                runSpacing: AppSpacing.xs,
                children: [
                  _MetaPill(
                    icon: Icons.inventory_2_outlined,
                    label: receipt.warehouse.code,
                  ),
                  if (_hasValue(receipt.purchaseOrderNo))
                    _MetaPill(
                      icon: Icons.receipt_long_outlined,
                      label: receipt.purchaseOrderNo!.trim(),
                    ),
                  if (_hasValue(receipt.billOfLadingNo))
                    _MetaPill(
                      icon: Icons.local_shipping_outlined,
                      label: receipt.billOfLadingNo!.trim(),
                    ),
                  if (_hasValue(receipt.vehicle.plateNumber))
                    _MetaPill(
                      icon: Icons.local_taxi_outlined,
                      label: receipt.vehicle.plateNumber!.trim(),
                    ),
                  _Pill(label: syncLabel, color: syncColor),
                ],
              ),
              const SizedBox(height: AppSpacing.md),
              Container(
                padding: AppSpacing.compactPadding,
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: AppSpacing.controlRadius,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: _WeightMetric(
                        label: 'Dự kiến',
                        value: '${_weightFormat.format(receipt.expectedWeightKg)} kg',
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: _WeightMetric(
                        label: 'Thực nhận',
                        value: '${_weightFormat.format(receipt.receivedWeightKg)} kg',
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: _WeightMetric(
                        label: 'Chênh lệch',
                        value:
                            '${receipt.varianceWeightKg > 0 ? '+' : ''}${_weightFormat.format(receipt.varianceWeightKg)} kg',
                        valueColor: _varianceColor(receipt.varianceWeightKg),
                      ),
                    ),
                  ],
                ),
              ),
              if (featuredAction != null || _hasValue(receipt.note)) ...[
                const SizedBox(height: AppSpacing.md),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (featuredAction != null)
                      Expanded(
                        child: Container(
                          padding: AppSpacing.compactPadding,
                          decoration: BoxDecoration(
                            color: AppColors.brand.withValues(alpha: 0.08),
                            borderRadius: AppSpacing.controlRadius,
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.flash_on_rounded,
                                color: AppColors.brand,
                                size: 18,
                              ),
                              const SizedBox(width: AppSpacing.xs),
                              Expanded(
                                child: Text(
                                  featuredAction.label,
                                  style: theme.textTheme.labelLarge?.copyWith(
                                    color: AppColors.brand,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    if (featuredAction != null && _hasValue(receipt.note))
                      const SizedBox(width: AppSpacing.sm),
                    if (_hasValue(receipt.note))
                      Expanded(
                        child: Text(
                          receipt.note!.trim(),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ),
                  ],
                ),
              ],
              const SizedBox(height: AppSpacing.md),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  key: Key('receipt_card_open_${receipt.id}'),
                  onPressed: onOpen,
                  icon: const Icon(Icons.open_in_new_rounded),
                  label: const Text('Xem phiếu'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MetaPill extends StatelessWidget {
  const _MetaPill({
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
        color: AppColors.background,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: AppColors.textSecondary),
          const SizedBox(width: AppSpacing.xs),
          Text(
            label,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _Pill extends StatelessWidget {
  const _Pill({
    required this.label,
    required this.color,
  });

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelMedium?.copyWith(
          color: color,
          fontWeight: FontWeight.w800,
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

final NumberFormat _weightFormat = NumberFormat('#,##0.#');

bool _hasValue(String? value) => value != null && value.trim().isNotEmpty;

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

String _syncLabel(SyncState syncState) {
  return switch (syncState) {
    SyncState.synced => 'Đã sync',
    SyncState.pending => 'Chờ sync',
    SyncState.failed => 'Sync lỗi',
  };
}

Color _syncColor(SyncState syncState) {
  return switch (syncState) {
    SyncState.synced => AppColors.success,
    SyncState.pending => AppColors.warning,
    SyncState.failed => AppColors.danger,
  };
}

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

ActionCapability? _featuredAction(List<ActionCapability> actions) {
  for (final action in actions) {
    if (action.enabled) {
      return action;
    }
  }
  return null;
}
