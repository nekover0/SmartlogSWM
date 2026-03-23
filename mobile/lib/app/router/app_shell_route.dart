import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:smartlog_swm_mobile/app/router/app_route_names.dart';
import 'package:smartlog_swm_mobile/app/router/app_route_paths.dart';
import 'package:smartlog_swm_mobile/app/shell/presentation/pages/app_shell_page.dart';
import 'package:smartlog_swm_mobile/features/home/presentation/pages/home_dashboard_page.dart';
import 'package:smartlog_swm_mobile/features/inventory/presentation/pages/inventory_list_page.dart';
import 'package:smartlog_swm_mobile/features/more/presentation/pages/more_page.dart';
import 'package:smartlog_swm_mobile/features/tasks/presentation/pages/task_queue_page.dart';

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
          return AppShellPage(navigationShell: navigationShell);
        },
    branches: <StatefulShellBranch>[
      StatefulShellBranch(
        navigatorKey: _homeNavigatorKey,
        routes: <RouteBase>[
          GoRoute(
            path: AppRoutePaths.home,
            name: AppRouteNames.home,
            builder: (BuildContext context, GoRouterState state) {
              return const HomeDashboardPage();
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
              return TaskQueuePage(
                queueType: state.uri.queryParameters['type'],
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
              return const InventoryListPage();
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
              return const MorePage();
            },
          ),
        ],
      ),
    ],
  );
}
