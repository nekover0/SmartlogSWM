import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smartlog_swm_mobile/app/router/app_route_paths.dart';
import 'package:smartlog_swm_mobile/app/shell/application/controllers/app_shell_controller.dart';
import 'package:smartlog_swm_mobile/core/permissions/role_guard.dart';
import 'package:smartlog_swm_mobile/core/permissions/role_matrix.dart';
import 'package:smartlog_swm_mobile/shared/theme/app_colors.dart';
import 'package:smartlog_swm_mobile/shared/theme/app_spacing.dart';
import 'package:smartlog_swm_mobile/shared/widgets/app_empty_state.dart';

class MorePage extends ConsumerWidget {
  const MorePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final shellState = ref.watch(appShellControllerProvider);
    final modules = _modulesForRole(shellState.currentRole.label);

    return ListView(
      padding: AppSpacing.pagePadding,
      children: [
        _HeroCard(shellState: shellState),
        const SizedBox(height: AppSpacing.lg),
        Text(
          'Module switcher',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        if (modules.isEmpty)
          const AppEmptyState(
            title: 'Không có module phù hợp',
            message: 'Vai trò hiện tại chưa được gán module trong More.',
          )
        else
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: modules.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: AppSpacing.sm,
              mainAxisSpacing: AppSpacing.sm,
              childAspectRatio: 1.08,
            ),
            itemBuilder: (BuildContext context, int index) {
              final module = modules[index];
              return _ModuleCard(
                module: module,
                onTap: () => context.go(module.route),
              );
            },
          ),
      ],
    );
  }

  List<_ModuleEntry> _modulesForRole(String roleName) {
    final modules = <_ModuleEntry>[
      const _ModuleEntry(
        title: 'Phiếu nhập',
        description: 'Mở danh sách inbound v3 và luồng tạo phiếu.',
        icon: Icons.call_received_rounded,
        route: AppRoutePaths.receiptList,
        module: AppModule.inbound,
      ),
      const _ModuleEntry(
        title: 'Phiếu xuất',
        description: 'Mở danh sách outbound v3 và chi tiết phiếu xuất.',
        icon: Icons.call_made_rounded,
        route: AppRoutePaths.shipmentList,
        module: AppModule.outbound,
      ),
      const _ModuleEntry(
        title: 'Kiểm kê và chuyển vị trí',
        description: 'Mở bộ công cụ điều phối count và move.',
        icon: Icons.swap_horiz_rounded,
        route: AppRoutePaths.inventoryControl,
        module: AppModule.inventoryControl,
      ),
      const _ModuleEntry(
        title: 'Báo cáo realtime',
        description: 'Xem KPI và cảnh báo realtime theo design.',
        icon: Icons.bar_chart_rounded,
        route: AppRoutePaths.reports,
        module: AppModule.reports,
      ),
      const _ModuleEntry(
        title: 'Tài khoản & RBAC',
        description: 'Mở màn hình tài khoản và phân quyền.',
        icon: Icons.admin_panel_settings_outlined,
        route: AppRoutePaths.account,
        module: AppModule.account,
      ),
    ];

    return modules
        .where(
          (module) => RoleGuard.canAccessModule(
            roleName: roleName,
            module: module.module,
          ),
        )
        .toList(growable: false);
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
            'More',
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
              _Pill(label: '${shellState.badgeCounts.more} module phụ'),
              const _Pill(label: 'Phiếu nhập sẽ xuất hiện ở đây'),
            ],
          ),
        ],
      ),
    );
  }
}

class _ModuleEntry {
  const _ModuleEntry({
    required this.title,
    required this.description,
    required this.icon,
    required this.route,
    required this.module,
  });

  final String title;
  final String description;
  final IconData icon;
  final String route;
  final AppModule module;
}

class _ModuleCard extends StatelessWidget {
  const _ModuleCard({
    required this.module,
    required this.onTap,
  });

  final _ModuleEntry module;
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: AppColors.brand.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(module.icon, color: AppColors.brand),
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                module.title,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                module.description,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
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
