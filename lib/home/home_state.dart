import 'package:todo_list/dataBase/toDo.dart';

enum TodoStatus{
  successs,
  empty,
  isLoading
}

class HomeState {
  final List<Todo> todoList;
  final TodoStatus status;
  final bool isDarkTheme;

  HomeState({
   required this.todoList,
   required this.status,
   required this.isDarkTheme,
   });

  HomeState copyWith({
    List<Todo>? todoList, 
    TodoStatus? status, 
    bool? isDarkTheme,}){
    return HomeState(
      todoList: todoList?? this.todoList, 
      status: status ?? this.status,
      isDarkTheme: isDarkTheme ?? this.isDarkTheme,
      );
  }
  
}