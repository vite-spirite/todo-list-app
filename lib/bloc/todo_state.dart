part of 'todo_bloc.dart';

@immutable
sealed class TodoState {}

class TodoInitial extends TodoState {}

class TodoReadyToUse extends TodoState {
  final TodoRepository repository;
  final DateTime date;

  TodoReadyToUse(this.repository, this.date);
}

class TodoCreateAwait extends TodoState {
  final TodoRepository repository;

  TodoCreateAwait(this.repository);
}