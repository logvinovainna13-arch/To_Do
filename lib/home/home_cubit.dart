import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_list/dataBase/app_dataBase.dart';
import 'package:todo_list/dataBase/toDo.dart';
import 'package:todo_list/home/home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final AppDatabase db = AppDatabase();

  // Инициализируем обычным объектом без ключевого слова const
  HomeCubit() : super(HomeState(todoList: [], status: TodoStatus.isLoading, isDarkTheme: false));

  List<Todo> getTodoList() {
    final todoList = db.getTodoList();
        if (todoList.isEmpty) {
      emit(state.copyWith(status: TodoStatus.empty, todoList: []));
    } else {
      emit(state.copyWith(status: TodoStatus.successs, todoList: List<Todo>.from(todoList)));
    }

    return todoList;
  }

  void addTask(String title) {
    emit(state.copyWith(status: TodoStatus.isLoading));

    final newTodo = Todo(
      id: DateTime.now().millisecondsSinceEpoch,
      title: title,
      createdAt: "${DateTime.now().day.toString().padLeft(2, '0')}.${DateTime.now().month.toString().padLeft(2, '0')}.${DateTime.now().year}",
      isDone: false,
    );

    db.getTodoList().insert(0, newTodo);
emit(state.copyWith(
      status: TodoStatus.successs,
      todoList: List<Todo>.from(db.getTodoList()),
    ));
  }

  void toggleTheme(bool isDark) {
    emit(state.copyWith(isDarkTheme: isDark));
  }
}
