import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TodoDateContainer extends StatelessWidget {
  final DateTime date;

  const TodoDateContainer({super.key, required this.date});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(DateFormat('EEEE', 'FR_fr').format(date).toUpperCase(), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
        Text(DateFormat('d/M/y', 'FR_fr').format(date)),
      ],
    );
  }
}