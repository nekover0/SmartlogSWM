import 'package:flutter/material.dart';
import 'package:smartlog_swm_mobile/features/inbound/application/controllers/receipt_list_controller.dart';
import 'package:smartlog_swm_mobile/shared/contracts/shared_contracts.dart';
import 'package:smartlog_swm_mobile/shared/theme/app_colors.dart';
import 'package:smartlog_swm_mobile/shared/theme/app_spacing.dart';

class ReceiptStatusChipBar extends StatelessWidget {
  const ReceiptStatusChipBar({
    super.key,
    required this.state,
    required this.onSelected,
  });

  final ReceiptListState state;
  final ValueChanged<ReceiptStatus?> onSelected;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _ReceiptStatusChip(
            key: const Key('receipt_status_chip_all'),
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
            _ReceiptStatusChip(
              key: Key(
                'receipt_status_chip_${state.availableStatuses[index].name}',
              ),
              label: _statusLabel(state.availableStatuses[index]),
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

class _ReceiptStatusChip extends StatelessWidget {
  const _ReceiptStatusChip({
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
