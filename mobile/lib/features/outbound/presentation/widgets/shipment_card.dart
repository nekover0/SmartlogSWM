import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:smartlog_swm_mobile/features/outbound/data/contracts/shipment_contract.dart';
import 'package:smartlog_swm_mobile/features/outbound/presentation/widgets/shipment_status_chip_bar.dart';
import 'package:smartlog_swm_mobile/shared/contracts/shared_contracts.dart';
import 'package:smartlog_swm_mobile/shared/theme/app_colors.dart';
import 'package:smartlog_swm_mobile/shared/theme/app_spacing.dart';

class ShipmentCard extends StatelessWidget {
  const ShipmentCard({
    super.key,
    required this.shipment,
    required this.isOverdue,
    required this.isBlocked,
    this.onOpen,
    this.onQuickActions,
  });

  final ShipmentEntity shipment;
  final bool isOverdue;
  final bool isBlocked;
  final VoidCallback? onOpen;
  final VoidCallback? onQuickActions;

  @override
  Widget build(BuildContext context) {
    final statusColor = shipmentStatusColor(shipment.status);
    final theme = Theme.of(context);
    final plate = shipment.vehicle.plateNumber?.trim();
    final soOrBl = shipment.salesOrderNo?.trim().isNotEmpty == true
        ? shipment.salesOrderNo!.trim()
        : (shipment.billOfLadingNo?.trim().isNotEmpty == true
              ? shipment.billOfLadingNo!.trim()
              : '--');

    final borderColor = isBlocked
        ? AppColors.danger
        : (isOverdue ? AppColors.warning : statusColor.withValues(alpha: 0.35));

    return Card(
      key: Key('shipment_card_${shipment.id}'),
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(color: borderColor),
      ),
      child: InkWell(
        onTap: onOpen,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
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
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                shipment.shipmentNo,
                                style: theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w800,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
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
                                shipmentStatusLabel(shipment.status),
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
                          shipment.owner.name,
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
                  const SizedBox(width: AppSpacing.sm),
                  IconButton(
                    key: Key('shipment_card_actions_${shipment.id}'),
                    onPressed: onQuickActions,
                    icon: const Icon(Icons.more_horiz_rounded),
                    tooltip: 'Hành động nhanh',
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
                      child: _MetricTile(label: 'SO/BL', value: soOrBl),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: _MetricTile(
                        label: 'Biển số xe',
                        value: plate == null || plate.isEmpty ? '--' : plate,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: _MetricTile(
                        label: 'KL dự kiến',
                        value:
                            '${_weightFormat.format(shipment.expectedWeightKg)} KG',
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: _MetricTile(
                        label: 'Đã xuất',
                        value:
                            '${_weightFormat.format(shipment.shippedWeightKg)} KG',
                        valueColor: AppColors.brand,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              Wrap(
                spacing: AppSpacing.xs,
                runSpacing: AppSpacing.xs,
                children: [
                  _FlagPill(
                    label: shipment.warehouse.code,
                    color: AppColors.info,
                  ),
                  if (shipment.syncState == SyncState.pending)
                    const _FlagPill(
                      label: 'Đồng bộ chờ',
                      color: AppColors.warning,
                    ),
                  if (isOverdue)
                    const _FlagPill(
                      label: 'Trễ xử lý',
                      color: AppColors.warning,
                    ),
                  if (isBlocked)
                    const _FlagPill(label: 'Blocked', color: AppColors.danger),
                ],
              ),
              const SizedBox(height: AppSpacing.md),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  key: Key('shipment_card_open_${shipment.id}'),
                  onPressed: onOpen,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.brand,
                    foregroundColor: AppColors.surface,
                    minimumSize: const Size.fromHeight(42),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  icon: const Icon(Icons.call_made_rounded),
                  label: const Text('XEM PHIẾU'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MetricTile extends StatelessWidget {
  const _MetricTile({
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
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}

class _FlagPill extends StatelessWidget {
  const _FlagPill({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.xs,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
          color: color,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

Color shipmentStatusColor(ShipmentStatus status) {
  return switch (status) {
    ShipmentStatus.draft => AppColors.textSecondary,
    ShipmentStatus.confirmed => AppColors.info,
    ShipmentStatus.picking => AppColors.warning,
    ShipmentStatus.loading => AppColors.brandAccent,
    ShipmentStatus.weighCompleted => AppColors.brand,
    ShipmentStatus.shipped => AppColors.success,
    ShipmentStatus.closed => AppColors.textSecondary,
    ShipmentStatus.error => AppColors.danger,
    ShipmentStatus.cancelled => AppColors.textSecondary,
  };
}

final NumberFormat _weightFormat = NumberFormat('#,##0.#');
