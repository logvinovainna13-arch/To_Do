import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_list08flu/add/add_page.dart';
import 'package:todo_list08flu/database/todo.dart';
import 'package:todo_list08flu/home/home_cubit.dart';
import 'package:todo_list08flu/home/home_state.dart';
import 'package:todo_list08flu/home/task_details_page.dart';
import 'package:todo_list08flu/setting_page.dart';
import 'package:todo_list08flu/task_details_page.dart'; // Импортируем экран деталей

class MyHomePage extends StatefulWidget {
  final bool isDarkTheme;
  final Function(bool) onThemeChanged;

  const MyHomePage({
    super.key, 
    required this.isDarkTheme, 
    required this.onThemeChanged,
  });

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  
  @override
  void initState() {
    super.initState();
    print("MyHomePage initState");
    
    context.read<HomeCubit>().loadTodos();
  }

  @override
  Widget build(BuildContext context) {
    print("MyHomePage build");
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Мои задачи"),
        actions: [
          IconButton(
            onPressed: _onSettingsTap, 
            icon: const Icon(Icons.settings),
          )
        ],
      ),
      body: BlocBuilder<HomeCubit, HomeState>(
        builder: (context, state) {
          if (state.status == TodoStatus.isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state.status == TodoStatus.empty) {
            return const Center(
              child: Text("У вас еще нет задач! Добавьте первую задачу."),
            );
          } else if (state.status == TodoStatus.error) {
            return const Center(
              child: Text("Произошла ошибка при загрузке задач."),
            );
          } else {
            return ListView.builder(
              itemCount: state.todoList.length,
              itemBuilder: (context, index) {
                final todo = state.todoList[index];
                
                return ListTile(
                  title: Text(todo.title),
                  subtitle: Text(todo.createdAt),
                  onTap: () async {
                    final result = await Navigator.of(context).push<bool>(
                      TaskDetailsPage.route(todo),
                    );
                    
                    if (result == true && mounted) {
                      context.read<HomeCubit>().loadTodos();
                    }
                  },
                  
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      context.read<HomeCubit>().deleteTodo(todo.id);
                    },
                  ),
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: onAddTap,
        tooltip: 'Добавить задачу',
        child: const Icon(Icons.add),
      ),
    );
  }

  void onAddTap() async {
    final result = await Navigator.of(context).push<bool>(AddPage.route());
    
    if (result == true && mounted) {
      context.read<HomeCubit>().loadTodos();
    }
  }

  void _onSettingsTap() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => SettingsPage(
          isDarkTheme: widget.isDarkTheme, 
          onThemeChanged: widget.onThemeChanged,
        ),
      ),
    );
  }
  
  @override
  void dispose() {
    print("MyHomePage dispose");
    super.dispose();
  }
}
