import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smartlog_swm_mobile/app/shell/domain/models/app_badge_counts.dart';
import 'package:smartlog_swm_mobile/app/shell/domain/models/current_role.dart';
import 'package:smartlog_swm_mobile/app/shell/domain/models/current_site.dart';
import 'package:smartlog_swm_mobile/features/auth/application/controllers/auth_controller.dart';
import 'package:smartlog_swm_mobile/features/auth/domain/entities/auth_session.dart';
import 'package:smartlog_swm_mobile/features/tasks/application/controllers/task_queue_controller.dart';

final appShellControllerProvider =
    NotifierProvider<AppShellController, AppShellState>(
      AppShellController.new,
    );

class AppShellController extends Notifier<AppShellState> {
  @override
  AppShellState build() {
    final authState = ref.watch(authControllerProvider);
    final taskQueueState = ref.watch(taskQueueControllerProvider);
    final session = authState.valueOrNull;

    if (session == null) {
      return const AppShellState.unauthenticated();
    }

    return AppShellState.fromSession(
      session,
      taskPendingCount: taskQueueState.valueOrNull?.pendingTaskCount ?? 0,
    );
  }
}

class AppShellState {
  const AppShellState({
    required this.displayName,
    required this.currentRole,
    required this.currentSite,
    required this.badgeCounts,
  });

  final String displayName;
  final CurrentRole currentRole;
  final CurrentSite currentSite;
  final AppBadgeCounts badgeCounts;

  const AppShellState.unauthenticated()
      : displayName = 'Người dùng',
        currentRole = const CurrentRole(
          name: 'Customer Viewer',
          showTasksTab: false,
          showScanFab: false,
        ),
        currentSite = const CurrentSite(id: '', name: 'Smartlog WMS'),
        badgeCounts = const AppBadgeCounts.zero();

  factory AppShellState.fromSession(
    AuthSession session, {
    required int taskPendingCount,
  }) {
    final displayName = session.currentUser.displayName.trim().isEmpty
        ? session.currentUser.username.trim()
        : session.currentUser.displayName.trim();
    final currentRole = CurrentRole.fromRoleName(session.currentUser.role);

    return AppShellState(
      displayName: displayName,
      currentRole: currentRole,
      currentSite: CurrentSite.fromUser(session.currentUser),
      badgeCounts: AppBadgeCounts.demo(
        showTasksTab: currentRole.showTasksTab,
        taskCount: currentRole.showTasksTab ? taskPendingCount : 0,
      ),
    );
  }

  bool get showTasksTab => currentRole.showTasksTab;

  bool get showScanFab => currentRole.showScanFab;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is AppShellState &&
            runtimeType == other.runtimeType &&
            displayName == other.displayName &&
            currentRole == other.currentRole &&
            currentSite == other.currentSite &&
            badgeCounts == other.badgeCounts;
  }

  @override
  int get hashCode =>
      Object.hash(displayName, currentRole, currentSite, badgeCounts);
}
