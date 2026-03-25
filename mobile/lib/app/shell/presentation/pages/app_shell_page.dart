import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smartlog_swm_mobile/app/router/app_route_paths.dart';
import 'package:smartlog_swm_mobile/app/shell/application/controllers/app_shell_controller.dart';
import 'package:smartlog_swm_mobile/app/shell/presentation/pages/notifications_page.dart';
import 'package:smartlog_swm_mobile/app/shell/presentation/widgets/app_bottom_nav.dart';
import 'package:smartlog_swm_mobile/app/shell/presentation/widgets/app_top_bar.dart';
import 'package:smartlog_swm_mobile/app/shell/presentation/widgets/scan_action_sheet.dart';
import 'package:smartlog_swm_mobile/shared/theme/app_colors.dart';

class AppShellPage extends ConsumerWidget {
  const AppShellPage({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final shellState = ref.watch(appShellControllerProvider);
    final tabs = _buildTabs(shellState);
    final currentTab = _currentTabForBranch(
      tabs: tabs,
      branchIndex: navigationShell.currentIndex,
    );

    return Scaffold(
      appBar: AppTopBar(
        site: shellState.currentSite,
        title: currentTab.title,
        role: shellState.currentRole,
        displayName: shellState.displayName,
        notificationCount: shellState.badgeCounts.notifications,
        onNotificationsPressed: () {
          showNotificationsSheet(context);
        },
        onAvatarPressed: () {
          context.go(AppRoutePaths.account);
        },
      ),
      body: navigationShell,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: shellState.showScanFab
          ? FloatingActionButton.extended(
              tooltip: 'Mở scan nhanh',
              onPressed: () => showScanActionSheet(context),
              backgroundColor: AppColors.brand,
              foregroundColor: AppColors.surface,
              icon: const Icon(Icons.qr_code_scanner_rounded),
              label: const Text('Scan'),
            )
          : null,
      bottomNavigationBar: AppBottomNav(
        items: tabs.map((tab) => tab.bottomNavItem).toList(growable: false),
        selectedBranchIndex: navigationShell.currentIndex,
        showFabGap: shellState.showScanFab,
        onTap: (item) {
          navigationShell.goBranch(item.branchIndex);
        },
      ),
    );
  }

  List<_ShellTabSpec> _buildTabs(AppShellState shellState) {
    final tabs = <_ShellTabSpec>[
      const _ShellTabSpec(
        title: 'Tổng quan kho',
        label: 'Home',
        icon: Icons.dashboard_outlined,
        activeIcon: Icons.dashboard_rounded,
        branchIndex: 0,
      ),
      if (shellState.showTasksTab)
        _ShellTabSpec(
          title: 'Hàng chờ xử lý',
          label: 'Công việc',
          icon: Icons.checklist_outlined,
          activeIcon: Icons.checklist_rounded,
          branchIndex: 1,
          badgeCount: shellState.badgeCounts.tasks,
        ),
      _ShellTabSpec(
        title: 'Tồn kho',
        label: 'Tồn kho',
        icon: Icons.inventory_2_outlined,
        activeIcon: Icons.inventory_2_rounded,
        branchIndex: 2,
        badgeCount: shellState.badgeCounts.inventory,
      ),
      _ShellTabSpec(
        title: 'More',
        label: 'More',
        icon: Icons.grid_view_outlined,
        activeIcon: Icons.grid_view_rounded,
        branchIndex: 3,
        badgeCount: shellState.badgeCounts.more,
      ),
    ];

    return tabs;
  }

  _ShellTabSpec _currentTabForBranch({
    required List<_ShellTabSpec> tabs,
    required int branchIndex,
  }) {
    for (final tab in tabs) {
      if (tab.branchIndex == branchIndex) {
        return tab;
      }
    }

    return tabs.first;
  }
}

class _ShellTabSpec {
  const _ShellTabSpec({
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

  AppBottomNavItem get bottomNavItem {
    return AppBottomNavItem(
      title: title,
      label: label,
      icon: icon,
      activeIcon: activeIcon,
      branchIndex: branchIndex,
      badgeCount: badgeCount,
    );
  }
}
