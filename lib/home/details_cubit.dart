import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_list08flu/database/app_repository.dart';
import 'package:todo_list08flu/database/todo.dart';
import 'details_state.dart';

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

class DetailsCubit extends Cubit<DetailsState> {
  final AppRepository repo;

  DetailsCubit({required this.repo}) : super(DetailsState.initial());

  Future<void> updateTodo(Todo originalTodo, String newTitle) async {
    final cleanTitle = newTitle.trim();

    try {
      if (cleanTitle.isEmpty) {
        throw TextFieldTitleException("Поле не должно быть пустым");
      }
      
      if (cleanTitle.length < 3) {
        throw TextFieldLengthException("Требуется не менее 3 символов");
      }

      emit(state.copyWith(status: DetailsStatus.loading));

      final updatedTodo = Todo(
        id: originalTodo.id,
        title: cleanTitle,
        createdAt: originalTodo.createdAt,
        isDone: originalTodo.isDone,
      );

      repo.updateTodo(updatedTodo); 

      emit(state.copyWith(status: DetailsStatus.success));
    } on TextFieldTitleException catch (e) {
      emit(state.copyWith(status: DetailsStatus.error, errorMessage: e.toString()));
    } on TextFieldLengthException catch (e) {
      emit(state.copyWith(status: DetailsStatus.error, errorMessage: e.toString()));
    } catch (e) {
      emit(state.copyWith(status: DetailsStatus.error, errorMessage: "Непредвиденная ошибка: $e"));
    }
  }
}

extension on AppRepository {
  void updateTodo(Todo updatedTodo) {}
}
