import 'package:flutter/material.dart';
import 'package:realm/realm.dart';
import 'package:logger/logger.dart';
import 'events_model.dart';
import 'package:uuid/uuid.dart' as uuid;


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
    return IconButton(
      onPressed: () => _showAddEventDialog(context),
      icon: const Icon(Icons.add),
    );
  }

  final uuidUuid = const uuid.Uuid();

  String _generateUuid() {
    return uuidUuid.v4();
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
              title: const Text('Add Schedule'),
              content: Form(
                key: formKey,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextFormField(
                        decoration:
                            const InputDecoration(labelText: 'Subject Name'),
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
                      DropdownButtonFormField<String>(
                        value: eventType,
                        decoration:
                            const InputDecoration(labelText: 'Event Type'),
                        items: [
                          'Class',
                          'Lab',
                        ]
                            .map((type) => DropdownMenuItem<String>(
                                  value: type,
                                  child: Text(type),
                                ))
                            .toList(),
                        onChanged: (value) {
                          setState(() {
                            eventType = value!;
                          });
                        },
                      ),
                      DropdownButtonFormField<String>(
                        value: eventDay,
                        decoration: const InputDecoration(labelText: 'Day'),
                        items: [
                          'Monday',
                          'Tuesday',
                          'Wednesday',
                          'Thursday',
                          'Friday'
                        ]
                            .map((day) => DropdownMenuItem<String>(
                                  value: day,
                                  child: Text(day),
                                ))
                            .toList(),
                        onChanged: (value) {
                          setState(() {
                            eventDay = value!;
                          });
                        },
                      ),
                      TextFormField(
                        decoration: const InputDecoration(labelText: 'Time:'),
                        controller: TextEditingController(
                            text: eventTime.format(context)),
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
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      formKey.currentState!.save();
                      String id = _generateUuid();
                      _addEvent(
                          id, subjectName, eventType, eventDay, eventTime);
                      Navigator.of(context).pop();
                    }
                  },
                  child: const Text('Add'),
                ),
              ],
            );
          },
        );
      },
    );
  }


  void _addEvent(String id, String subjectName, String eventType, String eventDay,
      TimeOfDay eventTime) {
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
