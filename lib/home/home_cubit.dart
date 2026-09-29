import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_list08flu/database/app_repository.dart';
import 'package:todo_list08flu/database/todo.dart';
import 'package:todo_list08flu/home/home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final AppRepository repo;

  HomeCubit({required this.repo}):super(HomeState(todoList: [], status: .isLoading));

  List<Todo> getTodoList() {
    final todoList = repo.getTodoList();

    if (todoList.isEmpty) {
      emit(state.copyWith(status: .empty));
    } else {
      emit(state.copyWith(status: .success));
    }

    return todoList;
  }

  void loadTodos() {}
}