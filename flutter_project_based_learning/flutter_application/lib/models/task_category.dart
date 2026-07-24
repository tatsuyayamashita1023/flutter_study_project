import 'package:freezed_annotation/freezed_annotation.dart';

part 'task_category.freezed.dart';
part 'task_category.g.dart';

@freezed
class TaskCategory with _$TaskCategory {
  const factory TaskCategory({
    required String id,
    required String name,
    required int colorValue,
  }) = _TaskCategory;

  factory TaskCategory.fromJson(Map<String, dynamic> json) =>
      _$TaskCategoryFromJson(json);
}
