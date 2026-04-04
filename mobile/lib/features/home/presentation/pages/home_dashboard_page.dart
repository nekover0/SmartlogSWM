import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:smartlog_swm_mobile/app/router/app_route_paths.dart';
import 'package:smartlog_swm_mobile/app/shell/application/controllers/app_shell_controller.dart';
import 'package:smartlog_swm_mobile/app/shell/presentation/widgets/scan_action_sheet.dart';
import 'package:smartlog_swm_mobile/features/home/application/providers/home_dashboard_provider.dart';
import 'package:smartlog_swm_mobile/shared/theme/app_colors.dart';
import 'package:smartlog_swm_mobile/shared/theme/app_spacing.dart';

class HomeDashboardPage extends ConsumerWidget {
  const HomeDashboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final shellState = ref.watch(appShellControllerProvider);
    final dashboardState = ref.watch(homeDashboardSnapshotProvider);
    final snapshot =
        dashboardState.valueOrNull ?? HomeDashboardSnapshot.fallback();
    final displayName = shellState.displayName.trim();
    final firstName = displayName.isEmpty
        ? 'Marcus'
        : displayName.split(RegExp(r'\s+')).last;
    final cardWidth = (MediaQuery.of(context).size.width - 44) / 2;

    return ListView(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.md,
        AppSpacing.md,
        AppSpacing.md,
        112,
      ),
      children: [
        _GreetingSection(
          firstName: firstName,
          siteLabel: shellState.currentSite.label,
        ),
        const SizedBox(height: AppSpacing.lg),
        _KpiSection(cardWidth: cardWidth, snapshot: snapshot),
        const SizedBox(height: AppSpacing.lg),
        _SectionHeading(title: 'Hành động nhanh'),
        const SizedBox(height: AppSpacing.sm),
        Wrap(
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.sm,
          children: [
            _QuickActionButton(
              icon: Icons.qr_code_scanner_rounded,
              title: 'Quét mã',
              width: cardWidth,
              onTap: () => showScanActionSheet(context),
            ),
            _QuickActionButton(
              icon: Icons.move_to_inbox_rounded,
              title: 'Nhập kho',
              width: cardWidth,
              onTap: () => context.go(AppRoutePaths.receiptList),
            ),
            _QuickActionButton(
              icon: Icons.local_shipping_outlined,
              title: 'Xuất kho',
              width: cardWidth,
              onTap: () => context.go(AppRoutePaths.shipmentList),
            ),
            _QuickActionButton(
              icon: Icons.fact_check_outlined,
              title: 'Kiểm kê',
              width: cardWidth,
              onTap: () => context.go(AppRoutePaths.inventoryControl),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.lg),
        _SectionHeading(title: 'Cảnh báo hệ thống'),
        const SizedBox(height: AppSpacing.sm),
        _AlertsSection(alerts: snapshot.alerts),
        const SizedBox(height: AppSpacing.lg),
        _RecentActivitySection(
          activities: snapshot.recentActivities,
          onViewAll: () => context.go(AppRoutePaths.tasks),
        ),
      ],
    );
  }
}

class _GreetingSection extends StatelessWidget {
  const _GreetingSection({required this.firstName, required this.siteLabel});

