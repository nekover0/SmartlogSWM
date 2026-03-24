import 'package:flutter/material.dart';
import 'package:smartlog_swm_mobile/shared/contracts/shared_contracts.dart';
import 'package:smartlog_swm_mobile/shared/theme/app_colors.dart';
import 'package:smartlog_swm_mobile/shared/theme/app_spacing.dart';

class ReceiptActionFooter extends StatelessWidget {
  const ReceiptActionFooter({
    super.key,
    required this.primaryActions,
    required this.secondaryActions,
    required this.onActionSelected,
  });

  final List<ActionCapability> primaryActions;
  final List<ActionCapability> secondaryActions;
  final ValueChanged<ActionCapability> onActionSelected;

  @override
  Widget build(BuildContext context) {
    final hasActions = primaryActions.isNotEmpty || secondaryActions.isNotEmpty;
    if (!hasActions) {
      return const SizedBox.shrink();
    }

    return DecoratedBox(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(top: BorderSide(color: AppColors.border)),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: AppSpacing.pagePadding,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              for (var index = 0; index < primaryActions.length; index++) ...[
                if (index == 0)
                  ElevatedButton.icon(
                    key: Key('receipt_action_${primaryActions[index].type.name}'),
                    onPressed: primaryActions[index].enabled
                        ? () => onActionSelected(primaryActions[index])
                        : null,
                    icon: Icon(_actionIcon(primaryActions[index].type)),
                    label: Text(primaryActions[index].label),
                  )
                else
                  OutlinedButton.icon(
                    key: Key('receipt_action_${primaryActions[index].type.name}'),
                    onPressed: primaryActions[index].enabled
                        ? () => onActionSelected(primaryActions[index])
                        : null,
                    icon: Icon(_actionIcon(primaryActions[index].type)),
                    label: Text(primaryActions[index].label),
                  ),
                if (index < primaryActions.length - 1)
                  const SizedBox(height: AppSpacing.sm),
              ],
              if (primaryActions.isNotEmpty && secondaryActions.isNotEmpty)
                const SizedBox(height: AppSpacing.sm),
              if (secondaryActions.isNotEmpty)
                Wrap(
                  spacing: AppSpacing.sm,
                  runSpacing: AppSpacing.sm,
                  children: [
                    for (final action in secondaryActions)
                      OutlinedButton.icon(
                        key: Key('receipt_action_${action.type.name}'),
                        onPressed: action.enabled
                            ? () => onActionSelected(action)
                            : null,
                        icon: Icon(_actionIcon(action.type)),
                        label: Text(action.label),
                      ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
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
