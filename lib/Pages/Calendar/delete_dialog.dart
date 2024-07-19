import 'package:flutter/material.dart';

Future<bool> showDeleteDialog(BuildContext context, String id, void Function(String id) onDelete) async {
  bool shouldDelete = false;
  await showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text("Delete Event"),
        content: const Text("Are you sure you want to delete this event?"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              onDelete(id);
              shouldDelete = true;
              Navigator.of(context).pop();
            },
            child: const Text("Delete"),
          ),
        ],
      );
    },
  );
  return shouldDelete;
}
