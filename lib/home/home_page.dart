import 'package:flutter/material.dart';
import 'package:todo_list08flu/add/add_page.dart';
import 'dart:math';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_list08flu/database/todo.dart';
import 'package:todo_list08flu/home/home_cubit.dart';
import 'package:todo_list08flu/home/home_state.dart';
import 'package:todo_list08flu/setting_page.dart';

class MyHomePage extends StatefulWidget {
  //final HomeCubit cubit;
  final bool isDarkTheme;
  final Function(bool) onThemeChanged;

  const MyHomePage({
    super.key, 
    required this.isDarkTheme, 
    required this.onThemeChanged,
  });

  @override
  //Выделяет память для виджета с состоянием
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Todo> _todoList = [];
  late HomeCubit _cubit;
  
//занимает память, то есть в этот момент виджет появляется в оперативной памяти
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //готовим данные, подгружаем данные с локального хранилища, с сервера посредстовм интернета
    //инициализируем свойства
    //запускать анимации, либо таймеры
    print("MyHomePage initState");
   // _cubit = widget.cubit;
    _todoList = _cubit.getTodoList();
  }

//рисует интерфейс
  // @override
  // Widget build(BuildContext context) {
  //   print("MyHomePage build");
  //   return Scaffold(
  //     appBar: AppBar(
  //       backgroundColor: Theme.of(context).colorScheme.inversePrimary,
  //       title: Text(widget.title),
  //     ),
  //     body: Center(
  //       child: Column(
  //         mainAxisAlignment: .center,
  //         children: [
  //           const Text('You have pushed the button this many times:'),
  //           Text(
  //             '$_counter',
  //             style: Theme.of(context).textTheme.headlineMedium,
  //           ),
  //         ],
  //       ),
  //     ),
  //     floatingActionButton: FloatingActionButton(
  //       onPressed: onAddTap,
  //       tooltip: 'Increment',
  //       child: const Icon(Icons.add),
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    print("MyHomePage build");
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text("Мои задачи"),
        actions: [IconButton(onPressed: _onSettingsTap, icon: Icon(Icons.settings))],
      ),
      body: BlocBuilder<HomeCubit, HomeState>(
        builder: (context, state) {
          if (state.status == .empty) {
            return const Center(
              child: Text("У вас еще нет задач! Добавьте первую задачу."),
            );
          } else if (state.status ==.isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return Center(
              child: ListView.builder(
                itemCount: _todoList.length,
                itemBuilder: (context, index) {
                  return ListTile(title: Text(_todoList[index].title));
                }
                ),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: onAddTap,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }

  void onAddTap() async {
    final result = await Navigator.of(context).push(MaterialPageRoute(builder: (_) => AddPage()));
    _cubit.getTodoList();
  }

  void _onSettingsTap() {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => SettingsPage(isDarkTheme: widget.isDarkTheme, onThemeChanged: widget.onThemeChanged)));
  }
  
//уничтожает виджет из памяти (освобождает)
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    print("MyHomePage dispose");
  //остановить анимацию
  //остановить таймер или другие фоновые процессы
  //остановить контроллеры
  //остановить стримы (stream)
  }
}

extension on Random {
  void nextInt(int length) {

  }
}
