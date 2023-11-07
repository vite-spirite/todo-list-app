import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:todo_list/bloc/todo_bloc.dart';
import 'package:todo_list/view/todo_date_container.dart';

// ignore: must_be_immutable
class TodoHeader extends StatelessWidget {
  DateTime date;

  TodoHeader({super.key, required this.date});

  @override
  Widget build(BuildContext context) {
    final todoBloc = BlocProvider.of<TodoBloc>(context);
    print(date);
    
    return SliverToBoxAdapter(
      child: Container(
        decoration: BoxDecoration(borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(10), bottomRight: Radius.circular(10)), gradient: LinearGradient(colors: [Colors.teal, Colors.teal.shade700], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(width: double.infinity, child: Text("Tâches", style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white))),
              SizedBox(width: double.infinity, child: Text(DateFormat('EEEE, d/M/y', 'FR_fr').format(date).toString(), style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white), textAlign: TextAlign.left)),
              const SizedBox(height: 16),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GestureDetector(child: Container(width: 100/1.1, height: 100/1.1, decoration: const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(10)), color: Colors.teal, boxShadow: [BoxShadow(color: Color.fromARGB(31, 0, 0, 0), spreadRadius: 1, blurRadius: 10, offset: Offset(0, 0))]), child: TodoDateContainer(date: date.add(const Duration(days: -1)))), onTap: () => todoBloc.add(TodoFindByDate(date: date.add(const Duration(days: -1)))),),
                  GestureDetector(child: Container(width: 100, height: 100, decoration: const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(10)), color: Colors.teal, boxShadow: [BoxShadow(color: Color.fromARGB(31, 0, 0, 0), spreadRadius: 1, blurRadius: 10, offset: Offset(0, 0))]), child: TodoDateContainer(date: date)), onTap: () => todoBloc.add(TodoFindByDate(date: date))),
                  GestureDetector(child: Container(width: 100/1.1, height: 100/1.1, decoration: const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(10)), color: Colors.teal, boxShadow: [BoxShadow(color: Color.fromARGB(31, 0, 0, 0), spreadRadius: 1, blurRadius: 10, offset: Offset(0, 0))]), child: TodoDateContainer(date: date.add(const Duration(days: 1)))), onTap: () => todoBloc.add(TodoFindByDate(date: date.add(const Duration(days: 1)))),),
                ],
              ),

              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}