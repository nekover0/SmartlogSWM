import 'package:flutter/material.dart';
import 'package:smartlog_swm_mobile/shared/theme/app_colors.dart';
import 'package:smartlog_swm_mobile/shared/theme/app_spacing.dart';

class AppBottomNavItem {
  const AppBottomNavItem({
    required this.title,
    required this.label,
    required this.icon,
    required this.activeIcon,
    required this.branchIndex,
    this.badgeCount = 0,
  });

  final String title;
  final String label;
  final IconData icon;
  final IconData activeIcon;
  final int branchIndex;
  final int badgeCount;
}

class AppBottomNav extends StatelessWidget {
  const AppBottomNav({
    super.key,
    required this.items,
    required this.selectedBranchIndex,
    required this.showFabGap,
    required this.onTap,
  });

  final List<AppBottomNavItem> items;
  final int selectedBranchIndex;
  final bool showFabGap;
  final ValueChanged<AppBottomNavItem> onTap;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(top: BorderSide(color: AppColors.border)),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.sm,
            AppSpacing.sm,
            AppSpacing.sm,
            AppSpacing.md,
          ),
          child: Row(children: _buildChildren()),
        ),
      ),
    );
  }

  List<Widget> _buildChildren() {
    final children = <Widget>[];

    for (var index = 0; index < items.length; index++) {
      if (showFabGap && index == 2) {
        children.add(const SizedBox(width: 72));
      }

      final item = items[index];
      children.add(
        Expanded(
          child: _AppBottomNavButton(
            item: item,
            selected: item.branchIndex == selectedBranchIndex,
            onTap: () => onTap(item),
          ),
        ),
      );
    }

    if (showFabGap && items.length < 3) {
      children.add(const SizedBox(width: 72));
    }

    return children;
  }
}

class _AppBottomNavButton extends StatelessWidget {
  const _AppBottomNavButton({
    required this.item,
    required this.selected,
    required this.onTap,
  });

  final AppBottomNavItem item;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = selected ? AppColors.brand : AppColors.textSecondary;

    return Semantics(
      button: true,
      selected: selected,
      label: item.label,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          key: Key('bottom_nav_button_${item.branchIndex}'),
          borderRadius: BorderRadius.circular(18),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Badge(
                  key: Key('bottom_nav_badge_${item.branchIndex}'),
                  isLabelVisible: item.badgeCount > 0,
                  label: Text(_formatBadgeCount(item.badgeCount)),
                  backgroundColor: AppColors.danger,
                  textColor: AppColors.surface,
                  child: Icon(
                    selected ? item.activeIcon : item.icon,
                    color: color,
                    size: 24,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  item.label,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: color,
                    fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _formatBadgeCount(int count) {
    if (count > 99) {
      return '99+';
    }

    return '$count';
  }
}
