import 'package:flutter/material.dart';
import 'package:smartlog_swm_mobile/features/tasks/data/contracts/task_item_contract.dart';
import 'package:smartlog_swm_mobile/shared/contracts/shared_contracts.dart';
import 'package:smartlog_swm_mobile/shared/theme/app_colors.dart';
import 'package:smartlog_swm_mobile/shared/theme/app_spacing.dart';

class TaskCard extends StatelessWidget {
  const TaskCard({
    super.key,
    required this.item,
    this.onPrimaryAction,
    this.onMorePressed,
  });

  final TaskItemEntity item;
  final VoidCallback? onPrimaryAction;
  final VoidCallback? onMorePressed;

  @override
  Widget build(BuildContext context) {
    final severityColor = _severityColor(item.severity);
    final theme = Theme.of(context);

    return Card(
      key: Key('task_card_${item.id}'),
      margin: EdgeInsets.zero,
      clipBehavior: Clip.antiAlias,
      child: DecoratedBox(
        decoration: BoxDecoration(
          border: Border(left: BorderSide(color: severityColor, width: 4)),
        ),
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
                          item.title,
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        if (item.description != null &&
                            item.description!.trim().isNotEmpty) ...[
                          const SizedBox(height: AppSpacing.xs),
                          Text(
                            item.description!,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  if (onMorePressed != null)
                    IconButton(
                      key: Key('task_card_more_${item.id}'),
                      onPressed: onMorePressed,
                      tooltip: 'Mở quick actions',
                      icon: const Icon(Icons.more_horiz_rounded),
                    ),
                ],
              ),
              const SizedBox(height: AppSpacing.md),
              Wrap(
                spacing: AppSpacing.xs,
                runSpacing: AppSpacing.xs,
                children: [
                  _MetaPill(
                    icon: _typeIcon(item.type),
                    label: _typeLabel(item.type),
                    color: _typeColor(item.type),
                  ),
                  _MetaPill(
                    icon: Icons.priority_high_rounded,
                    label: _severityLabel(item.severity),
                    color: severityColor,
                  ),
                  if (item.sourceEntityNo?.trim().isNotEmpty ?? false)
                    _MetaPill(
                      icon: Icons.tag_rounded,
                      label: item.sourceEntityNo!.trim(),
                      color: AppColors.textSecondary,
                    ),
                ],
              ),
              const SizedBox(height: AppSpacing.md),
              Row(
                children: [
                  const Icon(
                    Icons.schedule_rounded,
                    size: 16,
                    color: AppColors.textSecondary,
                  ),
                  const SizedBox(width: AppSpacing.xs),
                  Expanded(
                    child: Text(
                      _ageLabel(item),
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Flexible(
                    child: Text(
                      _sourceLabel(item.sourceModule),
                      textAlign: TextAlign.right,
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.md),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  key: Key('task_card_primary_action_${item.id}'),
                  onPressed: onPrimaryAction,
                  icon: Icon(_actionIcon(item.primaryAction.type)),
                  label: Text(item.primaryAction.label),
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
    required this.color,
  });

  final IconData icon;
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
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: AppSpacing.xs),
          Text(
            label,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: color,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

String _typeLabel(TaskItemType type) {
  return switch (type) {
    TaskItemType.receipt => 'Phiếu nhập',
    TaskItemType.shipment => 'Phiếu xuất',
    TaskItemType.ocr => 'OCR',
    TaskItemType.inventory => 'Tồn kho',
    TaskItemType.aiSuggestion => 'AI đề xuất',
    TaskItemType.systemAlert => 'Cảnh báo',
  };
}

IconData _typeIcon(TaskItemType type) {
  return switch (type) {
    TaskItemType.receipt => Icons.call_received_rounded,
    TaskItemType.shipment => Icons.call_made_rounded,
    TaskItemType.ocr => Icons.document_scanner_outlined,
    TaskItemType.inventory => Icons.inventory_2_outlined,
    TaskItemType.aiSuggestion => Icons.auto_awesome_rounded,
    TaskItemType.systemAlert => Icons.warning_amber_rounded,
  };
}

Color _typeColor(TaskItemType type) {
  return switch (type) {
    TaskItemType.receipt => AppColors.info,
    TaskItemType.shipment => AppColors.success,
    TaskItemType.ocr => AppColors.brandAccent,
    TaskItemType.inventory => AppColors.warning,
    TaskItemType.aiSuggestion => AppColors.brand,
    TaskItemType.systemAlert => AppColors.danger,
  };
}

String _severityLabel(Severity severity) {
  return switch (severity) {
    Severity.critical => 'Nghiêm trọng',
    Severity.high => 'Cao',
    Severity.medium => 'Trung bình',
    Severity.low => 'Thấp',
  };
}

Color _severityColor(Severity severity) {
  return switch (severity) {
    Severity.critical => AppColors.danger,
    Severity.high => AppColors.warning,
    Severity.medium => AppColors.info,
    Severity.low => AppColors.success,
  };
}

String _ageLabel(TaskItemEntity item) {
  final ageMinutes = item.ageMinutes;
  final dueAt = item.dueAt;

  if (dueAt != null && ageMinutes != null) {
    return 'Hạn ${_formatTime(dueAt)} · ${_formatAge(ageMinutes)}';
  }
  if (ageMinutes != null) {
    return _formatAge(ageMinutes);
  }
  if (dueAt != null) {
    return 'Hạn ${_formatTime(dueAt)}';
  }

  return 'Mới tạo';
}

String _formatAge(int ageMinutes) {
  if (ageMinutes >= 60) {
    final hours = ageMinutes ~/ 60;
    final minutes = ageMinutes % 60;
    if (minutes == 0) {
      return '$hours giờ trước';
    }
    return '$hours giờ $minutes phút trước';
  }

  return '$ageMinutes phút trước';
}

String _formatTime(DateTime value) {
  final local = value.toLocal();
  final hour = local.hour.toString().padLeft(2, '0');
  final minute = local.minute.toString().padLeft(2, '0');
  return '$hour:$minute';
}

String _sourceLabel(String module) {
  switch (module) {
    case 'inbound':
      return 'Nguồn: Inbound';
    case 'outbound':
      return 'Nguồn: Outbound';
    case 'ocr':
      return 'Nguồn: OCR';
    case 'inventory':
      return 'Nguồn: Tồn kho';
    case 'ai':
      return 'Nguồn: AI';
    default:
      return 'Nguồn: Hệ thống';
  }
}

IconData _actionIcon(TaskActionType actionType) {
  return switch (actionType) {
    TaskActionType.open => Icons.open_in_new_rounded,
    TaskActionType.approve => Icons.check_circle_outline_rounded,
    TaskActionType.dismiss => Icons.do_not_disturb_alt_rounded,
    TaskActionType.acknowledge => Icons.mark_email_read_outlined,
    TaskActionType.startWeighing => Icons.scale_rounded,
    TaskActionType.startPicking => Icons.play_arrow_rounded,
    TaskActionType.reviewOcr => Icons.fact_check_outlined,
    TaskActionType.viewInventory => Icons.inventory_2_outlined,
    TaskActionType.custom => Icons.bolt_rounded,
  };
}
