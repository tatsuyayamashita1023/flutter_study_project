import 'package:flutter/material.dart';
import 'package:flutter_application/models/task.dart';
import 'package:flutter_application/providers/task_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TaskFormPage extends ConsumerStatefulWidget {
  const TaskFormPage({super.key, this.task});

  final Task? task;

  @override
  ConsumerState<TaskFormPage> createState() => _TaskFormPageState();
}

class _TaskFormPageState extends ConsumerState<TaskFormPage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;
  String _categoryId = '';
  late TaskPriority _priority;
  late TaskStatus _status;
  DateTime? _deadline;

  @override
  void initState() {
    super.initState();
    _titleController =
        TextEditingController(text: widget.task?.title ?? '');
    _descriptionController =
        TextEditingController(text: widget.task?.description ?? '');
    _priority = widget.task?.priority ?? TaskPriority.medium;
    _status = widget.task?.status ?? TaskStatus.pending;
    _deadline = widget.task?.deadline;
    _categoryId = widget.task?.categoryId ?? '';

    if (_categoryId.isEmpty) {
      final categories =
          ref.read(taskCategoriesProvider).valueOrNull ?? [];
      if (categories.isNotEmpty) {
        _categoryId = categories.first.id;
      }
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    final now = DateTime.now();
    final title = _titleController.text.trim();
    final description = _descriptionController.text.trim();

    final task = widget.task != null
        ? widget.task!.copyWith(
            title: title,
            description: description.isEmpty ? null : description,
            categoryId: _categoryId,
            priority: _priority,
            status: _status,
            deadline: _deadline,
            updatedAt: now,
          )
        : Task(
            id: now.millisecondsSinceEpoch.toString(),
            title: title,
            description: description.isEmpty ? null : description,
            categoryId: _categoryId,
            priority: _priority,
            status: _status,
            deadline: _deadline,
            createdAt: now,
            updatedAt: now,
          );

    try {
      if (widget.task != null) {
        await ref.read(tasksProvider.notifier).updateTask(task);
      } else {
        await ref.read(tasksProvider.notifier).addTask(task);
      }
      if (mounted) Navigator.pop(context);
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('保存に失敗しました。再度お試しください。')),
        );
      }
    }
  }

  Future<void> _pickDeadline() async {
    final picked = await showDatePicker(
      context: context,
      initialDate:
          _deadline ?? DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      setState(() => _deadline = picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    final categoriesAsync = ref.watch(taskCategoriesProvider);
    final categories = categoriesAsync.valueOrNull ?? [];

    if (_categoryId.isEmpty && categories.isNotEmpty) {
      _categoryId = categories.first.id;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.task != null ? 'タスク編集' : 'タスク追加'),
        actions: [
          TextButton(
            onPressed: _save,
            child: const Text('保存'),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'タイトル',
                border: OutlineInputBorder(),
              ),
              validator: (value) =>
                  (value == null || value.trim().isEmpty)
                      ? 'タイトルを入力してください'
                      : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: '説明（任意）',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            if (categories.isNotEmpty) ...[
              DropdownButtonFormField<String>(
                value: categories.any((c) => c.id == _categoryId)
                    ? _categoryId
                    : categories.first.id,
                decoration: const InputDecoration(
                  labelText: 'カテゴリ',
                  border: OutlineInputBorder(),
                ),
                items: categories
                    .map(
                      (cat) => DropdownMenuItem(
                        value: cat.id,
                        child: Text(cat.name),
                      ),
                    )
                    .toList(),
                onChanged: (value) =>
                    setState(() => _categoryId = value!),
              ),
              const SizedBox(height: 16),
            ],
            const Text(
              '優先度',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
            const SizedBox(height: 4),
            SegmentedButton<TaskPriority>(
              segments: const [
                ButtonSegment(value: TaskPriority.low, label: Text('低')),
                ButtonSegment(
                    value: TaskPriority.medium, label: Text('中')),
                ButtonSegment(value: TaskPriority.high, label: Text('高')),
              ],
              selected: {_priority},
              onSelectionChanged: (selection) =>
                  setState(() => _priority = selection.first),
            ),
            const SizedBox(height: 16),
            const Text(
              'ステータス',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
            const SizedBox(height: 4),
            SegmentedButton<TaskStatus>(
              segments: const [
                ButtonSegment(
                    value: TaskStatus.pending, label: Text('未着手')),
                ButtonSegment(
                    value: TaskStatus.inProgress, label: Text('進行中')),
                ButtonSegment(
                    value: TaskStatus.blocked, label: Text('ブロック')),
                ButtonSegment(
                    value: TaskStatus.completed, label: Text('完了')),
              ],
              selected: {_status},
              onSelectionChanged: (selection) =>
                  setState(() => _status = selection.first),
            ),
            const SizedBox(height: 16),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('期限'),
              subtitle: _deadline != null
                  ? Text(_deadline!.toString().substring(0, 10))
                  : const Text(
                      '未設定',
                      style: TextStyle(color: Colors.grey),
                    ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (_deadline != null)
                    IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () => setState(() => _deadline = null),
                    ),
                  IconButton(
                    icon: const Icon(Icons.calendar_today),
                    onPressed: _pickDeadline,
                  ),
                ],
              ),
            ),
            if (widget.task != null) ...[
              const SizedBox(height: 16),
              OutlinedButton.icon(
                icon: const Icon(Icons.delete, color: Colors.red),
                label: const Text(
                  'タスクを削除',
                  style: TextStyle(color: Colors.red),
                ),
                onPressed: () async {
                  final navigator = Navigator.of(context);
                  final confirmed = await showDialog<bool>(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: const Text('削除の確認'),
                      content: const Text('このタスクを削除しますか？'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(ctx, false),
                          child: const Text('キャンセル'),
                        ),
                        TextButton(
                          onPressed: () => Navigator.pop(ctx, true),
                          child: const Text(
                            '削除',
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                      ],
                    ),
                  );
                  if (confirmed == true && mounted) {
                    await ref
                        .read(tasksProvider.notifier)
                        .deleteTask(widget.task!.id);
                    if (mounted) navigator.pop();
                  }
                },
              ),
            ],
          ],
        ),
      ),
    );
  }
}
