import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:smartlog_swm_mobile/app/router/app_route_paths.dart';
import 'package:smartlog_swm_mobile/app/shell/application/controllers/app_shell_controller.dart';
import 'package:smartlog_swm_mobile/shared/theme/app_colors.dart';
import 'package:smartlog_swm_mobile/shared/theme/app_spacing.dart';

Future<void> showNotificationsSheet(BuildContext context) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    backgroundColor: Colors.transparent,
    builder: (BuildContext sheetContext) {
      return FractionallySizedBox(
        heightFactor: 0.88,
        child: _NotificationsSheet(
          onOpenRoute: (String route) {
            Navigator.of(sheetContext).pop();
            context.go(route);
          },
        ),
      );
    },
  );
}

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Thông báo')),
      body: _NotificationsContent(
        onOpenRoute: (String route) => context.go(route),
      ),
    );
  }
}

class _NotificationsSheet extends StatelessWidget {
  const _NotificationsSheet({required this.onOpenRoute});

  final ValueChanged<String> onOpenRoute;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.md,
            AppSpacing.sm,
            AppSpacing.md,
            AppSpacing.md,
          ),
          child: Column(
            children: [
              Container(
                width: 44,
                height: 5,
                decoration: BoxDecoration(
                  color: AppColors.border,
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              Expanded(
                child: _NotificationsContent(onOpenRoute: onOpenRoute),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NotificationsContent extends ConsumerWidget {
  const _NotificationsContent({required this.onOpenRoute});

  final ValueChanged<String> onOpenRoute;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final shellState = ref.watch(appShellControllerProvider);

    final content = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _HeaderCard(
          siteName: shellState.currentSite.label,
          roleName: shellState.currentRole.label,
          notificationCount: shellState.badgeCounts.notifications,
        ),
        const SizedBox(height: AppSpacing.md),
        ..._notificationEntries.map(
          (entry) => Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.sm),
            child: _NotificationCard(
              entry: entry,
              onTap: () => onOpenRoute(entry.route),
            ),
          ),
        ),
      ],
    );

    return ListView(
      padding: AppSpacing.pagePadding,
      children: [content],
    );
  }
}

class _HeaderCard extends StatelessWidget {
  const _HeaderCard({
    required this.siteName,
    required this.roleName,
    required this.notificationCount,
  });

  final String siteName;
  final String roleName;
  final int notificationCount;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.brand, AppColors.brandAccent],
        ),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        children: [
          Container(
            width: 54,
            height: 54,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.14),
              borderRadius: BorderRadius.circular(18),
            ),
            child: const Icon(
              Icons.notifications_active_outlined,
              color: AppColors.surface,
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Trung tâm thông báo',
                  style: theme.textTheme.titleLarge?.copyWith(
                    color: AppColors.surface,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '$siteName · $roleName',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: Colors.white.withValues(alpha: 0.9),
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  '$notificationCount cảnh báo đang chờ xử lý',
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: Colors.white.withValues(alpha: 0.85),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _NotificationCard extends StatelessWidget {
  const _NotificationCard({
    required this.entry,
    required this.onTap,
  });

  final _NotificationEntry entry;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Row(
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: entry.accent.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(entry.icon, color: entry.accent),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      entry.title,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      entry.message,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              const Icon(Icons.chevron_right_rounded),
            ],
          ),
        ),
      ),
    );
  }
}

class _NotificationEntry {
  const _NotificationEntry({
    required this.title,
    required this.message,
    required this.icon,
    required this.accent,
    required this.route,
  });

  final String title;
  final String message;
  final IconData icon;
  final Color accent;
  final String route;
}

const List<_NotificationEntry> _notificationEntries = <_NotificationEntry>[
  _NotificationEntry(
    title: 'Cảnh báo tồn thấp',
    message: '12 SKU đang xuống dưới ngưỡng an toàn tại kho SGN-DC-01.',
    icon: Icons.inventory_2_outlined,
    accent: AppColors.warning,
    route: AppRoutePaths.inventory,
  ),
  _NotificationEntry(
    title: 'Phiếu chờ cân',
    message: '2 phiếu nhập cần được xử lý trong hàng đợi công việc.',
    icon: Icons.scale_outlined,
    accent: AppColors.info,
    route: '/tasks?type=weighing',
  ),
  _NotificationEntry(
    title: 'OCR cần xem xét',
    message: '3 chứng từ mới vừa được chuyển sang hàng đợi OCR.',
    icon: Icons.document_scanner_outlined,
    accent: AppColors.brandAccent,
    route: AppRoutePaths.ocrInbox,
  ),
  _NotificationEntry(
    title: 'Phiếu xuất chờ xử lý',
    message: '1 phiếu xuất vẫn đang chờ xác nhận trước khi đóng gói.',
    icon: Icons.local_shipping_outlined,
    accent: AppColors.success,
    route: AppRoutePaths.shipmentList,
  ),
];
