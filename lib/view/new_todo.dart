import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_list/bloc/todo_bloc.dart';

class TodoCreateBackdrop extends StatefulWidget {
  const TodoCreateBackdrop({super.key});

  @override
  State<TodoCreateBackdrop> createState() => _TodoCreateBackdropState();
}

class _TodoCreateBackdropState extends State<TodoCreateBackdrop> {
  TextEditingController titleController = TextEditingController();

  TextEditingController dateTextFieldController = TextEditingController();
  TextEditingController timeTextFieldController = TextEditingController();

  DateTime date = DateTime.now();

  void _handleDateTimeChange(DateTime? newDate, TimeOfDay? newTime) {
    setState(() {
      date = newDate != null
          ? DateTime(
              newDate.year, newDate.month, newDate.day, date.hour, date.minute)
          : date;
      date = newTime != null
          ? DateTime(
              date.year, date.month, date.day, newTime.hour, newTime.minute)
          : date;

      final diff = date.difference(DateTime.now());
      if (diff.isNegative) {
        date = date.add(diff.abs());
      }

      dateTextFieldController.text = "${date.day}/${date.month}/${date.year}";
      timeTextFieldController.text = "${date.hour}:${date.minute}";
    });
  }

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<TodoBloc>(context);

    dateTextFieldController.text = "${date.day}/${date.month}/${date.year}";
    timeTextFieldController.text = "${date.hour}:${date.minute}";

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
        TextField(
          decoration: const InputDecoration(
              border: OutlineInputBorder(), labelText: 'Titre'),
          controller: titleController,
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Row(
            children: [
              Expanded(
                //width: (MediaQuery.of(context).size.width / 2) - 16,
                child: TextField(
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(), labelText: 'Date'),
                  controller: dateTextFieldController,
                  readOnly: true,
                  onTap: () async {
                    final ndate = await showDatePicker(
                      context: context,
                      initialDate: date,
                      firstDate: DateTime.now(),
                      lastDate: DateTime(2100),
                    );

                    _handleDateTimeChange(ndate, null);
                  },
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                //width: (MediaQuery.of(context).size.width / 2) - 16,
                child: TextField(
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(), labelText: 'Heure'),
                  controller: timeTextFieldController,
                  readOnly: true,
                  onTap: () async {
                    final ntime = await showTimePicker(
                      context: context,
                      initialTime:
                          TimeOfDay(hour: date.hour, minute: date.minute),
                    );

                    _handleDateTimeChange(null, ntime);
                  },
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        OutlinedButton(
            onPressed: () {
              bloc.add(TodoCreate(title: titleController.text, date: date));
              Navigator.pop(context);
            },
            style: OutlinedButton.styleFrom(
                minimumSize: const Size.fromHeight(50),
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8)))),
            child: const Text('Ajouter une nouvelle tâche')),
        SizedBox(height: MediaQuery.of(context).viewInsets.bottom),
      ]),
    );
  }
}
