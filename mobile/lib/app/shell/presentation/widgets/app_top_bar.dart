import 'package:flutter/material.dart';
import 'package:smartlog_swm_mobile/app/shell/domain/models/current_role.dart';
import 'package:smartlog_swm_mobile/app/shell/domain/models/current_site.dart';
import 'package:smartlog_swm_mobile/shared/theme/app_colors.dart';
import 'package:smartlog_swm_mobile/shared/theme/app_spacing.dart';

class AppTopBar extends StatelessWidget implements PreferredSizeWidget {
  const AppTopBar({
    super.key,
    required this.site,
    required this.title,
    required this.role,
    required this.displayName,
    required this.notificationCount,
    required this.onNotificationsPressed,
    required this.onAvatarPressed,
  });

  final CurrentSite site;
  final String title;
  final CurrentRole role;
  final String displayName;
  final int notificationCount;
  final VoidCallback onNotificationsPressed;
  final VoidCallback onAvatarPressed;

  @override
  Size get preferredSize => const Size.fromHeight(76);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Material(
      color: AppColors.surface,
      child: Container(
        decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: AppColors.border)),
        ),
        child: SafeArea(
          bottom: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.md,
              AppSpacing.xs,
              AppSpacing.md,
              AppSpacing.sm,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _SiteLabel(site: site),
                      const SizedBox(height: 4),
                      Text(
                        title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w800,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Badge(
                      isLabelVisible: notificationCount > 0,
                      label: Text(_formatBadgeCount(notificationCount)),
                      backgroundColor: AppColors.danger,
                      textColor: AppColors.surface,
                      child: IconButton(
                        tooltip: 'Thông báo',
                        onPressed: onNotificationsPressed,
                        icon: const Icon(Icons.notifications_none_rounded),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.xs),
                    Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(18),
                        onTap: onAvatarPressed,
                        child: CircleAvatar(
                          radius: 19,
                          backgroundColor: AppColors.brand,
                          child: Text(
                            _initialsFromName(displayName),
                            style: theme.textTheme.labelMedium?.copyWith(
                              color: AppColors.surface,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
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

  String _initialsFromName(String name) {
    final parts = name
        .trim()
        .split(RegExp(r'\s+'))
        .where((part) => part.isNotEmpty)
        .toList(growable: false);

    if (parts.isEmpty) {
      return 'SL';
    }

    final firstInitial = parts.first[0];
    if (parts.length == 1) {
      return firstInitial.toUpperCase();
    }

    final lastInitial = parts.last[0];
    return (firstInitial + lastInitial).toUpperCase();
  }
}

class _SiteLabel extends StatelessWidget {
  const _SiteLabel({required this.site});

  final CurrentSite site;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xxs,
      ),
      decoration: BoxDecoration(
        color: AppColors.brand.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        site.label,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
          color: AppColors.brand,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
