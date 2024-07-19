import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:realm/realm.dart';
import 'events_model.dart';

void showEditDialog(BuildContext context, String id, Realm realm, void Function() onEdit) {
  final event = realm.find<Event>(id);
  final schedule = realm.find<Schedule>(id);

  if (event == null && schedule == null) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Event or Schedule not found.')),
    );
    return;
  }

  final TextEditingController subjectNameController = TextEditingController();
  final TextEditingController eventTimeController = TextEditingController();

  if (event != null) {
    subjectNameController.text = event.subjectName;
    eventTimeController.text = DateFormat('yyyy-MM-dd HH:mm').format(event.eventTime);
  } else if (schedule != null) {
    subjectNameController.text = schedule.subjectName;
    eventTimeController.text = DateFormat('yyyy-MM-dd HH:mm').format(schedule.eventTime);
  }

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text("Edit Event"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: subjectNameController,
              decoration: const InputDecoration(labelText: 'Subject Name'),
            ),
            TextField(
              controller: eventTimeController,
              decoration: const InputDecoration(labelText: 'Event Time'),
              onTap: () async {
                FocusScope.of(context).requestFocus(FocusNode());
                final DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: event?.eventTime ?? schedule?.eventTime ?? DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2101),
                );
                if (pickedDate != null && context.mounted) {
                  final TimeOfDay? pickedTime = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.fromDateTime(event?.eventTime ?? schedule?.eventTime ?? DateTime.now()),
                  );
                  if (pickedTime != null && context.mounted) {
                    final DateTime newDateTime = DateTime(
                      pickedDate.year,
                      pickedDate.month,
                      pickedDate.day,
                      pickedTime.hour,
                      pickedTime.minute,
                    );
                    eventTimeController.text = DateFormat('yyyy-MM-dd HH:mm').format(newDateTime);
                  }
                }
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              try {
                realm.write(() {
                  if (event != null) {
                    event.subjectName = subjectNameController.text;
                    event.eventTime = DateFormat('yyyy-MM-dd HH:mm').parse(eventTimeController.text);
                  } else if (schedule != null) {
                    schedule.subjectName = subjectNameController.text;
                    schedule.eventTime = DateFormat('yyyy-MM-dd HH:mm').parse(eventTimeController.text);
                  }
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Event updated successfully.')),
                );
                Navigator.of(context).pop();
                onEdit();
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error updating event: $e')),
                  );
                }
              }
            },
            child: const Text("Save"),
          ),
        ],
      );
    },
  );
}
