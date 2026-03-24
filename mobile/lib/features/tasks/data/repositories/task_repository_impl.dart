import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smartlog_swm_mobile/features/tasks/data/contracts/task_item_contract.dart';
import 'package:smartlog_swm_mobile/features/tasks/data/datasources/task_queue_fixture_data_source.dart';
import 'package:smartlog_swm_mobile/features/tasks/domain/repositories/task_repository.dart';

final taskQueueFixtureDataSourceProvider = Provider<TaskQueueFixtureDataSource>((
  Ref<Object?> ref,
) {
  return TaskQueueFixtureDataSource();
});

final taskRepositoryProvider = Provider<TaskRepository>((Ref<Object?> ref) {
  return TaskRepositoryImpl(
    fixtureDataSource: ref.watch(taskQueueFixtureDataSourceProvider),
  );
});

class TaskRepositoryImpl implements TaskRepository {
  TaskRepositoryImpl({
    required TaskQueueFixtureDataSource fixtureDataSource,
  }) : _fixtureDataSource = fixtureDataSource;

  final TaskQueueFixtureDataSource _fixtureDataSource;

  @override
  Future<List<TaskItemEntity>> getTaskQueue() async {
    final items = await _fixtureDataSource.getTaskQueue();
    return items.map((item) => item.toEntity()).toList(growable: false);
  }
}
