import 'dart:async';
import 'package:flutter/material.dart';

class CalendarCard extends StatefulWidget {
  final StreamController<String> streamController;

  const CalendarCard({super.key, required this.streamController});

  @override
  State<CalendarCard> createState() => _CalendarCardState();
}

class _CalendarCardState extends State<CalendarCard> {
  late DateTime _selectedDate;

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
    _emitSelectedDate(_selectedDate); // Emit initial selected date
  }

  void _emitSelectedDate(DateTime selectedDate) {
    widget.streamController.add(selectedDate.toString()); // Emit selected date through stream
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              colors: [Colors.blue.shade500, Colors.blue.shade900],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 10,
                spreadRadius: 5,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CalendarDatePicker(
                  firstDate: DateTime(2023, 12, 1),
                  lastDate: DateTime(2099, 12, 1),
                  initialDate: _selectedDate,
                  onDateChanged: (value) {
                    setState(() {
                      _selectedDate = value;
                    });
                    _emitSelectedDate(_selectedDate); // Emit selected date when date changes
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
