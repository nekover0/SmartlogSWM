import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smartlog_swm_mobile/app/router/app_route_paths.dart';
import 'package:smartlog_swm_mobile/app/shell/application/controllers/app_shell_controller.dart';
import 'package:smartlog_swm_mobile/shared/theme/app_colors.dart';
import 'package:smartlog_swm_mobile/shared/theme/app_spacing.dart';

class TaskQueuePage extends ConsumerWidget {
  const TaskQueuePage({super.key, this.queueType});

  final String? queueType;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final shellState = ref.watch(appShellControllerProvider);

    return ListView(
      padding: AppSpacing.pagePadding,
      children: [
        _HeroCard(shellState: shellState, queueType: queueType),
        const SizedBox(height: AppSpacing.lg),
        Text(
          'Hàng đợi chính',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        _QueueCard(
          icon: Icons.call_received_rounded,
          title: 'Phiếu nhập',
          description: 'Gộp các phiếu inbound đang chờ cân, kiểm và chấp nhận.',
          route: AppRoutePaths.receiptList,
          accent: AppColors.info,
        ),
        const SizedBox(height: AppSpacing.sm),
        _QueueCard(
          icon: Icons.call_made_rounded,
          title: 'Phiếu xuất',
          description: 'Tổng hợp phiếu outbound cần xác nhận và đóng gói.',
          route: AppRoutePaths.shipmentList,
          accent: AppColors.success,
        ),
        const SizedBox(height: AppSpacing.sm),
        _QueueCard(
          icon: Icons.document_scanner_outlined,
          title: 'OCR xem xét',
          description: 'Chứng từ OCR đang chờ đội ngũ xem lại nội dung.',
          route: AppRoutePaths.ocrInbox,
          accent: AppColors.brandAccent,
        ),
        const SizedBox(height: AppSpacing.sm),
        _QueueCard(
          icon: Icons.swap_horiz_rounded,
          title: 'Kiểm kê và chuyển vị trí',
          description: 'Điều phối các luồng count, move và điều chỉnh vị trí.',
          route: AppRoutePaths.inventoryControl,
          accent: AppColors.warning,
        ),
      ],
    );
  }
}

class _HeroCard extends StatelessWidget {
  const _HeroCard({
    required this.shellState,
    required this.queueType,
  });

  final AppShellState shellState;
  final String? queueType;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(AppSpacing.xl),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        color: AppColors.surface,
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Hàng chờ xử lý',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            '${shellState.currentSite.label} · ${shellState.currentRole.label}',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Wrap(
            spacing: AppSpacing.xs,
            runSpacing: AppSpacing.xs,
            children: [
              _Pill(label: '${shellState.badgeCounts.tasks} tác vụ'),
              _Pill(
                label: queueType == null
                    ? 'Toàn bộ hàng đợi'
                    : 'Bộ lọc: ${_formatQueueType(queueType!)}',
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            'Shell hiện tại là placeholder có điều hướng thật, không phải màn hoang dã.',
            style: theme.textTheme.bodyLarge,
          ),
        ],
      ),
    );
  }

  String _formatQueueType(String value) {
    switch (value) {
      case 'weighing':
        return 'Cân hàng';
      default:
        return value;
    }
  }
}

class _QueueCard extends StatelessWidget {
  const _QueueCard({
    required this.icon,
    required this.title,
    required this.description,
    required this.route,
    required this.accent,
  });

  final IconData icon;
  final String title;
  final String description;
  final String route;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () => context.go(route),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Row(
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: accent.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(icon, color: accent),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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
              const SizedBox(width: AppSpacing.sm),
              const Icon(Icons.chevron_right_rounded),
            ],
          ),
        ),
      ),
    );
  }
}

class _Pill extends StatelessWidget {
  const _Pill({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelMedium?.copyWith(
          color: AppColors.textPrimary,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
