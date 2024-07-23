import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:realm/realm.dart';
import 'package:logger/logger.dart';
import 'package:spark/color_schemes.dart';
import '../../uuid.dart';
import 'events_model.dart';

class AddEventFab extends StatefulWidget {
  final Realm realm;
  final VoidCallback onEventAdded;

  const AddEventFab({
    super.key,
    required this.realm,
    required this.onEventAdded,
  });

  @override
  AddEventFabState createState() => AddEventFabState();
}

class AddEventFabState extends State<AddEventFab> {
  final logger = Logger();

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      backgroundColor: FAB,
      heroTag: "add_event",
      onPressed: () => _showAddEventDialog(context),
      child: const Icon(Icons.event_note),
    );
  }

  void _showAddEventDialog(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    String subjectName = '';
    String eventType = 'Extra Class'; // Default value
    DateTime eventDate = DateTime.now();
    TimeOfDay eventTime = TimeOfDay.now();

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text(
                'Add New Event',
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
                          'Extra Class',
                          'Assignment Submission',
                          'Exam',
                          'Others'
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
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Event Date',
                          labelStyle: TextStyle(color: Colors.blue.shade700),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.blue.shade700),
                          ),
                        ),
                        controller: TextEditingController(
                          text: DateFormat('yyyy-MM-dd').format(eventDate),
                        ),
                        readOnly: true,
                        onTap: () async {
                          DateTime? picked = await showDatePicker(
                            context: context,
                            initialDate: eventDate,
                            firstDate: DateTime.now(),
                            lastDate: DateTime(2101),
                          );
                          if (picked != null) {
                            setState(() {
                              eventDate = picked;
                            });
                          }
                        },
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Event Time',
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
                      _addEvent(Utils.generateUuid(), subjectName, eventType,
                          eventDate, eventTime);
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
      DateTime eventDate, TimeOfDay eventTime) {
    final eventDateTime = DateTime(
      eventDate.year,
      eventDate.month,
      eventDate.day,
      eventTime.hour,
      eventTime.minute,
    );

    var event = Event(id, subjectName, eventType, eventDateTime, eventDate);

    try {
      logger.d("Attempting to add event: $event");
      widget.realm.write(() {
        widget.realm.add(event);
      });
      logger.i("Event added successfully: $event");
      widget.onEventAdded();
    } catch (e) {
      logger.e("Failed to add event: $e");
    }
  }
}
