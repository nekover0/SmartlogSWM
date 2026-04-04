import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:smartlog_swm_mobile/app/router/app_route_paths.dart';
import 'package:smartlog_swm_mobile/app/shell/application/controllers/app_shell_controller.dart';
import 'package:smartlog_swm_mobile/features/inventory/application/providers/inventory_providers.dart';
import 'package:smartlog_swm_mobile/features/inventory/domain/models/inventory_models.dart';
import 'package:smartlog_swm_mobile/features/tasks/application/controllers/task_queue_controller.dart';
import 'package:smartlog_swm_mobile/shared/contracts/shared_contracts.dart';
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
              Expanded(child: _NotificationsContent(onOpenRoute: onOpenRoute)),
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
    final taskQueueState = ref.watch(taskQueueControllerProvider).valueOrNull;
    final inventoryItems =
        ref.watch(inventoryListProvider).valueOrNull ??
        const <InventoryItemEntity>[];

    final lowStockCount = inventoryItems
        .where((item) => item.isLowStock)
        .length;

    final pendingTaskCount = taskQueueState?.pendingTaskCount ?? 0;
    final ocrTaskCount =
        taskQueueState?.pendingItems
            .where((item) => item.type == TaskItemType.ocr)
            .length ??
        0;
    final shipmentTaskCount =
        taskQueueState?.pendingItems
            .where((item) => item.type == TaskItemType.shipment)
            .length ??
        0;

    final entries = _buildNotificationEntries(
      lowStockCount: lowStockCount,
      pendingTaskCount: pendingTaskCount,
      ocrTaskCount: ocrTaskCount,
      shipmentTaskCount: shipmentTaskCount,
    );

    final content = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _HeaderCard(
          siteName: shellState.currentSite.label,
          roleName: shellState.currentRole.label,
          notificationCount: entries.length,
        ),
        const SizedBox(height: AppSpacing.md),
        ...entries.map(
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

    return ListView(padding: AppSpacing.pagePadding, children: [content]);
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
  const _NotificationCard({required this.entry, required this.onTap});

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

List<_NotificationEntry> _buildNotificationEntries({
  required int lowStockCount,
  required int pendingTaskCount,
  required int ocrTaskCount,
  required int shipmentTaskCount,
}) {
  final entries = <_NotificationEntry>[];

  if (lowStockCount > 0) {
    entries.add(
      _NotificationEntry(
        title: 'Cảnh báo tồn thấp',
        message:
            '$lowStockCount SKU đang xuống dưới ngưỡng an toàn, cần xử lý sớm.',
        icon: Icons.inventory_2_outlined,
        accent: AppColors.warning,
        route: AppRoutePaths.inventory,
      ),
    );
  }

  if (pendingTaskCount > 0) {
    entries.add(
      _NotificationEntry(
        title: 'Công việc đang chờ',
        message: '$pendingTaskCount công việc đang nằm trong hàng đợi.',
        icon: Icons.pending_actions_rounded,
        accent: AppColors.info,
        route: AppRoutePaths.tasks,
      ),
    );
  }

  if (ocrTaskCount > 0) {
    entries.add(
      _NotificationEntry(
        title: 'OCR cần xem xét',
        message: '$ocrTaskCount chứng từ OCR cần xác nhận.',
        icon: Icons.document_scanner_outlined,
        accent: AppColors.brandAccent,
        route: AppRoutePaths.ocrInbox,
      ),
    );
  }

  if (shipmentTaskCount > 0) {
    entries.add(
      _NotificationEntry(
        title: 'Phiếu xuất chờ xử lý',
        message: '$shipmentTaskCount phiếu xuất đang chờ xác nhận.',
        icon: Icons.local_shipping_outlined,
        accent: AppColors.success,
        route: AppRoutePaths.shipmentList,
      ),
    );
  }

  if (entries.isEmpty) {
    entries.add(
      const _NotificationEntry(
        title: 'Không có cảnh báo mới',
        message: 'Mọi luồng đang ổn định trong ca hiện tại.',
        icon: Icons.notifications_none_rounded,
        accent: AppColors.info,
        route: AppRoutePaths.tasks,
      ),
    );
  }

  return entries;
}
