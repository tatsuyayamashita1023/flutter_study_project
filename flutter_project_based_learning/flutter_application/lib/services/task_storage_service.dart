import 'dart:convert';
import 'dart:io';

import 'package:flutter_application/models/task.dart';
import 'package:flutter_application/models/task_category.dart';
import 'package:path_provider/path_provider.dart';

class TaskStorageService {
  static const String _tasksFileName = 'tasks.json';
  static const String _categoriesFileName = 'task_categories.json';

  Future<File> _getFile(String fileName) async {
    final directory = await getApplicationDocumentsDirectory();
    return File('${directory.path}/$fileName');
  }

  Future<List<Task>> loadTasks() async {
    try {
      final file = await _getFile(_tasksFileName);
      if (!await file.exists()) return [];
      final content = await file.readAsString();
      final List<dynamic> jsonList = jsonDecode(content) as List<dynamic>;
      return jsonList
          .map((e) => Task.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return [];
    }
  }

  Future<void> saveTasks(List<Task> tasks) async {
    final file = await _getFile(_tasksFileName);
    await file.writeAsString(
      jsonEncode(tasks.map((e) => e.toJson()).toList()),
    );
  }

  Future<List<TaskCategory>> loadCategories() async {
    try {
      final file = await _getFile(_categoriesFileName);
      if (!await file.exists()) return _defaultCategories();
      final content = await file.readAsString();
      final List<dynamic> jsonList = jsonDecode(content) as List<dynamic>;
      final categories = jsonList
          .map((e) => TaskCategory.fromJson(e as Map<String, dynamic>))
          .toList();
      return categories.isEmpty ? _defaultCategories() : categories;
    } catch (_) {
      return _defaultCategories();
    }
  }

  Future<void> saveCategories(List<TaskCategory> categories) async {
    final file = await _getFile(_categoriesFileName);
    await file.writeAsString(
      jsonEncode(categories.map((e) => e.toJson()).toList()),
    );
  }

  List<TaskCategory> _defaultCategories() => [
        const TaskCategory(id: 'work', name: '仕事', colorValue: 0xFF2196F3),
        const TaskCategory(
            id: 'private', name: 'プライベート', colorValue: 0xFF4CAF50),
        const TaskCategory(id: 'shopping', name: '買い物', colorValue: 0xFFFF9800),
      ];
}
