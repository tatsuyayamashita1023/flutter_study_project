import 'package:flutter/material.dart';
import 'package:flutter_application/models/task.dart';
import 'package:flutter_application/models/task_category.dart';
import 'package:flutter_application/pages/task_form_page.dart';
import 'package:flutter_application/providers/task_provider.dart';
import 'package:flutter_application/services/notification_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TaskListPage extends ConsumerStatefulWidget {
  const TaskListPage({super.key});

  @override
  ConsumerState<TaskListPage> createState() => _TaskListPageState();
}

class _TaskListPageState extends ConsumerState<TaskListPage>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    NotificationService.instance.requestPermissions();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filteredTasks = ref.watch(filteredTasksProvider);
    final categoriesAsync = ref.watch(taskCategoriesProvider);
    final selectedCategoryId = ref.watch(selectedCategoryIdProvider);
    final categories = categoriesAsync.valueOrNull ?? [];

    final pendingTasks =
        filteredTasks.where((t) => t.status != TaskStatus.completed).toList();
    final completedTasks =
        filteredTasks.where((t) => t.status == TaskStatus.completed).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('タスク管理'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: '全タスク'),
            Tab(text: '未完了'),
            Tab(text: '完了'),
          ],
        ),
      ),
      body: Column(
        children: [
          SizedBox(
            height: 48,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: const Text('すべて'),
                    selected: selectedCategoryId == null,
                    onSelected: (_) => ref
                        .read(selectedCategoryIdProvider.notifier)
                        .select(null),
                  ),
                ),
                ...categories.map(
                  (cat) => Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text(cat.name),
                      selected: selectedCategoryId == cat.id,
                      selectedColor:
                          Color(cat.colorValue).withValues(alpha: 0.3),
                      onSelected: (_) => ref
                          .read(selectedCategoryIdProvider.notifier)
                          .select(cat.id),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildTaskList(filteredTasks, categories),
                _buildTaskList(pendingTasks, categories),
                _buildTaskList(completedTasks, categories),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push<void>(
          context,
          MaterialPageRoute<void>(
            builder: (_) => const TaskFormPage(),
          ),
        ),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildTaskList(List<Task> tasks, List<TaskCategory> categories) {
    if (tasks.isEmpty) {
      return const Center(child: Text('タスクはありません'));
    }
    return ListView.builder(
      itemCount: tasks.length,
      itemBuilder: (context, index) =>
          _buildTaskTile(tasks[index], categories),
    );
  }

  Widget _buildTaskTile(Task task, List<TaskCategory> categories) {
    final category =
        categories.where((c) => c.id == task.categoryId).firstOrNull;
    final isCompleted = task.status == TaskStatus.completed;

    return Dismissible(
      key: Key(task.id),
      direction: DismissDirection.endToStart,
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 16),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      onDismissed: (_) =>
          ref.read(tasksProvider.notifier).deleteTask(task.id),
      child: ListTile(
        leading: _buildStatusSelector(task),
        title: Text(
          task.title,
          style: TextStyle(
            decoration: isCompleted ? TextDecoration.lineThrough : null,
            color: isCompleted ? Colors.grey : null,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (task.deadline != null)
              Text(
                '期限: ${task.deadline!.toLocal().toString().substring(0, 10)}',
                style: TextStyle(
                  fontSize: 12,
                  color: _deadlineColor(task.deadline!),
                ),
              ),
            if (category != null)
              Row(
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: Color(category.colorValue),
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    category.name,
                    style:
                        const TextStyle(fontSize: 11, color: Colors.grey),
                  ),
                ],
              ),
          ],
        ),
        trailing: _buildPriorityBadge(task.priority),
        onTap: () => Navigator.push<void>(
          context,
          MaterialPageRoute<void>(
            builder: (_) => TaskFormPage(task: task),
          ),
        ),
      ),
    );
  }

  Widget _buildStatusSelector(Task task) {
    final (IconData icon, Color color) = switch (task.status) {
      TaskStatus.pending => (Icons.radio_button_unchecked, Colors.grey),
      TaskStatus.inProgress => (Icons.timelapse, Colors.blue),
      TaskStatus.blocked => (Icons.warning_amber_rounded, Colors.orange),
      TaskStatus.completed => (Icons.check_circle, Colors.green),
    };

    const statuses = [
      (TaskStatus.pending, '未着手', Icons.radio_button_unchecked, Colors.grey),
      (TaskStatus.inProgress, '進行中', Icons.timelapse, Colors.blue),
      (TaskStatus.blocked, 'ブロック', Icons.warning_amber_rounded, Colors.orange),
      (TaskStatus.completed, '完了', Icons.check_circle, Colors.green),
    ];

    return PopupMenuButton<TaskStatus>(
      icon: Icon(icon, color: color),
      onSelected: (newStatus) =>
          ref.read(tasksProvider.notifier).updateStatus(task.id, newStatus),
      itemBuilder: (_) => [
        for (final (status, label, icon, color) in statuses)
          PopupMenuItem<TaskStatus>(
            value: status,
            child: Row(
              children: [
                Icon(icon, color: color, size: 18),
                const SizedBox(width: 8),
                Text(label),
              ],
            ),
          ),
      ],
    );
  }

  Color _deadlineColor(DateTime deadline) {
    final diff = deadline.difference(DateTime.now());
    if (diff.isNegative) return Colors.red;
    if (diff.inHours < 24) return Colors.orange;
    return Colors.grey;
  }

  Widget _buildPriorityBadge(TaskPriority priority) {
    final (String label, Color color) = switch (priority) {
      TaskPriority.high => ('高', Colors.red),
      TaskPriority.medium => ('中', Colors.orange),
      TaskPriority.low => ('低', Colors.green),
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: color.withValues(alpha: 0.5)),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          color: color,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
