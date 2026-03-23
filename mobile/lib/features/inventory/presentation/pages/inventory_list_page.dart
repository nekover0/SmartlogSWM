import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smartlog_swm_mobile/app/router/app_route_paths.dart';
import 'package:smartlog_swm_mobile/app/shell/application/controllers/app_shell_controller.dart';
import 'package:smartlog_swm_mobile/shared/theme/app_colors.dart';
import 'package:smartlog_swm_mobile/shared/theme/app_spacing.dart';

class InventoryListPage extends ConsumerWidget {
  const InventoryListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final shellState = ref.watch(appShellControllerProvider);

    return ListView(
      padding: AppSpacing.pagePadding,
      children: [
        _HeroCard(shellState: shellState),
        const SizedBox(height: AppSpacing.lg),
        TextField(
          readOnly: true,
          decoration: const InputDecoration(
            prefixIcon: Icon(Icons.search_rounded),
            hintText: 'Tìm SKU, tên hàng hoặc vị trí',
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        Text(
          'Mẫu danh sách tồn kho',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        ..._inventorySamples.map(
          (sample) => Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.sm),
            child: _InventoryCard(
              sample: sample,
              onTap: () => context.go(
                AppRoutePaths.inventoryDetailPath(sample.id),
              ),
            ),
          ),
        ),
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
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Tồn kho',
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
              _Pill(label: '${shellState.badgeCounts.inventory} mục cần theo dõi'),
              const _Pill(label: 'Có thể drill-down sang chi tiết'),
            ],
          ),
        ],
      ),
    );
  }
}

class _InventoryCard extends StatelessWidget {
  const _InventoryCard({
    required this.sample,
    required this.onTap,
  });

  final _InventorySample sample;
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
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: sample.accent.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(sample.icon, color: sample.accent),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      sample.title,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      sample.subtitle,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Wrap(
                      spacing: AppSpacing.xs,
                      runSpacing: AppSpacing.xs,
                      children: [
                        _Pill(label: sample.status),
                        _Pill(label: sample.location),
                      ],
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

class _InventorySample {
  const _InventorySample({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.status,
    required this.location,
    required this.icon,
    required this.accent,
  });

  final String id;
  final String title;
  final String subtitle;
  final String status;
  final String location;
  final IconData icon;
  final Color accent;
}

const List<_InventorySample> _inventorySamples = <_InventorySample>[
  _InventorySample(
    id: 'INV-1001',
    title: 'Pallet nước khoáng',
    subtitle: 'SKU dùng cho bình luận low-stock và restock.',
    status: 'Tồn thấp',
    location: 'A-03-02',
    icon: Icons.local_drink_outlined,
    accent: AppColors.warning,
  ),
  _InventorySample(
    id: 'INV-1002',
    title: 'Thùng carton',
    subtitle: 'Mới cập nhật sau đợt count định kỳ.',
    status: 'Đang kiểm kê',
    location: 'B-01-04',
    icon: Icons.inventory_2_outlined,
    accent: AppColors.info,
  ),
  _InventorySample(
    id: 'INV-1003',
    title: 'Tem nhãn kho',
    subtitle: 'Sẵn sàng xuất kho và cảnh báo lô, tem.',
    status: 'Ổn định',
    location: 'C-02-01',
    icon: Icons.sell_outlined,
    accent: AppColors.success,
  ),
];

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
