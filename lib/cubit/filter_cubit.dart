import 'package:flutter_bloc/flutter_bloc.dart';

enum TodoFilter { all, active, completed }

class FilterCubit extends Cubit<TodoFilter> {
  FilterCubit() : super(TodoFilter.all);

  void changeFilter(TodoFilter filter) => emit(filter);
}
