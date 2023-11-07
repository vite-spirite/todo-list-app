import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:todo_list/packages/todos_api.dart';

part 'todo_event.dart';
part 'todo_state.dart';

class TodoBloc extends Bloc<TodoEvent, TodoState> {

  TodoRepository repository = TodoRepository();
  DateTime date = DateTime.now();

  TodoBloc() : super(TodoInitial()) {
    on<TodoInitialize>((event, emit)  async {
      await repository.open('todo.db');
      emit(TodoReadyToUse(repository, date));
    });

    on<TodoCreate>((event, emit) async {
      emit(TodoCreateAwait(repository));
      await repository.createTodo(event.title, event.date);
      await repository.findByDate(date);
      emit(TodoReadyToUse(repository, date));
    });

    on<TodoFindByDate>((event, emit) async {
      date = event.date;
      await repository.findByDate(event.date);
      emit(TodoReadyToUse(repository, date));
    });

    on<TodoToggleCompleted>((event, emit) async {
      await repository.toggleComplete(event.todo);
      emit(TodoReadyToUse(repository, date));
    });

    on<TodoDelete>((event, emit) async {
      await repository.delete(event.todo);
      await repository.findByDate(date);
      emit(TodoReadyToUse(repository, date));
    });
  }
}
