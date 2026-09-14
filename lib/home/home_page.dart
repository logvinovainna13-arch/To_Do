import 'package:flutter/material.dart';
import 'package:todo_list/add/addTaskScreen.dart';
import 'package:todo_list/settingPage.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<String> _tasks = [];

  @override
  void initState() {
    super.initState();
    print("MyHomePage initState");
  }

  void _onAddTap() async {
    final result = await Navigator.of(
      context,
    ).push<String>(MaterialPageRoute(builder: (_) => const AddTaskScreen()));
    if (result != null && result.trim().isNotEmpty) {
      setState(() {
        _tasks.insert(0, result.trim());
      });
      print("Добавлена задача: $result");
    }
  }

  @override
  Widget build(BuildContext context) {
    print("MyHomePage build");
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.of(
                context,
              ).push(MaterialPageRoute(builder: (_) => const SettingsPage()));
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              "Список актуальных задач:",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            Expanded(
              child: _tasks.isEmpty
                  ? const Center(
                      child: Text(
                        "Нажмите на + чтобы добавить задачу.",
                        style: TextStyle(color: Colors.grey, fontSize: 15),
                      ),
                    )
                  : ListView.builder(
                      itemCount: _tasks.length,
                      itemBuilder: (context, index) {
                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 6),
                          elevation: 2,
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: Theme.of(
                                context,
                              ).colorScheme.primaryContainer,
                              child: Text(
                                "${index + 1}",
                                style: TextStyle(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onPrimaryContainer,
                                ),
                              ),
                            ),
                            title: Text(
                              _tasks[index],
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            trailing: const Icon(
                              Icons.check_circle_outline,
                              color: Colors.green,
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _onAddTap,
        tooltip: 'Добавить задачу',
        child: const Icon(Icons.add),
      ),
    );
  }

  @override
  void dispose() {
    print("MyHomePage dispose");
    super.dispose();
  }
}
