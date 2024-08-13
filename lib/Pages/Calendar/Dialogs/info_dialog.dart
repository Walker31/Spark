import 'package:flutter/material.dart';

void showInfoDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text(
          'Features of Calendar Page',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        content: const SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text(
                '• Calendar View: View and select dates from the calendar.',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 8),
              Text(
                '• Event List: See all events scheduled for the selected date.',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 8),
              Text(
                '• Filter Events: Filter events by type using the filter button.',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 8),
              Text(
                '• Add Events: Use the floating action button to add extra classes 🗓️ or your class schedule 📅.',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 8),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text(
              'OK',
              style: TextStyle(
                  color: Colors.blue,
                  fontSize: 16,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ],
        elevation: 24.0, // Adds shadow to the dialog
      );
    },
  );
}
