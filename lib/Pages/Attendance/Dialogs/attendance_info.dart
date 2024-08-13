import 'package:flutter/material.dart';

void attendanceInfoDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text(
          'Attendance Page',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        content: const SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text(
                '• Long Press the Subject tile to Edit the subject details',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 8),
              Text(
                '• Right swipe the tile to delete the subject.',
                style: TextStyle(fontSize: 16),
              ),
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
