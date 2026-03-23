import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smartlog_swm_mobile/app/router/app_route_paths.dart';
import 'package:smartlog_swm_mobile/app/shell/application/controllers/app_shell_controller.dart';
import 'package:smartlog_swm_mobile/app/shell/presentation/pages/notifications_page.dart';
import 'package:smartlog_swm_mobile/app/shell/presentation/widgets/scan_action_sheet.dart';
import 'package:smartlog_swm_mobile/shared/theme/app_colors.dart';
import 'package:smartlog_swm_mobile/shared/theme/app_spacing.dart';

class HomeDashboardPage extends ConsumerWidget {
  const HomeDashboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final shellState = ref.watch(appShellControllerProvider);

    return ListView(
      padding: AppSpacing.pagePadding,
      children: [
        _HeroCard(shellState: shellState),
        const SizedBox(height: AppSpacing.lg),
        Text(
          'Nhanh hôm nay',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Wrap(
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.sm,
          children: [
            _ActionCard(
              icon: Icons.qr_code_scanner_rounded,
              title: 'Quét nhanh',
              description: 'Mở FAB scan để vào barcode, OCR hoặc nhập tay.',
              onTap: () => showScanActionSheet(context),
            ),
            _ActionCard(
              icon: Icons.checklist_rounded,
              title: 'Công việc',
              description: 'Xem hàng đợi xử lý của ca làm việc hiện tại.',
              onTap: () => context.go(AppRoutePaths.tasks),
            ),
            _ActionCard(
              icon: Icons.inventory_2_rounded,
              title: 'Tồn kho',
              description: 'Vào danh sách tồn kho và drill-down mẫu.',
              onTap: () => context.go(AppRoutePaths.inventory),
            ),
            _ActionCard(
              icon: Icons.notifications_active_outlined,
              title: 'Thông báo',
              description: 'Mở trung tâm thông báo dạng bottom sheet.',
              onTap: () => showNotificationsSheet(context),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.lg),
        Text(
          'Tín hiệu vận hành',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        _MetricsPanel(shellState: shellState),
      ],
    );
  }
}

class _HeroCard extends StatelessWidget {
  const _HeroCard({required this.shellState});

  final AppShellState shellState;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(AppSpacing.xl),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.brand, AppColors.brandAccent],
        ),
        borderRadius: BorderRadius.circular(28),
        boxShadow: const [
          BoxShadow(
            color: Color(0x1A103B73),
            blurRadius: 24,
            offset: Offset(0, 16),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.14),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: const Icon(
                  Icons.warehouse_outlined,
                  color: AppColors.surface,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Tổng quan hôm nay',
                      style: theme.textTheme.headlineSmall?.copyWith(
                        color: AppColors.surface,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${shellState.currentSite.label} · ${shellState.currentRole.label}',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: Colors.white.withValues(alpha: 0.88),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(
            'Shell mobile đang chạy ở trạng thái placeholder có điều hướng thật, sẵn sàng thay nội dung task sau.',
            style: theme.textTheme.bodyLarge?.copyWith(
              color: Colors.white.withValues(alpha: 0.9),
            ),
          ),
        ],
      ),
    );
  }
}

class _MetricsPanel extends StatelessWidget {
  const _MetricsPanel({required this.shellState});

  final AppShellState shellState;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Wrap(
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.sm,
          children: [
            _MetricTile(
              icon: Icons.notifications_none_rounded,
              label: 'Thông báo',
              value: '${shellState.badgeCounts.notifications}',
            ),
            _MetricTile(
              icon: Icons.checklist_rounded,
              label: 'Công việc',
              value: '${shellState.badgeCounts.tasks}',
            ),
            _MetricTile(
              icon: Icons.inventory_2_rounded,
              label: 'Tồn kho',
              value: '${shellState.badgeCounts.inventory}',
            ),
            _MetricTile(
              icon: Icons.grid_view_rounded,
              label: 'More',
              value: '${shellState.badgeCounts.more}',
            ),
          ],
        ),
      ),
    );
  }
}

class _MetricTile extends StatelessWidget {
  const _MetricTile({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: 152,
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: AppColors.brand.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: AppColors.brand),
          ),
          const SizedBox(width: AppSpacing.sm),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),
              Text(
                label,
                style: theme.textTheme.labelMedium?.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ActionCard extends StatelessWidget {
  const _ActionCard({
    required this.icon,
    required this.title,
    required this.description,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String description;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final width = (MediaQuery.of(context).size.width - 48) / 2;

    return SizedBox(
      width: width,
      child: Card(
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: AppColors.brand.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(icon, color: AppColors.brand),
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  title,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  description,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: AppColors.textSecondary,
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
