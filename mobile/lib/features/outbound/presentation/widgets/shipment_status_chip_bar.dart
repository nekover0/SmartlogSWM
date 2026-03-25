import 'package:flutter/material.dart';
import 'package:smartlog_swm_mobile/features/outbound/application/controllers/shipment_list_controller.dart';
import 'package:smartlog_swm_mobile/shared/contracts/shared_contracts.dart';
import 'package:smartlog_swm_mobile/shared/theme/app_colors.dart';
import 'package:smartlog_swm_mobile/shared/theme/app_spacing.dart';

class ShipmentStatusChipBar extends StatelessWidget {
  const ShipmentStatusChipBar({
    super.key,
    required this.state,
    required this.onSelected,
  });

  final ShipmentListState state;
  final ValueChanged<ShipmentStatus?> onSelected;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _ShipmentStatusChip(
            key: const Key('shipment_status_chip_all'),
            label: 'Tất cả',
            count: state.totalCount,
            selected: state.selectedStatus == null,
            onPressed: () => onSelected(null),
          ),
          const SizedBox(width: AppSpacing.xs),
          for (
            var index = 0;
            index < state.availableStatuses.length;
            index++
          ) ...[
            _ShipmentStatusChip(
              key: Key(
                'shipment_status_chip_${state.availableStatuses[index].name}',
              ),
              label: shipmentStatusLabel(state.availableStatuses[index]),
              count: state.countForStatus(state.availableStatuses[index]),
              selected: state.selectedStatus == state.availableStatuses[index],
              onPressed: () => onSelected(state.availableStatuses[index]),
            ),
            if (index < state.availableStatuses.length - 1)
              const SizedBox(width: AppSpacing.xs),
          ],
        ],
      ),
    );
  }
}

class _ShipmentStatusChip extends StatelessWidget {
  const _ShipmentStatusChip({
    super.key,
    required this.label,
    required this.count,
    required this.selected,
    required this.onPressed,
  });

  final String label;
  final int count;
  final bool selected;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.sm,
            vertical: AppSpacing.xs,
          ),
          decoration: BoxDecoration(
            color: selected ? AppColors.brand : const Color(0xFFDFF1FB),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                label,
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: selected ? AppColors.surface : AppColors.textPrimary,
                  fontWeight: FontWeight.w700,
                ),
              ),
              if (count > 0) ...[
                const SizedBox(width: AppSpacing.xs),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 1,
                  ),
                  decoration: BoxDecoration(
                    color: selected
                        ? AppColors.surface.withValues(alpha: 0.2)
                        : AppColors.brand,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    '$count',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: AppColors.surface,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

String shipmentStatusLabel(ShipmentStatus status) {
  return switch (status) {
    ShipmentStatus.draft => 'Tạo mới',
    ShipmentStatus.confirmed => 'Đã xác nhận',
    ShipmentStatus.picking => 'Đang lấy hàng',
    ShipmentStatus.loading => 'Đang xếp hàng',
    ShipmentStatus.weighCompleted => 'Hoàn thành cân',
    ShipmentStatus.shipped => 'Đã xuất',
    ShipmentStatus.closed => 'Đóng',
    ShipmentStatus.error => 'Lỗi',
    ShipmentStatus.cancelled => 'Đã hủy',
  };
}
