import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../domain/task_item.dart';
import '../../viewmodels/tasks_view_model.dart';

class TasksSection extends StatefulWidget {
  const TasksSection({super.key});

  @override
  State<TasksSection> createState() => _TasksSectionState();
}

class _TasksSectionState extends State<TasksSection> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _estimateController =
      TextEditingController(text: '1');
  bool _isComposerOpen = false;

  @override
  void dispose() {
    _titleController.dispose();
    _estimateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TasksViewModel>(
      builder: (context, tasksViewModel, _) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Text(
                  'Tasks',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                ),
                const Spacer(),
                IconButton(
                  key: const Key('toggle-task-composer'),
                  onPressed: () {
                    setState(() {
                      _isComposerOpen = !_isComposerOpen;
                    });
                  },
                  style: IconButton.styleFrom(
                    backgroundColor: Colors.white.withValues(alpha: 0.18),
                    foregroundColor: Colors.white,
                  ),
                  icon: Icon(_isComposerOpen ? Icons.close : Icons.add),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Container(height: 2, color: Colors.white.withValues(alpha: 0.5)),
            const SizedBox(height: 20),
            if (_isComposerOpen)
              _TaskComposer(
                titleController: _titleController,
                estimateController: _estimateController,
                onAdd: () => _handleAddTask(tasksViewModel),
              ),
            if (_isComposerOpen) const SizedBox(height: 18),
            if (tasksViewModel.tasks.isEmpty)
              _EmptyTasksState(
                onAddPressed: () {
                  setState(() {
                    _isComposerOpen = true;
                  });
                },
              )
            else
              ...tasksViewModel.tasks.map(
                (task) => Padding(
                  padding: const EdgeInsets.only(bottom: 14),
                  child: _TaskTile(task: task),
                ),
              ),
          ],
        );
      },
    );
  }

  Future<void> _handleAddTask(TasksViewModel tasksViewModel) async {
    final estimate = int.tryParse(_estimateController.text) ?? 1;
    await tasksViewModel.addTask(
      title: _titleController.text,
      estimatedPomodoros: estimate.clamp(1, 12),
    );

    if (!mounted) {
      return;
    }

    _titleController.clear();
    _estimateController.text = '1';
    setState(() {
      _isComposerOpen = false;
    });
  }
}

class _TaskComposer extends StatelessWidget {
  const _TaskComposer({
    required this.titleController,
    required this.estimateController,
    required this.onAdd,
  });

  final TextEditingController titleController;
  final TextEditingController estimateController;
  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.96),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: titleController,
              style: const TextStyle(color: Color(0xFF2A2624)),
              decoration: const InputDecoration(
                hintText: 'What are you working on?',
              ),
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                const Expanded(
                  child: Text(
                    'Estimated Pomodoros',
                    style: TextStyle(
                      color: Color(0xFF5B5550),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                SizedBox(
                  width: 80,
                  child: TextField(
                    controller: estimateController,
                    keyboardType: TextInputType.number,
                    style: const TextStyle(color: Color(0xFF2A2624)),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),
            Align(
              alignment: Alignment.centerRight,
              child: FilledButton(
                onPressed: onAdd,
                style: FilledButton.styleFrom(
                  backgroundColor: const Color(0xFF22201F),
                  foregroundColor: Colors.white,
                ),
                child: const Text('Save Task'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TaskTile extends StatelessWidget {
  const _TaskTile({
    required this.task,
  });

  final TaskItem task;

  @override
  Widget build(BuildContext context) {
    return Consumer<TasksViewModel>(
      builder: (context, tasksViewModel, _) {
        final cardColor =
            task.isActive ? Colors.white : Colors.white.withValues(alpha: 0.94);

        return InkWell(
          onTap: task.isCompleted
              ? null
              : () => tasksViewModel.setActiveTask(task.id),
          borderRadius: BorderRadius.circular(16),
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: cardColor,
              borderRadius: BorderRadius.circular(16),
              border: task.isActive
                  ? const Border(
                      left: BorderSide(
                        color: Color(0xFF2A2624),
                        width: 6,
                      ),
                    )
                  : null,
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => tasksViewModel.toggleCompleted(task.id),
                    icon: Icon(
                      task.isCompleted
                          ? Icons.check_circle
                          : Icons.radio_button_unchecked,
                      color: task.isCompleted
                          ? const Color(0xFF8BC34A)
                          : const Color(0xFFC7C0BC),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      task.title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: const Color(0xFF2A2624),
                            decoration: task.isCompleted
                                ? TextDecoration.lineThrough
                                : TextDecoration.none,
                            fontWeight:
                                task.isActive ? FontWeight.w700 : FontWeight.w600,
                          ),
                    ),
                  ),
                  Text(
                    '${task.completedPomodoros}/${task.estimatedPomodoros}',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: const Color(0xFF928883),
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                  IconButton(
                    onPressed: () => tasksViewModel.removeTask(task.id),
                    icon: const Icon(Icons.more_vert, color: Color(0xFF928883)),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _EmptyTasksState extends StatelessWidget {
  const _EmptyTasksState({
    required this.onAddPressed,
  });

  final VoidCallback onAddPressed;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.5)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Text(
              'No tasks yet',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Colors.white,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              'Add your first task to track estimated and completed pomodoros.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Colors.white70,
                  ),
            ),
            const SizedBox(height: 18),
            OutlinedButton(
              onPressed: onAddPressed,
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.white,
                side: BorderSide(color: Colors.white.withValues(alpha: 0.5)),
              ),
              child: const Text('Add Task'),
            ),
          ],
        ),
      ),
    );
  }
}
