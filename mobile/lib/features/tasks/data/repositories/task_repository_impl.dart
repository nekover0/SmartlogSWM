import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smartlog_swm_mobile/features/tasks/data/contracts/task_item_contract.dart';
import 'package:smartlog_swm_mobile/features/tasks/data/datasources/task_queue_api_data_source.dart';
import 'package:smartlog_swm_mobile/features/tasks/domain/repositories/task_repository.dart';

final taskRepositoryProvider = Provider<TaskRepository>((Ref<Object?> ref) {
  return TaskRepositoryImpl(
    apiDataSource: ref.watch(taskQueueApiDataSourceProvider),
  );
});

class TaskRepositoryImpl implements TaskRepository {
  TaskRepositoryImpl({required TaskQueueApiDataSource apiDataSource})
    : _apiDataSource = apiDataSource;

  final TaskQueueApiDataSource _apiDataSource;

  @override
  Future<List<TaskItemEntity>> getTaskQueue() async {
    final items = await _apiDataSource.getTaskQueue();
    return items.map((item) => item.toEntity()).toList(growable: false);
  }
}
