import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:todo_list/bloc/todo_bloc.dart';
import 'package:todo_list/view/todo.dart';

void main() {
  initializeDateFormatting('fr_FR', null).then((_) => runApp(const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Todo List',
      theme: ThemeData(
        colorScheme: const ColorScheme.dark(primary: Colors.teal, background: Colors.black, onSecondaryContainer: Colors.black38),
        useMaterial3: true,
      ),
      home: const BlocProvidersApp(),
    );
  }
}

class BlocProvidersApp extends StatelessWidget {
  const BlocProvidersApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(create: (_) => TodoBloc()..add(TodoInitialize()), child: TodoPage());
  }
}