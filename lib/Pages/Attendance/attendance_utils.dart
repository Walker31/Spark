// attendance_utils.dart
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import '../../Boxes/subject.dart';
import '../../Providers/attendance_provider.dart';
import '../../Widgets/add_subject.dart';
import 'details.dart';
import 'search.dart';

const String backgroundImagePath = 'assets/background_image.jpeg';
const Color loadingIndicatorColor = Color.fromARGB(255, 6, 139, 55);

Color getPercentageColor(int percent) {
  if (percent >= 85) {
    return Colors.green;
  } else if (percent >= 75) {
    return Colors.yellow;
  } else {
    return Colors.red;
  }
}

void onItemTapped(BuildContext context, Subject item) {
  final Logger logger = Logger();
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) {
        try {
          return DetailScreen(id: item.id!);
        } catch (e) {
          logger.d('Error navigating to DetailScreen: $e');
          return const Scaffold(
              body: Center(child: Text('Error loading details')));
        }
      },
    ),
  );
}

void search(BuildContext context) {
  final Logger logger = Logger();
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) {
        try {
          return const SearchAttendance();
        } catch (e) {
          logger.d('Error Navigating to Search Screen: $e');
          return const Scaffold(body: Center(child: Text('Error Searching')));
        }
      },
    ),
  );
}

void navigateToItemEntry(BuildContext context) {
  final Random random = Random();
  int generateIntKey() {
    return random.nextInt(1000000) + 1;
  }

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: const Text(
          'Add New Subject',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
        ),
        content: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ItemEntryDialog(
                  onAddSubject: (subjectName, subjectCode) {
                    Logger().d(
                        'Subject Name: $subjectName, Subject Code: $subjectCode');
                    final newSubject = Subject(
                      subName: subjectName,
                      subCode: subjectCode,
                      nPresent: 0,
                      nTotal: 0,
                      percent: 0.0,
                      id: generateIntKey(),
                    );
                    Logger().d(newSubject);
                    Provider.of<AttendanceProvider>(context, listen: false)
                        .addSubject(newSubject);
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}

void deleteSubject(BuildContext context, Subject subject) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Delete Subject'),
        content: const Text('Are you sure you want to delete this subject?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Provider.of<AttendanceProvider>(context, listen: false)
                  .deleteSubject(subject.id!);
              Navigator.of(context).pop();
            },
            child: const Text('Delete'),
          ),
        ],
      );
    },
  );
}
