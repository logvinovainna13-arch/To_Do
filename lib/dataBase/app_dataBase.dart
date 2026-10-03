import 'package:hive/hive.dart';
import 'package:todo_list08flu/database/todo.dart';

class AppDatabase {
  final Box box = Hive.box('todoBox');
  List<Todo> _todoList = [];

  AppDatabase() {
    loadTodos();
  }

  void loadTodos() {
    final data = box.get('todos', defaultValue: []);

    if (data is List) {
      _todoList = data.map((e) {
        final Map item = e as Map;
        return Todo(
          id: item['id'] as int,
          title: item['title'] as String,
          createdAt: item['createdAt'] as String,
          isDone: item['isDone'] as bool,
        );
      }).toList();
    } else {
      _todoList = [];
    }
  }

  void saveTodos() {
    final data = _todoList.map((todo) {
      return {
        "id": todo.id,
        "title": todo.title,
        "createdAt": todo.createdAt,
        "isDone": todo.isDone
      };
    }).toList();

    box.put('todos', data);
  }

  List<Todo> getTodoList() {
    return List.unmodifiable(_todoList);
  }

  void addTodo(Todo todo) {
    _todoList = [todo, ..._todoList];
    saveTodos();
  } 

  void updateTodo(Todo updatedTodo) {
    final index = _todoList.indexWhere((t) => t.id == updatedTodo.id);
    if (index != -1) {
      _todoList[index] = updatedTodo;
      saveTodos();
    }
  }

  void deleteTodo(int id) {
    _todoList.removeWhere((t) => t.id == id);
    saveTodos();
  }
}
