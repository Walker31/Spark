import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:realm/realm.dart';
import '../events_model.dart';

void showEditDialog(
    BuildContext context, String id, Realm realm, void Function() onEdit) {
  final event = realm.find<Event>(id);
  final schedule = realm.find<Schedule>(id);

  List<String> scheduleItems = ['Class', 'Lab'];
  List<String> classItems = [
    'Extra Class',
    'Assignment Submission',
    'Exam',
    'Others'
  ];

  List<String> dropdownItems;
  if (event != null) {
    dropdownItems = classItems;
  } else if (schedule != null) {
    dropdownItems = scheduleItems;
  } else {
    dropdownItems = [];
  }

  final TextEditingController subjectNameController = TextEditingController();
  final TextEditingController eventTimeController = TextEditingController();
  final TextEditingController subjectTypeController = TextEditingController();

  if (event != null) {
    subjectNameController.text = event.subjectName;
    eventTimeController.text =
        DateFormat.jm().format(event.eventTime.toLocal());
    subjectTypeController.text = event.eventType;
  } else if (schedule != null) {
    subjectNameController.text = schedule.subjectName;
    eventTimeController.text =
        DateFormat.jm().format(schedule.eventTime.toLocal());
    subjectTypeController.text = schedule.eventType;
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
            DropdownButtonFormField<String>(
              value: subjectTypeController.text.isNotEmpty
                  ? subjectTypeController.text
                  : null,
              decoration: const InputDecoration(labelText: 'Subject Type'),
              items: dropdownItems.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (newValue) {
                subjectTypeController.text = newValue ?? '';
              },
            ),
            TextField(
              readOnly: true,
              controller: eventTimeController,
              decoration: const InputDecoration(labelText: 'Event Time'),
              onTap: () async {
                final TimeOfDay? pickedTime = await showTimePicker(
                  context: context,
                  initialTime: TimeOfDay.fromDateTime(
                      event?.eventTime.toLocal() ??
                          schedule?.eventTime.toLocal() ??
                          DateTime.now()),
                );
                if (pickedTime != null && context.mounted) {
                  final DateTime oldDate = event?.eventTime.toLocal() ??
                      schedule?.eventTime.toLocal() ??
                      DateTime.now();
                  final DateTime newDateTime = DateTime(
                    oldDate.year,
                    oldDate.month,
                    oldDate.day,
                    pickedTime.hour,
                    pickedTime.minute,
                  );
                  eventTimeController.text =
                      DateFormat.jm().format(newDateTime);
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
                    final DateTime oldDate = event.eventTime;
                    final DateTime newTime =
                        DateFormat.jm().parseStrict(eventTimeController.text);
                    event.eventTime = DateTime(
                      oldDate.year,
                      oldDate.month,
                      oldDate.day,
                      newTime.hour,
                      newTime.minute,
                    );
                    event.eventType = subjectTypeController.text;
                  } else if (schedule != null) {
                    schedule.subjectName = subjectNameController.text;
                    final DateTime oldDate = schedule.eventTime;
                    final DateTime newTime =
                        DateFormat.jm().parseStrict(eventTimeController.text);
                    schedule.eventTime = DateTime(
                      oldDate.year,
                      oldDate.month,
                      oldDate.day,
                      newTime.hour,
                      newTime.minute,
                    );
                    schedule.eventType = subjectTypeController.text;
                  }
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Event updated successfully.')),
                );
                Navigator.of(context).pop();
                onEdit();
              } catch (e) {
                if (context.mounted) {
                  Logger().e('Error updating event: $e');
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