  final String firstName;
  final String siteLabel;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Xin chào, $firstName',
          style: theme.textTheme.headlineSmall?.copyWith(
            color: AppColors.brand,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.xs,
                vertical: AppSpacing.xxs,
              ),
              decoration: BoxDecoration(
                color: AppColors.brand.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(2),
              ),
              child: Text(
                'CA NGÀY',
                style: theme.textTheme.labelSmall?.copyWith(
                  color: AppColors.brand,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.9,
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.xs),
            const Icon(
              Icons.location_on_outlined,
              size: 14,
              color: AppColors.textSecondary,
            ),
            const SizedBox(width: 2),
            Flexible(
              child: Text(
                'Warehouse: $siteLabel',
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.labelMedium?.copyWith(
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _SectionHeading extends StatelessWidget {
  const _SectionHeading({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: Theme.of(context).textTheme.labelMedium?.copyWith(
        color: AppColors.textPrimary,
        letterSpacing: 1.4,
        fontWeight: FontWeight.w700,
      ),
    );
  }
}

class _KpiSection extends StatelessWidget {
  const _KpiSection({required this.cardWidth, required this.snapshot});

  final double cardWidth;
  final HomeDashboardSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    final formatter = NumberFormat.decimalPattern('en_US');

    return Wrap(
      spacing: AppSpacing.sm,
      runSpacing: AppSpacing.sm,
      children: [
        _KpiCard(
          label: 'Đơn hôm nay',
          value: formatter.format(snapshot.ordersToday),
          icon: Icons.receipt_long_rounded,
        ),
        _KpiCard(
          label: 'Chờ xử lý',
          value: formatter.format(snapshot.pendingTasks),
          icon: Icons.pending_actions_rounded,
        ),
        _KpiCard(
          label: 'Tồn thấp',
          value: snapshot.lowStockCount.toString().padLeft(2, '0'),
          icon: Icons.warning_amber_rounded,
          isWarning: true,
        ),
        _KpiCard(
          label: 'Tồn kho',
          value: formatter.format(snapshot.totalInventoryQty),
          icon: Icons.inventory_2_rounded,
          isPrimary: true,
        ),
      ].map((card) => SizedBox(width: cardWidth, child: card)).toList(),
    );
  }
}

class _KpiCard extends StatelessWidget {
  const _KpiCard({
    required this.label,
    required this.value,
    required this.icon,
    this.isWarning = false,
    this.isPrimary = false,
  });

  final String label;
  final String value;
  final IconData icon;
  final bool isWarning;
  final bool isPrimary;

  @override
  Widget build(BuildContext context) {
    final bgColor = isPrimary
        ? AppColors.brand
        : isWarning
        ? AppColors.warning.withValues(alpha: 0.24)
        : AppColors.surface;
    final iconColor = isPrimary
        ? AppColors.info.withValues(alpha: 0.55)
        : isWarning
        ? AppColors.warning
        : AppColors.brand;
    final labelColor = isPrimary
        ? AppColors.surface.withValues(alpha: 0.85)
        : isWarning
        ? AppColors.textPrimary
        : AppColors.textSecondary;
    final valueColor = isPrimary
        ? AppColors.surface
        : isWarning
        ? AppColors.warning
        : AppColors.brand;

    return Container(
      height: 128,
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(8),
        border: isPrimary
            ? null
            : Border.all(
                color: isWarning
                    ? AppColors.warning.withValues(alpha: 0.4)
                    : AppColors.border,
              ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: iconColor, size: 20),
          const SizedBox(height: AppSpacing.xs),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: labelColor,
              fontWeight: FontWeight.w700,
              letterSpacing: 1,
            ),
          ),
          const Spacer(),
          Text(
            value,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: valueColor,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _QuickActionButton extends StatelessWidget {
  const _QuickActionButton({
    required this.icon,
    required this.title,
    required this.width,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final double width;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: Material(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(8),
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.border),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x0D000000),
                  blurRadius: 2,
                  offset: Offset(0, 1),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: AppColors.info.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Icon(icon, color: AppColors.brand),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Text(
                    title,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: AppColors.brand,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _AlertsSection extends StatelessWidget {
  const _AlertsSection({required this.alerts});

  final List<HomeAlertEntry> alerts;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (var index = 0; index < alerts.length; index++) ...[
          _AlertCard(
            title: alerts[index].title,
            subtitle: alerts[index].subtitle,
            leadingIcon: alerts[index].isWarning
                ? Icons.warning_amber_rounded
                : Icons.pending_actions_rounded,
            isWarning: alerts[index].isWarning,
          ),
          if (index < alerts.length - 1) const SizedBox(height: AppSpacing.xs),
        ],
      ],
    );
  }
}

class _AlertCard extends StatelessWidget {
  const _AlertCard({
    required this.title,
    required this.subtitle,
    required this.leadingIcon,
    this.isWarning = false,
  });

  final String title;
  final String subtitle;
  final IconData leadingIcon;
  final bool isWarning;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        color: isWarning
            ? AppColors.warning.withValues(alpha: 0.16)
            : AppColors.info.withValues(alpha: 0.16),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(
          color: isWarning
              ? AppColors.warning.withValues(alpha: 0.45)
              : AppColors.info.withValues(alpha: 0.45),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            leadingIcon,
            size: 18,
            color: isWarning ? AppColors.warning : AppColors.brand,
          ),
          const SizedBox(width: AppSpacing.xs),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: isWarning ? AppColors.warning : AppColors.brand,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.xs),
          const Icon(
            Icons.chevron_right_rounded,
            size: 18,
            color: AppColors.textSecondary,
          ),
        ],
      ),
    );
  }
}

class _RecentActivitySection extends StatelessWidget {
  const _RecentActivitySection({
    required this.onViewAll,
    required this.activities,
  });

  final VoidCallback onViewAll;
  final List<HomeActivityEntry> activities;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Expanded(child: _SectionHeading(title: 'Hoạt động gần đây')),
            TextButton(onPressed: onViewAll, child: const Text('Xem tất cả')),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        for (var index = 0; index < activities.length; index++) ...[
          _ActivityCard(
            title: activities[index].title,
            time: DateFormat(
              'hh:mm a',
            ).format(activities[index].occurredAt.toLocal()),
            detail: activities[index].detail,
            badge: activities[index].badge,
            completed: activities[index].completed,
          ),
          if (index < activities.length - 1)
            const SizedBox(height: AppSpacing.xs),
        ],
      ],
    );
  }
}

class _ActivityCard extends StatelessWidget {
  const _ActivityCard({
    required this.title,
    required this.time,
    required this.detail,
    required this.badge,
    this.completed = false,
  });

  final String title;
  final String time;
  final String detail;
  final String badge;
  final bool completed;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: AppColors.info.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Icon(
              completed ? Icons.local_shipping_rounded : Icons.move_to_inbox,
              size: 14,
              color: AppColors.brand,
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: AppColors.brand,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    Text(
                      time,
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  detail,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.xs,
                    vertical: AppSpacing.xxs,
                  ),
                  decoration: BoxDecoration(
                    color: completed
                        ? AppColors.success.withValues(alpha: 0.15)
                        : AppColors.brand.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(2),
                  ),
                  child: Text(
                    badge,
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: completed ? AppColors.success : AppColors.brand,
                      fontWeight: FontWeight.w700,
                    ),
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
