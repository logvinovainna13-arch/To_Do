import 'package:todo_list08flu/database/app_database.dart';
import 'package:todo_list08flu/database/todo.dart';

abstract class AppRepository {
  List<Todo> getTodoList();

  void addTodo(Todo todo);
}

class AppRepositoryImpl extends AppRepository {
  final AppDatabase db;

  AppRepositoryImpl({required this.db});

  @override
  List<Todo> getTodoList() {
    return db.getTodoList();
  }

  @override
  void addTodo(Todo todo) {
    db.addTodo(todo);
  }
}