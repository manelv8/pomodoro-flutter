import 'task_item.dart';

abstract class TaskRepository {
  Future<List<TaskItem>> load();

  Future<void> save(List<TaskItem> tasks);
}
