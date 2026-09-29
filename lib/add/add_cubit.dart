import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_list08flu/database/app_repository.dart';
import 'package:todo_list08flu/database/todo.dart';
import 'package:todo_list08flu/add/add_state.dart';

class AddCubit extends Cubit<AddState> {
  final AppRepository repo;

  AddCubit({required this.repo}) : super(AddState.initial());

  Future<void> saveTodo(String title) async {
    final cleanTitle = title.trim();

    if (cleanTitle.isEmpty) {
      emit(state.copyWith(
        status: AddStatus.error, 
        errorMessage: "Поле не должно быть пустым",
      ));
      return;
    }

    emit(state.copyWith(status: AddStatus.loading));

    try {
      final createdAt = DateTime.now().toString();
      final uniqueId = DateTime.now().millisecondsSinceEpoch;

      repo.addTodo(
        Todo(
          id: uniqueId,
          title: cleanTitle,
          createdAt: createdAt,
          isDone: false,
        ),
      );
      emit(state.copyWith(status: AddStatus.success));
    } catch (e) {
      emit(state.copyWith(
        status: AddStatus.error, 
        errorMessage: e.toString(),
      ));
    }
  }
}
