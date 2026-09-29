import 'package:flutter/material.dart';
import 'package:todo_list08flu/database/todo.dart';
import 'dart:async';

import 'package:todo_list08flu/main.dart';

class AddPage extends StatefulWidget {
  const AddPage({super.key});

  @override
  //Выделяет память для виджета с состоянием
  State<AddPage> createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
TextEditingController _textEditingController = TextEditingController();

//занимает память, то есть в этот момент виджет появляется в оперативной памяти
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //готовим данные, подгружаем данные с локального хранилища, с сервера посредстовм интернета
    //инициализируем свойства
    //запускать анимации, либо таймеры
    print("AddPage initState");
  }

//рисует интерфейс
  @override
  Widget build(BuildContext context) {
    print("AddPage build");
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text("Добавить задачу"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: .center,
          children: [
            TextField(
              controller: _textEditingController,
              decoration: InputDecoration(
                border: OutlineInputBorder(), 
              label: Text("Введите название задачи")
              )
              ),
              TextButton(onPressed: onSaveTap, child: Text("Сохранить"))
          ],
        ),
      ),
    );
  }

  void onSaveTap() {
    final title = _textEditingController.text;
    try {
      saveToDatabase(title);
    } catch (e) {
      showAppSnackBar(context, text: e.toString(), backgroundColor: Colors.red, icon: Icons.error);
    }
  }

  void saveToDatabase(String title) {
    final createdAt = DateTime.now().toString();
     if (title.length == 0) {
        throw TextFieldTitleException("Поле не должно быть пустым");
      }else {
        appDatabase.addTodo(Todo(id: 1, title: title, createdAt: createdAt, isDone: false));
        Navigator.of(context).pop(_textEditingController.text);
      }
  }

  Future <void> showAppSnackBar(
  BuildContext context, {
  required String text,
  Color? backgroundColor,
  IconData? icon,
  VoidCallback? onRetry,
  String retryText = "Повторить",
}) async {
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
          Expanded(child: Text(text, style: TextStyle(color: Colors.white))),
        ],
      ),
      backgroundColor: backgroundColor,
      behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.fromLTRB(12, 12, 12, 20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      duration: const Duration(seconds: 2),
      action: onRetry == null
          ? null
          : SnackBarAction(
              label: retryText,
              onPressed: onRetry,
              textColor: Colors.white,
            ),
    ),
  );
  }

//уничтожает виджет из памяти (освобождает)
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    print("AddPage dispose");
    _textEditingController.dispose();
  //остановить анимацию
  //остановить таймер или другие фоновые процессы
  //остановить контроллеры
  //остановить стримы (stream)
  }
}

class TextFieldTitleException implements Exception {
  final String message;

  TextFieldTitleException(this.message);

  @override
  String toString() {
    // TODO: implement toString
    return "$message";
  }
}