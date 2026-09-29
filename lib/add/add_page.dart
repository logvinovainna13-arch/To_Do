import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_list08flu/add/add_cubit.dart';
import 'package:todo_list08flu/add/add_state.dart';
import 'package:todo_list08flu/main.dart';

class AddPage extends StatefulWidget {
  const AddPage({super.key});
  static Route<bool> route() {
    return MaterialPageRoute(
      builder: (_) => BlocProvider(
        create: (_) => AddCubit(repo: appRepository),
        child: const AddPage(),
      ),
    );
  }

  @override
  State<AddPage> createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
  final TextEditingController _textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Добавить задачу"),
      ),
      body: BlocConsumer<AddCubit, AddState>(
        listener: (context, state) {
          if (state.status == AddStatus.success) {
            Navigator.of(context).pop(true);
          }
          if (state.status == AddStatus.error && state.errorMessage != null) {
            showAppSnackBar(context, text: state.errorMessage!, backgroundColor: Colors.red, icon: Icons.error);
          }
        },
        builder: (context, state) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextField(
                    controller: _textEditingController,
                    enabled: state.status != AddStatus.loading,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Введите название задачи",
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Динамически меняем кнопку на индикатор загрузки
                  state.status == AddStatus.loading
                      ? const CircularProgressIndicator()
                      : ElevatedButton(
                          onPressed: () {
                            context.read<AddCubit>().saveTodo(_textEditingController.text);
                          },
                          child: const Text("Сохранить"),
                        ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void showAppSnackBar(
    BuildContext context, {
    required String text,
    Color? backgroundColor,
    IconData? icon,
  }) {
    final messenger = ScaffoldMessenger.of(context);
    messenger.hideCurrentSnackBar();
    messenger.showSnackBar(
      SnackBar(
        content: Row(
          children: [
            if (icon != null) ...[
              Icon(icon, color: Colors.white),
              const SizedBox(width: 12),
            ],
            Expanded(child: Text(text, style: const TextStyle(color: Colors.white))),
          ],
        ),
        backgroundColor: backgroundColor,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.fromLTRB(12, 12, 12, 20),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }
}
