class AppBadgeCounts {
  const AppBadgeCounts({
    required this.notifications,
    required this.tasks,
    required this.inventory,
    required this.more,
  });

  final int notifications;
  final int tasks;
  final int inventory;
  final int more;

  const AppBadgeCounts.zero()
      : notifications = 0,
        tasks = 0,
        inventory = 0,
        more = 0;

  factory AppBadgeCounts.demo({required bool showTasksTab}) {
    if (showTasksTab) {
      return const AppBadgeCounts(
        notifications: 4,
        tasks: 7,
        inventory: 2,
        more: 5,
      );
    }

    return const AppBadgeCounts(
      notifications: 2,
      tasks: 0,
      inventory: 3,
      more: 4,
    );
  }

  bool get hasAny =>
      notifications > 0 || tasks > 0 || inventory > 0 || more > 0;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is AppBadgeCounts &&
            runtimeType == other.runtimeType &&
            notifications == other.notifications &&
            tasks == other.tasks &&
            inventory == other.inventory &&
            more == other.more;
  }

  @override
  int get hashCode => Object.hash(notifications, tasks, inventory, more);
}
