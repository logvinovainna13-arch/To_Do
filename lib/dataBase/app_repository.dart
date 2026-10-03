import 'package:todo_list08flu/database/app_database.dart';
import 'package:todo_list08flu/database/todo.dart';
import 'package:todo_list08flu/database/app_repository.dart';

abstract class AppRepository {
  List<Todo> getTodoList();

  void addTodo(Todo todo);

  void updateTodo(Todo updatedTodo) {}
  
  void deleteTodo(int id);
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

  @override
  void updateTodo(Todo todo) {
    db.updateTodo(todo);
  }

  @override
  void deleteTodo(int id) {
    db.deleteTodo(id);
  }
}

extension on AppDatabase {
  void updateTodo(Todo todo) {}

  void deleteTodo(int id) {}
}
