class TaskItem {
  const TaskItem({
    required this.id,
    required this.title,
    required this.estimatedPomodoros,
    required this.completedPomodoros,
    required this.isCompleted,
    required this.createdAt,
    required this.isActive,
  });

  final String id;
  final String title;
  final int estimatedPomodoros;
  final int completedPomodoros;
  final bool isCompleted;
  final DateTime createdAt;
  final bool isActive;

  TaskItem copyWith({
    String? id,
    String? title,
    int? estimatedPomodoros,
    int? completedPomodoros,
    bool? isCompleted,
    DateTime? createdAt,
    bool? isActive,
  }) {
    return TaskItem(
      id: id ?? this.id,
      title: title ?? this.title,
      estimatedPomodoros: estimatedPomodoros ?? this.estimatedPomodoros,
      completedPomodoros: completedPomodoros ?? this.completedPomodoros,
      isCompleted: isCompleted ?? this.isCompleted,
      createdAt: createdAt ?? this.createdAt,
      isActive: isActive ?? this.isActive,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'estimatedPomodoros': estimatedPomodoros,
      'completedPomodoros': completedPomodoros,
      'isCompleted': isCompleted,
      'createdAt': createdAt.toIso8601String(),
      'isActive': isActive,
    };
  }

  factory TaskItem.fromJson(Map<String, dynamic> json) {
    return TaskItem(
      id: json['id'] as String,
      title: json['title'] as String? ?? '',
      estimatedPomodoros: json['estimatedPomodoros'] as int? ?? 1,
      completedPomodoros: json['completedPomodoros'] as int? ?? 0,
      isCompleted: json['isCompleted'] as bool? ?? false,
      createdAt: DateTime.tryParse(json['createdAt'] as String? ?? '') ??
          DateTime.fromMillisecondsSinceEpoch(0),
      isActive: json['isActive'] as bool? ?? false,
    );
  }
}
