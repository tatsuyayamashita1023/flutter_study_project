// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$filteredTasksHash() => r'c7c1d9ce188eaecc8578dd1c8d438f3bd70e64be';

/// See also [filteredTasks].
@ProviderFor(filteredTasks)
final filteredTasksProvider = AutoDisposeProvider<List<Task>>.internal(
  filteredTasks,
  name: r'filteredTasksProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$filteredTasksHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef FilteredTasksRef = AutoDisposeProviderRef<List<Task>>;
String _$selectedCategoryIdHash() =>
    r'01296c143a5559d9e04356cc0381ae84c8ffec3c';

/// See also [SelectedCategoryId].
@ProviderFor(SelectedCategoryId)
final selectedCategoryIdProvider =
    AutoDisposeNotifierProvider<SelectedCategoryId, String?>.internal(
  SelectedCategoryId.new,
  name: r'selectedCategoryIdProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$selectedCategoryIdHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$SelectedCategoryId = AutoDisposeNotifier<String?>;
String _$taskCategoriesHash() => r'880fcce2fb777c35dedbf29245e4df949f25a122';

/// See also [TaskCategories].
@ProviderFor(TaskCategories)
final taskCategoriesProvider = AutoDisposeAsyncNotifierProvider<TaskCategories,
    List<TaskCategory>>.internal(
  TaskCategories.new,
  name: r'taskCategoriesProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$taskCategoriesHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$TaskCategories = AutoDisposeAsyncNotifier<List<TaskCategory>>;
String _$tasksHash() => r'2d5f413b9dae65bcf3e661a528003a482e17010b';

/// See also [Tasks].
@ProviderFor(Tasks)
final tasksProvider =
    AutoDisposeAsyncNotifierProvider<Tasks, List<Task>>.internal(
  Tasks.new,
  name: r'tasksProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$tasksHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$Tasks = AutoDisposeAsyncNotifier<List<Task>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
