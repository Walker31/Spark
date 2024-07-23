import 'package:flutter/material.dart';
import 'package:realm/realm.dart';
import 'package:logger/logger.dart';
import 'package:spark/color_schemes.dart';
import '../../uuid.dart';
import 'events_model.dart';

class AddTimeTable extends StatefulWidget {
  final Realm realm;
  final VoidCallback onScheduleUpdated;

  const AddTimeTable({
    super.key,
    required this.realm,
    required this.onScheduleUpdated,
  });

  @override
  AddScheduleState createState() => AddScheduleState();
}

class AddScheduleState extends State<AddTimeTable> {
  final logger = Logger();

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      backgroundColor: FAB,
      heroTag: "add_timetable_fab",
      onPressed: () => _showAddEventDialog(context),
      child: const Icon(Icons.class_outlined),
    );
  }

  void _showAddEventDialog(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    String subjectName = '';
    String eventType = 'Class'; // Default value
    String eventDay = 'Monday';
    TimeOfDay eventTime = TimeOfDay.now();

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text(
                'Add Schedule',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              content: Form(
                key: formKey,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Subject Name',
                          labelStyle: TextStyle(color: Colors.blue.shade700),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.blue.shade700),
                          ),
                        ),
                        onSaved: (value) {
                          subjectName = value!;
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a subject name';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 10),
                      DropdownButtonFormField<String>(
                        value: eventType,
                        decoration: InputDecoration(
                          labelText: 'Event Type',
                          labelStyle: TextStyle(color: Colors.blue.shade700),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.blue.shade700),
                          ),
                        ),
                        items: [
                          'Class',
                          'Lab',
                        ].map((type) {
                          return DropdownMenuItem<String>(
                            value: type,
                            child: Text(type),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            eventType = value!;
                          });
                        },
                      ),
                      const SizedBox(height: 10),
                      DropdownButtonFormField<String>(
                        value: eventDay,
                        decoration: InputDecoration(
                          labelText: 'Day',
                          labelStyle: TextStyle(color: Colors.blue.shade700),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.blue.shade700),
                          ),
                        ),
                        items: [
                          'Monday',
                          'Tuesday',
                          'Wednesday',
                          'Thursday',
                          'Friday'
                        ].map((day) {
                          return DropdownMenuItem<String>(
                            value: day,
                            child: Text(day),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            eventDay = value!;
                          });
                        },
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Time',
                          labelStyle: TextStyle(color: Colors.blue.shade700),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.blue.shade700),
                          ),
                        ),
                        controller: TextEditingController(
                          text: eventTime.format(context),
                        ),
                        readOnly: true,
                        onTap: () async {
                          TimeOfDay? picked = await showTimePicker(
                            context: context,
                            initialTime: eventTime,
                          );
                          if (picked != null) {
                            setState(() {
                              eventTime = picked;
                            });
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text(
                    'Cancel',
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      formKey.currentState!.save();
                      String id = Utils.generateUuid();
                      _addEvent(
                          id, subjectName, eventType, eventDay, eventTime);
                      Navigator.of(context).pop();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.blue.shade700,
                  ),
                  child: const Text('Add'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _addEvent(String id, String subjectName, String eventType,
      String eventDay, TimeOfDay eventTime) {
    var eventDate = DateTime.now();
    final eventDateTime = DateTime(
      eventDate.year,
      eventDate.month,
      eventDate.day,
      eventTime.hour,
      eventTime.minute,
    );
    var event = Schedule(id, eventDay, subjectName, eventDateTime, eventType);

    widget.realm.write(() {
      widget.realm.add(event);
    });
    widget.onScheduleUpdated();
  }
}
