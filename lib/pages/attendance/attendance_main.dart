import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:logger/logger.dart';
import '../../Boxes/subject.dart';
import '../../Providers/attendance_provider.dart';
import '../../Widgets/add_subject.dart';
import 'details.dart';
import 'search.dart';
import 'package:uuid/uuid.dart' as uuid;

const String backgroundImagePath = 'assets/background_image.jpeg';
const Color loadingIndicatorColor = Color.fromARGB(255, 6, 139, 55);

class Attendance extends StatefulWidget {
  const Attendance({super.key});

  @override
  State<Attendance> createState() => _AttendanceState();
}

class _AttendanceState extends State<Attendance> {
  @override
  void initState() {
    super.initState();
    Provider.of<AttendanceProvider>(context, listen: false).fetchSubjects();
  }

  final uuidUuid = const uuid.Uuid();

  String generateUuid() {
    return uuidUuid.v4();
  }

  void _onItemTapped(BuildContext context, Subject item) {
    final Logger logger = Logger();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          try {
            return DetailScreen(item: item);
          } catch (e) {
            logger.d('Error navigating to DetailScreen: $e');
            return const Scaffold(
                body: Center(child: Text('Error loading details')));
          }
        },
      ),
    );
  }

  void _search(BuildContext context) {
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

  void _navigateToItemEntry(BuildContext context) {
    final Random random = Random();

    int generateIntKey() {
      // Generate a random integer between 1 and 1000000 (inclusive)
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
                        key: generateIntKey(),
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

  void _deleteSubject(BuildContext context, Subject subject, int index) {
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
                    .deleteSubject(subject, index);
                Navigator.of(context).pop();
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green, // Add a background color
        elevation: 15,
        title: const Text(
          'Attendance Tracker',
          style: TextStyle(
              fontStyle: FontStyle.italic, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              Provider.of<AttendanceProvider>(context, listen: false)
                  .fetchSubjects();
            },
          ),
        ],
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background Image
          Image.asset(
            backgroundImagePath,
            fit: BoxFit.cover,
            color: Colors.black
                .withOpacity(0.6), // Adjust opacity for better readability
            colorBlendMode: BlendMode.darken,
          ),
          // Attendance List
          _buildBody(),
        ],
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: 'addButton',
            onPressed: () {
              _navigateToItemEntry(context);
            },
            tooltip: 'Add New Subject',
            child: const Icon(Icons.add),
          ),
          const SizedBox(height: 16),
          FloatingActionButton(
            heroTag: 'searchButton',
            onPressed: () {
              _search(context);
            },
            tooltip: 'Search Attendance',
            child: const Icon(Icons.search),
          ),
        ],
      ),
    );
  }

  Widget _buildBody() {
    return Consumer<AttendanceProvider>(
      builder: (context, attendanceProvider, child) {
        if (attendanceProvider.subjects.isEmpty) {
          return const Center(child: Text('No Subjects added Yet'));
        } else {
          return ListView.builder(
            itemCount: attendanceProvider.subjects.length,
            itemBuilder: (context, index) {
              final subject = attendanceProvider.subjects[index];
              return Card(
                elevation: 4,
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  visualDensity:
                      const VisualDensity(horizontal: 3, vertical: 3),
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                  title: Text(subject.subName,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 24.0)),
                  subtitle: Text(subject.subCode,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 20.0)),
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        bottomRight: Radius.circular(8)),
                  ),
                  onTap: () => _onItemTapped(context, subject),
                  onLongPress: () => _deleteSubject(context, subject, index),
                  trailing: Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                          width: 5,
                          color: _getPercentageColor(subject.percent.toInt())),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      subject.percent.toStringAsFixed(2),
                      style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    ),
                  ),
                ),
              );
            },
          );
        }
      },
    );
  }

  Color _getPercentageColor(int percent) {
    if (percent >= 85) {
      return Colors.green;
    } else if (percent >= 75) {
      return Colors.yellow;
    } else {
      return Colors.red;
    }
  }
}
