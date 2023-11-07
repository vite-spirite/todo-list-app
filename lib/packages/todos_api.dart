import 'package:sqflite/sqflite.dart';
import "dart:async";

class Todo {
  final int id;
  String title;
  bool completed;
  DateTime createdAt;
  DateTime endAt;

  Todo({
    required this.id,
    required this.title,
    required this.completed,
    required this.createdAt,
    required this.endAt,
  });

  factory Todo.fromJson(Map<String, dynamic> json) {
    return Todo(
      id: json['id'],
      title: json['title'],
      completed: json['completed'] == 0 ? false : true,
      createdAt: DateTime.parse(json['createdAt']),
      endAt: DateTime.parse(json['endAt']),
    );
  }

  get date => endAt;

  @override
  String toString() {
    return 'Todo{id: $id, title: $title, completed: $completed, createdAt: $createdAt, endAt: $endAt}';
  }
}

class TodoRepository {
  Database? db;

  List<Todo> todos = [];

  TodoRepository();

  Future<void> open(String dbname) async {
    db = await openDatabase(dbname);

    await db!.execute('''
      CREATE TABLE IF NOT EXISTS todos (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        completed INTEGER NOT NULL,
        createdAt DATETIME NOT NULL,
        endAt DATETIME NOT NULL
      )
    ''');

    await db!.execute('''
      INSERT INTO todos (title, completed, createdAt, endAt)
      VALUES ('Todo 1', 0, '2021-10-01 00:00:00', '2021-10-01 00:00:00')
    ''');

    await findByDate(DateTime.now());
  }


  Future<void> close() async {
    await db!.close();
  }

  Future<void> findByDate(DateTime date) async {
    final DateTime startDay = DateTime(date.year, date.month, date.day, 0, 0, 0);
    final DateTime endDay = DateTime(date.year, date.month, date.day, 23, 59, 59);

    final List<Map<String, dynamic>> maps = await db!.query('todos', orderBy: 'endAt ASC', where: 'endAt > ? AND endAt < ?', whereArgs: [startDay.toIso8601String(), endDay.toIso8601String()]);
    todos = maps.map((e) => Todo.fromJson(e)).toList();
  }

  Future<void> toggleComplete(Todo todo) async {
    todo.completed = !todo.completed;
    await db!.update('todos', {'completed': todo.completed ? 1 : 0}, where: 'id = ?', whereArgs: [todo.id]);
  }

  Future<void> delete(Todo todo) async {
    await db!.delete('todos', where: 'id = ?', whereArgs: [todo.id]);
  }

  Future<Todo> createTodo(String title, DateTime endAt) async {
    final createdAt = DateTime.now();
    final id = await db!.insert('todos', {
      'title': title,
      'completed': 0,
      'createdAt': createdAt.toIso8601String(),
      'endAt': endAt.toIso8601String(),
    });

    Todo todo = Todo(
      id: id,
      title: title,
      completed: false,
      createdAt: createdAt,
      endAt: endAt,
    );

    todos.add(todo);
    return todo;
  }

}