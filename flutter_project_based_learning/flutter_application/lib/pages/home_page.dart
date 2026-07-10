import 'package:flutter/material.dart';
import 'package:flutter_application/pages/counter_page.dart';
import 'package:flutter_application/pages/todo_list_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter 学習アプリ'),
      ),
      body: ListView(
        children: [
          ListTile(
            title: const Text('課題1：カウンターアプリ'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const CounterPage()),
              );
            },
          ),
          const Divider(),
          ListTile(
            title: const Text('課題2：ToDoリスト'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const TodoListPage()),
              );
            },
          ),
          const Divider(),
        ],
      ),
    );
  }
}
