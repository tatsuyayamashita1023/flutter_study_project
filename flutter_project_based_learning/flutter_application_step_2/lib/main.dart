import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ToDo List App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const TodoListPage(),
    );
  }
}

class TodoListPage extends StatefulWidget {
  const TodoListPage({super.key});

  @override
  State<TodoListPage> createState() => _TodoListPageState();
}

class _TodoListPageState extends State<TodoListPage> {
  final List<String> _todos = [];

  void _showTodoDialog({int? editIndex}) {
    final TextEditingController controller = TextEditingController(
      text: editIndex != null ? _todos[editIndex] : '',
    );
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();

    showDialog<void>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Text(editIndex != null ? 'ToDoを編集' : 'ToDoを追加'),
        content: Form(
          key: formKey,
          child: TextFormField(
            controller: controller,
            decoration: const InputDecoration(labelText: 'タイトル'),
            autofocus: true,
            validator: (String? value) {
              if (value == null || value.trim().isEmpty) {
                return 'タイトルを入力してください';
              }
              final String trimmed = value.trim();
              final bool isDuplicate = _todos.asMap().entries.any(
                (MapEntry<int, String> entry) =>
                    entry.key != editIndex && entry.value == trimmed,
              );
              if (isDuplicate) {
                return '同じタイトルはすでに存在します';
              }
              return null;
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('キャンセル'),
          ),
          TextButton(
            onPressed: () {
              if (formKey.currentState!.validate()) {
                final String title = controller.text.trim();
                setState(() {
                  if (editIndex != null) {
                    _todos[editIndex] = title;
                  } else {
                    _todos.add(title);
                  }
                });
                Navigator.of(context).pop();
              }
            },
            child: Text(editIndex != null ? '更新' : '追加'),
          ),
        ],
      ),
    );
  }

  void _deleteTodo(int index) {
    setState(() {
      _todos.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ToDo リスト'),
      ),
      body: _todos.isEmpty
          ? const Center(child: Text('ToDoがありません'))
          : ListView.builder(
              itemCount: _todos.length,
              itemBuilder: (BuildContext context, int index) => ListTile(
                title: Text(_todos[index]),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () => _showTodoDialog(editIndex: index),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () => _deleteTodo(index),
                    ),
                  ],
                ),
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showTodoDialog,
        child: const Icon(Icons.add),
      ),
    );
  }
}
