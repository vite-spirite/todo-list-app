import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:todo_list/bloc/todo_bloc.dart';
import 'package:todo_list/view/new_todo.dart';
import 'package:todo_list/view/todo_date.dart';

// ignore: must_be_immutable
class TodoPage extends StatelessWidget {
  TodoPage({super.key});

  TextEditingController dateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final todoBloc = BlocProvider.of<TodoBloc>(context);
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet<void>(
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
              ),
              context: context,
              isScrollControlled: true,
              showDragHandle: true,
              enableDrag: true,
              builder: (context) => BlocProvider.value(
                    value: todoBloc,
                    child: const TodoCreateBackdrop(),
                  ));
        },
        child: const Icon(Icons.add),
      ),
      appBar: AppBar(
        title: const Text("Todo List"),
        backgroundColor: Colors.teal,
      ),
      body: CustomScrollView(
        slivers: [
          BlocBuilder<TodoBloc, TodoState>(
            builder: (context, state) {
              if(state is TodoReadyToUse) {
                return TodoHeader(date: state.date);
              }
              else {
                return TodoHeader(date: DateTime.now());
              }
            },
          ),
          BlocBuilder<TodoBloc, TodoState>(
            builder: (context, state) {
              if (state is TodoReadyToUse) {
                if(state.repository.todos.isNotEmpty) {
                  return SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        return Slidable(
                          endActionPane: ActionPane(
                            motion: const ScrollMotion(),
                            children: [
                              SlidableAction(onPressed: (context) {
                                final todo = state.repository.todos[index];
                                todoBloc.add(TodoDelete(todo: todo));
                              }, icon: Icons.delete, backgroundColor: Colors.red, label: 'Supprimer',),
                              !state.repository.todos[index].completed ?
                                SlidableAction(onPressed: (context) {
                                  final todo = state.repository.todos[index];
                                  todoBloc.add(TodoToggleCompleted(todo: todo));
                                }, icon: Icons.check, backgroundColor: Colors.green, label: 'Fait',)
                              :
                                SlidableAction(onPressed: (context) {
                                  final todo = state.repository.todos[index];
                                  todoBloc.add(TodoToggleCompleted(todo: todo));
                                }, icon: Icons.cancel, backgroundColor: Colors.grey, label: 'Annuler',)
                            ],
                          ),
                          child: ListTile(
                            leading: Icon(state.repository.todos[index].completed ? Icons.check_circle : Icons.circle_outlined, color: state.repository.todos[index].completed ? Colors.green : Colors.white),
                            title: Text(state.repository.todos[index].title),
                            subtitle: Text(
                                "${state.repository.todos[index].date.day}/${state.repository.todos[index].date.month}/${state.repository.todos[index].date.year} à ${state.repository.todos[index].date.hour}:${state.repository.todos[index].date.minute}"
                              ),
                          ),
                        );
                      },
                      childCount: state.repository.todos.length,
                    ),
                  );
                }
                else {
                  return const SliverFillRemaining(
                    child: Center(
                      child: Text("Aucune tâche pour cette date"),
                    ),
                  );
                }
              }

              return const SliverFillRemaining(
                  child: Center(child: CircularProgressIndicator()));
            },
          ),
        ],
      ),
    );
  }
}
