import 'dart:collection';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smartlog_swm_mobile/features/tasks/data/contracts/task_item_contract.dart';
import 'package:smartlog_swm_mobile/features/tasks/data/repositories/task_repository_impl.dart';
import 'package:smartlog_swm_mobile/features/tasks/domain/repositories/task_repository.dart';
import 'package:smartlog_swm_mobile/shared/contracts/shared_contracts.dart';

final taskQueueControllerProvider =
    AsyncNotifierProvider<TaskQueueController, TaskQueueState>(
      TaskQueueController.new,
    );

class TaskQueueController extends AsyncNotifier<TaskQueueState> {
  TaskRepository get _repository => ref.read(taskRepositoryProvider);

  @override
  Future<TaskQueueState> build() async {
    final items = await _repository.getTaskQueue();
    return TaskQueueState(allItems: items);
  }

  Future<void> refresh() async {
    final currentState = state.valueOrNull;
    final items = await _repository.getTaskQueue();

    state = AsyncData(
      TaskQueueState(
        allItems: items,
        selectedSeverity: currentState?.selectedSeverity,
        selectedType: currentState?.selectedType,
      ),
    );
  }

  void setSeverityFilter(Severity? severity) {
    final currentState = state.valueOrNull;
    if (currentState == null) {
      return;
    }

    state = AsyncData(
      TaskQueueState(
        allItems: currentState.allItems,
        selectedSeverity: severity,
        selectedType: currentState.selectedType,
      ),
    );
  }

  void setTypeFilter(TaskItemType? type) {
    final currentState = state.valueOrNull;
    if (currentState == null) {
      return;
    }

    state = AsyncData(
      TaskQueueState(
        allItems: currentState.allItems,
        selectedSeverity: currentState.selectedSeverity,
        selectedType: type,
      ),
    );
  }

  void clearFilters() {
    final currentState = state.valueOrNull;
    if (currentState == null) {
      return;
    }

    state = AsyncData(TaskQueueState(allItems: currentState.allItems));
  }
}

class TaskQueueState {
  const TaskQueueState({
    required this.allItems,
    this.selectedSeverity,
    this.selectedType,
  });

  final List<TaskItemEntity> allItems;
  final Severity? selectedSeverity;
  final TaskItemType? selectedType;

  List<TaskItemEntity> get pendingItems {
    final items = allItems.where(_isPending).toList(growable: false);
    return UnmodifiableListView<TaskItemEntity>(items);
  }

  List<TaskItemEntity> get visibleItems {
    final items = pendingItems.where((item) {
      final severityMatches =
          selectedSeverity == null || item.severity == selectedSeverity;
      final typeMatches = selectedType == null || item.type == selectedType;
      return severityMatches && typeMatches;
    }).toList(growable: false)
      ..sort(_compareTaskItems);

    return UnmodifiableListView<TaskItemEntity>(items);
  }

  List<TaskItemType> get availableTypes {
    final types = TaskItemType.values.where(
      (type) => pendingItems.any((item) => item.type == type),
    );
    return UnmodifiableListView<TaskItemType>(types);
  }

  int get pendingTaskCount => pendingItems.length;

  int get criticalTaskCount =>
      pendingItems.where((item) => item.severity == Severity.critical).length;

  bool get hasActiveFilters =>
      selectedSeverity != null || selectedType != null;

  bool get isEmpty => visibleItems.isEmpty;

  int countForSeverity(Severity? severity) {
    if (severity == null) {
      return pendingTaskCount;
    }

    return pendingItems.where((item) => item.severity == severity).length;
  }

  int countForType(TaskItemType? type) {
    if (type == null) {
      return pendingTaskCount;
    }

    return pendingItems.where((item) => item.type == type).length;
  }

  static bool _isPending(TaskItemEntity item) {
    return item.status != TaskItemStatus.completed;
  }

  static int _compareTaskItems(TaskItemEntity left, TaskItemEntity right) {
    final severityComparison = _severityRank(
      left.severity,
    ).compareTo(_severityRank(right.severity));
    if (severityComparison != 0) {
      return severityComparison;
    }

    final statusComparison = _statusRank(left.status).compareTo(
      _statusRank(right.status),
    );
    if (statusComparison != 0) {
      return statusComparison;
    }

    final dueDateComparison = _compareNullableDates(left.dueAt, right.dueAt);
    if (dueDateComparison != 0) {
      return dueDateComparison;
    }

    final ageComparison = (right.ageMinutes ?? 0).compareTo(left.ageMinutes ?? 0);
    if (ageComparison != 0) {
      return ageComparison;
    }

    return left.createdAt.compareTo(right.createdAt);
  }

  static int _severityRank(Severity severity) {
    return switch (severity) {
      Severity.critical => 0,
      Severity.high => 1,
      Severity.medium => 2,
      Severity.low => 3,
    };
  }

  static int _statusRank(TaskItemStatus status) {
    return switch (status) {
      TaskItemStatus.open => 0,
      TaskItemStatus.acknowledged => 1,
      TaskItemStatus.snoozed => 2,
      TaskItemStatus.completed => 3,
    };
  }

  static int _compareNullableDates(DateTime? left, DateTime? right) {
    if (left == null && right == null) {
      return 0;
    }
    if (left == null) {
      return 1;
    }
    if (right == null) {
      return -1;
    }
    return left.compareTo(right);
  }
}
