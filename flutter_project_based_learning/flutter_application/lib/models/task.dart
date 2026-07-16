import 'package:freezed_annotation/freezed_annotation.dart';

part 'task.freezed.dart';
part 'task.g.dart';

enum TaskPriority { low, medium, high }

enum TaskStatus { pending, inProgress, blocked, completed }

@freezed
class Task with _$Task {
  const factory Task({
    required String id,
    required String title,
    String? description,
    required String categoryId,
    required TaskPriority priority,
    required TaskStatus status,
    DateTime? deadline,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _Task;

  factory Task.fromJson(Map<String, dynamic> json) => _$TaskFromJson(json);
}
