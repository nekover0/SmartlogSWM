import 'package:smartlog_swm_mobile/features/tasks/data/contracts/task_item_contract.dart';

abstract interface class TaskRepository {
  Future<List<TaskItemEntity>> getTaskQueue();
}
