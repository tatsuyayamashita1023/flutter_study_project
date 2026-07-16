import 'package:flutter_application/models/task.dart';
import 'package:flutter_application/models/task_category.dart';
import 'package:flutter_application/services/notification_service.dart';
import 'package:flutter_application/services/task_storage_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'task_provider.g.dart';

@riverpod
class SelectedCategoryId extends _$SelectedCategoryId {
  @override
  String? build() => null;

  void select(String? categoryId) => state = categoryId;
}

@riverpod
class TaskCategories extends _$TaskCategories {
  @override
  Future<List<TaskCategory>> build() async {
    return TaskStorageService().loadCategories();
  }

  Future<void> addCategory(String name, int colorValue) async {
    final current = await future;
    final newCategory = TaskCategory(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      colorValue: colorValue,
    );
    final updated = [...current, newCategory];
    state = AsyncData(updated);
    await TaskStorageService().saveCategories(updated);
  }

  Future<void> deleteCategory(String id) async {
    final current = await future;
    final updated = current.where((c) => c.id != id).toList();
    state = AsyncData(updated);
    await TaskStorageService().saveCategories(updated);
  }
}

@riverpod
class Tasks extends _$Tasks {
  @override
  Future<List<Task>> build() async {
    return TaskStorageService().loadTasks();
  }

  Future<void> addTask(Task task) async {
    final current = await future;
    final updated = [...current, task];
    state = AsyncData(updated);
    await TaskStorageService().saveTasks(updated);
    try {
      await NotificationService.instance.scheduleTaskNotification(task);
    } catch (_) {
      // 通知スケジューリングの失敗はタスク保存の完了に影響させない
    }
  }

  Future<void> updateTask(Task task) async {
    final current = await future;
    final updated = current.map((t) => t.id == task.id ? task : t).toList();
    state = AsyncData(updated);
    await TaskStorageService().saveTasks(updated);
    try {
      await NotificationService.instance.cancelNotification(task.id);
      await NotificationService.instance.scheduleTaskNotification(task);
    } catch (_) {
      // 通知スケジューリングの失敗はタスク保存の完了に影響させない
    }
  }

  Future<void> deleteTask(String id) async {
    final current = await future;
    final updated = current.where((t) => t.id != id).toList();
    state = AsyncData(updated);
    await TaskStorageService().saveTasks(updated);
    await NotificationService.instance.cancelNotification(id);
  }

  Future<void> updateStatus(String id, TaskStatus newStatus) async {
    final current = await future;
    final task = current.firstWhere((t) => t.id == id);
    await updateTask(task.copyWith(status: newStatus, updatedAt: DateTime.now()));
  }
}

@riverpod
List<Task> filteredTasks(FilteredTasksRef ref) {
  final tasksAsync = ref.watch(tasksProvider);
  final selectedCategoryId = ref.watch(selectedCategoryIdProvider);
  final tasks = tasksAsync.valueOrNull ?? [];

  if (selectedCategoryId == null) return tasks;
  return tasks.where((t) => t.categoryId == selectedCategoryId).toList();
}
