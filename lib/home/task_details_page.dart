import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_list08flu/database/todo.dart';
import 'package:todo_list08flu/main.dart';
import 'details_cubit.dart';
import 'details_state.dart';

class TaskDetailsPage extends StatefulWidget {
  final Todo todo;

  const TaskDetailsPage({super.key, required this.todo});

  static Route<bool> route(Todo todo) {
    return MaterialPageRoute(
      builder: (_) => BlocProvider(
        create: (_) => DetailsCubit(repo: appRepository),
        child: TaskDetailsPage(todo: todo),
      ),
    );
  }

  @override
  State<TaskDetailsPage> createState() => _TaskDetailsPageState();
}

class _TaskDetailsPageState extends State<TaskDetailsPage> {
  late final TextEditingController _textController;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController(text: widget.todo.title);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Детали задачи"),
      ),
      body: BlocConsumer<DetailsCubit, DetailsState>(
        listener: (context, state) {
          if (state.status == DetailsStatus.success) {
            Navigator.of(context).pop(true);
          }
          if (state.status == DetailsStatus.error && state.errorMessage != null) {
            _showErrorSnackBar(context, state.errorMessage!);
          }
        },
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextField(
                  controller: _textController,
                  enabled: state.status != DetailsStatus.loading,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Название задачи",
                  ),
                ),
                const SizedBox(height: 20),
                state.status == DetailsStatus.loading
                    ? const CircularProgressIndicator()
                    : ElevatedButton(
                        onPressed: () {
                          context.read<DetailsCubit>().updateTodo(
                                widget.todo,
                                _textController.text,
                              );
                        },
                        child: const Text("Сохранить изменения"),
                      ),
              ],
            ),
          );
        },
      ),
    );
  }
  void _showErrorSnackBar(BuildContext context, String text) {
    final messenger = ScaffoldMessenger.of(context);
    messenger.hideCurrentSnackBar();
    messenger.showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                text,
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.fromLTRB(12, 12, 12, 20),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }
}
