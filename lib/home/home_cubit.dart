import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_list08flu/database/app_repository.dart';
import 'package:todo_list08flu/database/todo.dart';
import 'package:todo_list08flu/home/home_state.dart';


class HomeCubit extends Cubit<HomeState> {
  final AppRepository repo;

  HomeCubit({required this.repo}) 
      : super(HomeState(todoList: const [], status: TodoStatus.isLoading)) {
    loadTodos();
  }

  void loadTodos() {
    try {
      emit(state.copyWith(status: TodoStatus.isLoading));
      
      final todoList = repo.getTodoList();

      if (todoList.isEmpty) {
        emit(state.copyWith(status: TodoStatus.empty, todoList: const []));
      } else {
        emit(state.copyWith(status: TodoStatus.success, todoList: todoList));
      }
    } catch (e) {
      emit(state.copyWith(status: TodoStatus.error)); 
    }
  }

  void deleteTodo(int id) {
    try {
      repo.deleteTodo(id); 
      loadTodos();         
    } catch (e) {
      emit(state.copyWith(status: TodoStatus.error));
    }
  }

  void toggleTodoStatus(Todo todo) {
    try {
      final updatedTodo = Todo(
        id: todo.id,
        title: todo.title,
        createdAt: todo.createdAt,
        isDone: !todo.isDone, 
      );
      repo.updateTodo(updatedTodo);
      loadTodos(); 
    } catch (e) {
      emit(state.copyWith(status: TodoStatus.error));
    }
  }
}

extension on AppRepository {
  void updateTodo(Todo updatedTodo) {}

  void deleteTodo(int id) {}
}

class TextFieldTitleException implements Exception {
  final String message;
  TextFieldTitleException(this.message);

  @override
  String toString() => message;
}

class TextFieldLengthException implements Exception {
  final String message;
  TextFieldLengthException(this.message);

  @override
  String toString() => message;
}
