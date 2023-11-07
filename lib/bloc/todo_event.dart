part of 'todo_bloc.dart';

@immutable
sealed class TodoEvent {}

class TodoInitialize extends TodoEvent {}
class TodoInitialized extends TodoEvent {}

class TodoCreate extends TodoEvent {
  final String title;
  final DateTime date;
  final DateTime createdAt = DateTime.now();

  TodoCreate({required this.title, required this.date});
}

class TodoFindByDate extends TodoEvent {
  final DateTime date;

  TodoFindByDate({required this.date});
}

class TodoToggleCompleted extends TodoEvent {
  final Todo todo;

  TodoToggleCompleted({required this.todo});
}

class TodoDelete extends TodoEvent {
  final Todo todo;

  TodoDelete({required this.todo});
}