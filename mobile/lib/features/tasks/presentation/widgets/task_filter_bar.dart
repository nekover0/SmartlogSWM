import 'package:flutter/material.dart';
import 'package:smartlog_swm_mobile/features/tasks/application/controllers/task_queue_controller.dart';
import 'package:smartlog_swm_mobile/shared/contracts/shared_contracts.dart';
import 'package:smartlog_swm_mobile/shared/theme/app_colors.dart';
import 'package:smartlog_swm_mobile/shared/theme/app_spacing.dart';

class TaskFilterBar extends StatelessWidget {
  const TaskFilterBar({
    super.key,
    required this.state,
    required this.onSeveritySelected,
    required this.onTypeSelected,
  });

  final TaskQueueState state;
  final ValueChanged<Severity?> onSeveritySelected;
  final ValueChanged<TaskItemType?> onTypeSelected;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: AppSpacing.cardPadding,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Bộ lọc ưu tiên',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            'Lọc nhanh theo mức độ và loại việc để vào đúng task cần xử lý.',
            style: theme.textTheme.bodySmall?.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            'Mức độ',
            style: theme.textTheme.labelLarge?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Wrap(
            spacing: AppSpacing.xs,
            runSpacing: AppSpacing.xs,
            children: [
              _TaskChoiceChip(
                key: const Key('task_filter_severity_all'),
                label: 'Tất cả (${state.pendingTaskCount})',
                selected: state.selectedSeverity == null,
                onSelected: () => onSeveritySelected(null),
              ),
              for (final severity in Severity.values)
                _TaskChoiceChip(
                  key: Key('task_filter_severity_${severity.name}'),
                  label:
                      '${_severityLabel(severity)} (${state.countForSeverity(severity)})',
                  selected: state.selectedSeverity == severity,
                  accentColor: _severityColor(severity),
                  onSelected: () => onSeveritySelected(severity),
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            'Loại công việc',
            style: theme.textTheme.labelLarge?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Wrap(
            spacing: AppSpacing.xs,
            runSpacing: AppSpacing.xs,
            children: [
              _TaskChoiceChip(
                key: const Key('task_filter_type_all'),
                label: 'Mọi loại (${state.pendingTaskCount})',
                selected: state.selectedType == null,
                onSelected: () => onTypeSelected(null),
              ),
              for (final type in state.availableTypes)
                _TaskChoiceChip(
                  key: Key('task_filter_type_${type.name}'),
                  label: '${_typeLabel(type)} (${state.countForType(type)})',
                  selected: state.selectedType == type,
                  accentColor: _typeColor(type),
                  onSelected: () => onTypeSelected(type),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _TaskChoiceChip extends StatelessWidget {
  const _TaskChoiceChip({
    super.key,
    required this.label,
    required this.selected,
    required this.onSelected,
    this.accentColor,
  });

  final String label;
  final bool selected;
  final VoidCallback onSelected;
  final Color? accentColor;

  @override
  Widget build(BuildContext context) {
    final activeColor = accentColor ?? AppColors.brand;

    return ChoiceChip(
      label: Text(label),
      selected: selected,
      onSelected: (_) => onSelected(),
      backgroundColor: AppColors.surface,
      selectedColor: activeColor.withValues(alpha: 0.14),
      side: BorderSide(color: selected ? activeColor : AppColors.border),
      labelStyle: Theme.of(context).textTheme.labelMedium?.copyWith(
        color: selected ? activeColor : AppColors.textPrimary,
        fontWeight: FontWeight.w700,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      visualDensity: VisualDensity.compact,
    );
  }
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
