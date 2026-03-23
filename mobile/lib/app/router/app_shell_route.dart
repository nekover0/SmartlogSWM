import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:smartlog_swm_mobile/app/router/app_route_names.dart';
import 'package:smartlog_swm_mobile/app/router/app_route_paths.dart';
import 'package:smartlog_swm_mobile/core/permissions/role_guard.dart';
import 'package:smartlog_swm_mobile/features/auth/application/controllers/auth_controller.dart';
import 'package:smartlog_swm_mobile/shared/theme/app_colors.dart';
import 'package:smartlog_swm_mobile/shared/theme/app_spacing.dart';

final GlobalKey<NavigatorState> _homeNavigatorKey = GlobalKey<NavigatorState>(
  debugLabel: 'homeShellNavigator',
);
final GlobalKey<NavigatorState> _tasksNavigatorKey = GlobalKey<NavigatorState>(
  debugLabel: 'tasksShellNavigator',
);
final GlobalKey<NavigatorState> _inventoryNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'inventoryShellNavigator');
final GlobalKey<NavigatorState> _moreNavigatorKey = GlobalKey<NavigatorState>(
  debugLabel: 'moreShellNavigator',
);

StatefulShellRoute buildAppShellRoute() {
  return StatefulShellRoute.indexedStack(
    builder:
        (
          BuildContext context,
          GoRouterState state,
          StatefulNavigationShell navigationShell,
        ) {
          return AppShellScaffold(navigationShell: navigationShell);
        },
    branches: <StatefulShellBranch>[
      StatefulShellBranch(
        navigatorKey: _homeNavigatorKey,
        routes: <RouteBase>[
          GoRoute(
            path: AppRoutePaths.home,
            name: AppRouteNames.home,
            builder: (BuildContext context, GoRouterState state) {
              return const AppShellTabPlaceholderBody(
                icon: Icons.dashboard_rounded,
                frameLabel: '02. Refined Dashboard',
                routePath: AppRoutePaths.home,
                title: 'Tổng quan kho',
                description:
                    'Dashboard khởi điểm cho vận hành kho, phản ánh số liệu, công việc và cảnh báo theo Figma.',
              );
            },
          ),
        ],
      ),
      StatefulShellBranch(
        navigatorKey: _tasksNavigatorKey,
        routes: <RouteBase>[
          GoRoute(
            path: AppRoutePaths.tasks,
            name: AppRouteNames.tasks,
            builder: (BuildContext context, GoRouterState state) {
              return const AppShellTabPlaceholderBody(
                icon: Icons.checklist_rounded,
                frameLabel: '14. Hàng chờ xử lý',
                routePath: AppRoutePaths.tasks,
                title: 'Công việc',
                description:
                    'Khu vực gom các queue nhập, xuất, OCR và tác vụ xử lý để bám sát flow vận hành.',
              );
            },
          ),
        ],
      ),
      StatefulShellBranch(
        navigatorKey: _inventoryNavigatorKey,
        routes: <RouteBase>[
          GoRoute(
            path: AppRoutePaths.inventory,
            name: AppRouteNames.inventory,
            builder: (BuildContext context, GoRouterState state) {
              return const AppShellTabPlaceholderBody(
                icon: Icons.inventory_2_rounded,
                frameLabel: '04. Refined Inventory List',
                routePath: AppRoutePaths.inventory,
                title: 'Tồn kho',
                description:
                    'Danh sách tồn kho và luồng drill-down chi tiết theo thiết kế Figma.',
              );
            },
          ),
        ],
      ),
      StatefulShellBranch(
        navigatorKey: _moreNavigatorKey,
        routes: <RouteBase>[
          GoRoute(
            path: AppRoutePaths.more,
            name: AppRouteNames.more,
            builder: (BuildContext context, GoRouterState state) {
              return const AppShellTabPlaceholderBody(
                icon: Icons.grid_view_rounded,
                frameLabel: '07. Refined Account & RBAC Screen',
                routePath: AppRoutePaths.more,
                title: 'More',
                description:
                    'Cổng điều hướng tới tài khoản, RBAC, báo cáo và các module phụ trong phase sau.',
              );
            },
          ),
        ],
      ),
    ],
  );
}

