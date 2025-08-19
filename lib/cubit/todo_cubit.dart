import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cubit_app/models/todo.dart';

class TodoCubit extends Cubit<List<Todo>> {
  TodoCubit() : super([]);

  void addTodo(String title) {
    final newTodo = Todo(title: title);
    emit([...state, newTodo]); // tambahkan ke list
  }

  void toggleTodo(int index) {
    final updated = state[index].copyWith(isDone: !state[index].isDone);
    final newList = [...state];
    newList[index] = updated;
    emit(newList);
  }

  void removeTodo(int index) {
    final newList = [...state]..removeAt(index);
    emit(newList);
  }
}
