import 'package:flutter/material.dart';
import 'package:todo_list/add/addTaskScreen.dart';
import 'package:todo_list/dataBase/toDo.dart';
import 'package:todo_list/home/home_cubit.dart';
import 'package:todo_list/home/home_state.dart';
import 'package:todo_list/home/task_detail_page.dart'; 
import 'package:todo_list/settingPage.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MyHomePage extends StatefulWidget {
  final HomeCubit cubit;

  const MyHomePage({super.key, required this.cubit});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}
class _MyHomePageState extends State<MyHomePage> {
  late HomeCubit _cubit;

  @override
  void initState() {
    super.initState();
    print("MyHomePage initState");
    _cubit = widget.cubit;
    // Инициализируем данные из кубита при старте
    _cubit.getTodoList();
  }

  void _onAddTap() async {
    final result = await Navigator.of(
      context,
    ).push<String>(MaterialPageRoute(builder: (_) => const AddTaskScreen()));
    if (result != null && result.trim().isNotEmpty) {
      _cubit.addTask(result.trim());
      print("Добавлена задача: $result");
    }
  }

  @override
  Widget build(BuildContext context) {
    print("MyHomePage build");
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Мои задачи'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const SettingsPage()),
              );
            },
          ),
        ],
      ),
      body: BlocBuilder<HomeCubit, HomeState>(
        builder: (context, state) {
          if (state.status == TodoStatus.empty) {
            return const Center(
              child: Text('У вас еще нет задач! Добавьте задачу.'),
            );
          } else if (state.status == TodoStatus.isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
            } else {
            return ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: state.todoList.length,
              itemBuilder: (context, index) {
                final todo = state.todoList[index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 6),
                  elevation: 2,
                  child: ListTile(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => TaskDetailPage(todo: todo),
                        ),
                      );
                    },
                    leading: CircleAvatar(
                      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                      child: Text(
                        "${index + 1}",
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onPrimaryContainer,
                        ),
                      ),
                    ),
                    title: Text(
                      todo.title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        decoration: todo.isDone ? TextDecoration.lineThrough : null,
                        color: todo.isDone ? Colors.grey : Colors.black87,
                      ),
                    ),
                     subtitle: Text(
                      todo.createdAt,
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                    trailing: Icon(
                      todo.isDone ? Icons.check_circle : Icons.radio_button_unchecked,
                      color: todo.isDone ? Colors.green : Colors.grey,
                    ),
                  ),
                );
              },
            );
          }
        },
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
