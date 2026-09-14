import 'package:flutter/material.dart';
import 'dart:async';

class AddPage extends StatefulWidget {
  const AddPage({super.key});

 @override
  State<AddPage> createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
  late Timer _timer;
TextEditingController _textEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      final date = DateTime.now();
      print("${date.minute} : ${date.second}");
    });
    print("AddPage initState");
  }

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
    Navigator.of(context).pop(_textEditingController.text);
  }
  @override
  void dispose() {
    super.dispose();
    print("AddPage dispose");
    _textEditingController.dispose();
    _timer.cancel();
  }
}