import 'package:flutter/foundation.dart';

import '../domain/task_item.dart';
import '../domain/task_repository.dart';

class TasksViewModel extends ChangeNotifier {
  TasksViewModel(this._repository);

  final TaskRepository _repository;

  List<TaskItem> _tasks = const [];
  bool _isLoaded = false;

  List<TaskItem> get tasks => _tasks;
  bool get isLoaded => _isLoaded;
  TaskItem? get activeTask {
    for (final task in _tasks) {
      if (task.isActive) {
        return task;
      }
    }
    return null;
  }

  Future<void> load() async {
    _tasks = await _repository.load();
    _isLoaded = true;
    notifyListeners();
  }

  Future<void> addTask({
    required String title,
    required int estimatedPomodoros,
  }) async {
    final trimmedTitle = title.trim();
    if (trimmedTitle.isEmpty) {
      return;
    }

    final shouldActivate = activeTask == null;
    final newTask = TaskItem(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      title: trimmedTitle,
      estimatedPomodoros: estimatedPomodoros,
      completedPomodoros: 0,
      isCompleted: false,
      createdAt: DateTime.now(),
      isActive: shouldActivate,
    );

    _tasks = [..._tasks, newTask];
    await _persist();
  }

  Future<void> removeTask(String taskId) async {
    _tasks = _tasks.where((task) => task.id != taskId).toList();
    _ensureActiveTask();
    await _persist();
  }

  Future<void> toggleCompleted(String taskId) async {
    _tasks = _tasks.map((task) {
      if (task.id != taskId) {
        return task;
      }

      final nextCompleted = !task.isCompleted;
      return task.copyWith(
        isCompleted: nextCompleted,
        isActive: nextCompleted ? false : task.isActive,
      );
    }).toList();

    _ensureActiveTask();
    await _persist();
  }

  Future<void> setActiveTask(String taskId) async {
    _tasks = _tasks.map((task) {
      if (task.isCompleted) {
        return task.copyWith(isActive: false);
      }
      return task.copyWith(isActive: task.id == taskId);
    }).toList();
    await _persist();
  }

  Future<void> recordCompletedPomodoroForActiveTask() async {
    final currentTask = activeTask;
    if (currentTask == null) {
      return;
    }

    _tasks = _tasks.map((task) {
      if (task.id != currentTask.id) {
        return task;
      }
      final nextCompleted = task.completedPomodoros + 1;
      final isDone = nextCompleted >= task.estimatedPomodoros;
      return task.copyWith(
        completedPomodoros: nextCompleted,
        isCompleted: isDone,
        isActive: !isDone,
      );
    }).toList();

    _ensureActiveTask();
    await _persist();
  }

  void _ensureActiveTask() {
    if (activeTask != null) {
      return;
    }

    final nextAvailable = _tasks.where((task) => !task.isCompleted).toList();
    if (nextAvailable.isEmpty) {
      return;
    }

    final nextTaskId = nextAvailable.first.id;
    _tasks = _tasks
        .map((task) => task.copyWith(isActive: task.id == nextTaskId))
        .toList();
  }

  Future<void> _persist() async {
    notifyListeners();
    await _repository.save(_tasks);
  }
}