class AppShellScaffold extends ConsumerWidget {
  const AppShellScaffold({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authControllerProvider);
    final session = authState.valueOrNull;
    final roleName = session?.currentUser.role ?? 'Customer Viewer';
    final siteName = session?.currentUser.siteName ?? 'Smartlog WMS';
    final displayName = session?.currentUser.displayName ?? 'Người dùng';
    final showTasksTab = RoleGuard.showsTasksTab(roleName);
    final showScanFab = RoleGuard.showsScanFab(roleName);
    final tabs = _shellTabsForRole(showTasksTab);
    final selectedVisibleIndex = tabs.indexWhere(
      (_ShellNavItem item) => item.branchIndex == navigationShell.currentIndex,
    );

    return Scaffold(
      extendBody: true,
      appBar: AppBar(
        toolbarHeight: 78,
        titleSpacing: AppSpacing.md,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              siteName,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 2),
            Text(
              '$displayName · $roleName',
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: AppColors.textSecondary),
            ),
          ],
        ),
        actions: [
          IconButton(
            tooltip: 'Thông báo',
            onPressed: () => context.go(AppRoutePaths.notifications),
            icon: const Icon(Icons.notifications_none_rounded),
          ),
          Padding(
            padding: const EdgeInsets.only(right: AppSpacing.md),
            child: GestureDetector(
              onTap: () => context.go(AppRoutePaths.account),
              child: CircleAvatar(
                radius: 19,
                backgroundColor: AppColors.brand,
                child: Text(
                  _initialsFromName(displayName),
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: AppColors.surface,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: navigationShell,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: showScanFab
          ? FloatingActionButton.extended(
              onPressed: () => context.go(AppRoutePaths.scanBarcode),
              backgroundColor: AppColors.brand,
              foregroundColor: AppColors.surface,
              icon: const Icon(Icons.qr_code_scanner_rounded),
              label: const Text('Scan'),
            )
          : null,
      bottomNavigationBar: _ShellBottomBar(
        items: tabs,
        selectedVisibleIndex: selectedVisibleIndex < 0
            ? 0
            : selectedVisibleIndex,
        showScanFab: showScanFab,
        onTap: (item) => navigationShell.goBranch(item.branchIndex),
      ),
    );
  }
}

class AppShellTabPlaceholderBody extends StatelessWidget {
  const AppShellTabPlaceholderBody({
    super.key,
    required this.icon,
    required this.frameLabel,
    required this.routePath,
    required this.title,
    required this.description,
  });

  final IconData icon;
  final String frameLabel;
  final String routePath;
  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: AppSpacing.pagePadding,
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 560),
            child: _PlaceholderPanel(
              icon: icon,
              frameLabel: frameLabel,
              routePath: routePath,
              title: title,
              description: description,
            ),
          ),
        ),
      ),
    );
  }
}

class AppRoutePlaceholderPage extends StatelessWidget {
  const AppRoutePlaceholderPage({
    super.key,
    required this.icon,
    required this.frameLabel,
    required this.routePath,
    required this.title,
    required this.description,
  });

  final IconData icon;
  final String frameLabel;
  final String routePath;
  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: <Color>[
              Color(0xFFE9F0FB),
              AppColors.background,
              Color(0xFFF8FAFD),
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: AppSpacing.pagePadding,
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 560),
                child: _PlaceholderPanel(
                  icon: icon,
                  frameLabel: frameLabel,
                  routePath: routePath,
                  title: title,
                  description: description,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ShellBottomBar extends StatelessWidget {
  const _ShellBottomBar({
    required this.items,
    required this.selectedVisibleIndex,
    required this.showScanFab,
    required this.onTap,
  });

  final List<_ShellNavItem> items;
  final int selectedVisibleIndex;
  final bool showScanFab;
  final ValueChanged<_ShellNavItem> onTap;

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
      if (showScanFab && index == 2) {
        children.add(const SizedBox(width: 72));
      }

      final item = items[index];
      children.add(
        Expanded(
          child: _ShellNavButton(
            item: item,
            selected: index == selectedVisibleIndex,
            onTap: () => onTap(item),
          ),
        ),
      );
    }

    return children;
  }
}

class _ShellNavButton extends StatelessWidget {
  const _ShellNavButton({
    required this.item,
    required this.selected,
    required this.onTap,
  });

  final _ShellNavItem item;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = selected ? AppColors.brand : AppColors.textSecondary;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                selected ? item.activeIcon : item.icon,
                color: color,
                size: 24,
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
    );
  }
}

class _PlaceholderPanel extends StatelessWidget {
  const _PlaceholderPanel({
    required this.icon,
    required this.frameLabel,
    required this.routePath,
    required this.title,
    required this.description,
  });

  final IconData icon;
  final String frameLabel;
  final String routePath;
  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: AppSpacing.cardPadding,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 54,
                  height: 54,
                  decoration: BoxDecoration(
                    color: AppColors.brand.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Icon(icon, color: AppColors.brand, size: 28),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        frameLabel,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(description, style: theme.textTheme.bodyLarge),
            const SizedBox(height: AppSpacing.lg),
            Wrap(
              spacing: AppSpacing.xs,
              runSpacing: AppSpacing.xs,
              children: [
                _MiniChip(label: 'Route: $routePath'),
                _MiniChip(label: 'Figma: $frameLabel'),
                const _MiniChip(label: 'Task 11 skeleton'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _MiniChip extends StatelessWidget {
  const _MiniChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Text(label),
      side: const BorderSide(color: AppColors.border),
      backgroundColor: AppColors.surface,
      labelStyle: Theme.of(context).textTheme.labelMedium?.copyWith(
        color: AppColors.textPrimary,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}

class _ShellNavItem {
  const _ShellNavItem({
    required this.label,
    required this.icon,
    required this.activeIcon,
    required this.branchIndex,
  });

  final String label;
  final IconData icon;
  final IconData activeIcon;
  final int branchIndex;
}

List<_ShellNavItem> _shellTabsForRole(bool showTasksTab) {
  return <_ShellNavItem>[
    const _ShellNavItem(
      label: 'Home',
      icon: Icons.home_outlined,
      activeIcon: Icons.home_rounded,
      branchIndex: 0,
    ),
    if (showTasksTab)
      const _ShellNavItem(
        label: 'Công việc',
        icon: Icons.checklist_outlined,
        activeIcon: Icons.checklist_rounded,
        branchIndex: 1,
      ),
    const _ShellNavItem(
      label: 'Tồn kho',
      icon: Icons.inventory_2_outlined,
      activeIcon: Icons.inventory_2_rounded,
      branchIndex: 2,
    ),
    const _ShellNavItem(
      label: 'More',
      icon: Icons.grid_view_outlined,
      activeIcon: Icons.grid_view_rounded,
      branchIndex: 3,
    ),
  ];
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
