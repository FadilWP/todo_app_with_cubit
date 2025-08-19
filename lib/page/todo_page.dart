import 'package:flutter/material.dart';
// import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cubit_app/cubit/filter_cubit.dart';
import 'package:flutter_cubit_app/cubit/todo_cubit.dart';
import 'package:flutter_cubit_app/models/todo.dart';

class TodoPage extends StatelessWidget {
  const TodoPage({super.key});

  @override
  Widget build(BuildContext context) {
    final todoCubit = context.read<TodoCubit>();
    final controller = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Todo App (Cubit)"),
        actions: [
          PopupMenuButton<TodoFilter>(
            onSelected: (filter) {
              context.read<FilterCubit>().changeFilter(filter);
            },
            itemBuilder: (context) => const [
              PopupMenuItem(
                value: TodoFilter.all,
                child: Text("All"),
              ),
              PopupMenuItem(
                value: TodoFilter.active,
                child: Text("Active"),
              ),
              PopupMenuItem(
                value: TodoFilter.completed,
                child: Text("Completed"),
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              // input todo
              children: [
                Expanded(
                  child: TextField(
                    controller: controller,
                    decoration: const InputDecoration(
                      hintText: "Tambahkan todo...",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {
                    if (controller.text.isNotEmpty) {
                      todoCubit.addTodo(controller.text);
                      controller.clear();
                    }
                  },
                  child: const Text("Add"),
                ),
              ],
            ),
          ),
          // todo counter
          BlocBuilder<TodoCubit, List<Todo>>(
            builder: (context, todos) {
              final activeCount = todos.where((t) => !t.isDone).length;
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("Active todos: $activeCount"),
              );
            },
          ),
          // todo list
          Expanded(
            child: BlocBuilder2<TodoCubit, List<Todo>, FilterCubit, TodoFilter>(
              builder: (context, todos, filter) {
                List<Todo> filteredTodos;
                switch (filter) {
                  case TodoFilter.active:
                    filteredTodos = todos.where((t) => !t.isDone).toList();
                    break;
                  case TodoFilter.completed:
                    filteredTodos = todos.where((t) => !t.isDone).toList();
                    break;
                  default:
                    filteredTodos = todos;
                }

                if (filteredTodos.isEmpty) {
                  return const Center(child: Text("Tidak ada Todo"));
                }
                return ListView.builder(
                    itemCount: filteredTodos.length,
                    itemBuilder: (context, index) {
                      final todo = filteredTodos[index];
                      final originalIndex = todos.indexOf(todo);
                      return ListTile(
                        leading: Checkbox(
                          value: todo.isDone,
                          onChanged: (_) => todoCubit.toggleTodo(originalIndex),
                        ),
                        title: Text(
                          todo.title,
                          style: TextStyle(
                            decoration:
                                todo.isDone ? TextDecoration.lineThrough : null,
                          ),
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () => todoCubit.removeTodo(originalIndex),
                        ),
                      );
                    });
              },
            ),
          ),

          // Expanded(
          //   child:
          //       BlocBuilder<TodoCubit, List<Todo>>(builder: (context, todos) {
          //     if (todos.isEmpty) {
          //       return const Center(
          //         child: Text("Belum ada todo"),
          //       );
          //     }
          //     return ListView.builder(
          //         itemCount: todos.length,
          //         itemBuilder: (context, index) {
          //           final todo = todos[index];
          //           return ListTile(
          //             leading: Checkbox(
          //               value: todo.isDone,
          //               onChanged: (_) => todoCubit.toggleTodo(index),
          //             ),
          //             title: Text(
          //               todo.title,
          //               style: TextStyle(
          //                   decoration: todo.isDone
          //                       ? TextDecoration.lineThrough
          //                       : null),
          //             ),
          //             trailing: IconButton(
          //               icon: const Icon(Icons.delete),
          //               onPressed: () => todoCubit.removeTodo(index),
          //             ),
          //           );
          //         });
          //   }),
          // ),
        ],
      ),
    );
  }
}

/// Custom BlocBuilder untuk gabung 2 Cubit
class BlocBuilder2<A extends StateStreamable<SA>, SA,
    B extends StateStreamable<SB>, SB> extends StatelessWidget {
  final Widget Function(BuildContext, SA, SB) builder;

  const BlocBuilder2({super.key, required this.builder});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<A, SA>(
      builder: (context, stateA) {
        return BlocBuilder<B, SB>(
          builder: (context, stateB) {
            return builder(context, stateA, stateB);
          },
        );
      },
    );
  }
}
