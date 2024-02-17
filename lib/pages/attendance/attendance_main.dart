import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:spark/data/subject_details.dart';
import 'package:spark/database/subject_db.dart';
import 'package:spark/pages/attendance/search_attendance.dart';
import 'detail_screen.dart';

// Constants
const String backgroundImagePath = 'assets/background_image.jpeg';
const Color loadingIndicatorColor = Color.fromARGB(255, 6, 139, 55);
const Color primaryColor = Colors.blue;

class AttendanceMain extends StatefulWidget {
  const AttendanceMain({Key? key}) : super(key: key);

  @override
  AttendanceMainState createState() => AttendanceMainState();
}

class AttendanceMainState extends State<AttendanceMain> {
  late Future<List<Subject>>? items;
  final subjectDB = SubjectDB();

  @override
  void initState() {
    super.initState();
    fetchList();
  }

  void fetchList() {
    items = subjectDB.fetchAll();
    setState(() {});
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
            return const Scaffold(body: Center(child: Text('Error loading details')));
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
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add New Subject'),
          content: ItemEntryDialog(
            onAddSubject: (subjectName, subjectCode) {
              Logger().e('Subject Name: $subjectName, Subject Code: $subjectCode');
              SubjectDB().create1(
                subName: subjectName,
                subCode: subjectCode,
              );
              Navigator.of(context).pop();
              fetchList(); // Refresh the list after adding a subject
            },
          ),
        );
      },
    );
  }

  void _deleteSubject(BuildContext context, String subjectName) {
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
                subjectDB.delete(subjectName);
                Navigator.of(context).pop();
                fetchList(); // Refresh the list after deleting a subject
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
        title: const Text('Spark'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              fetchList(); // Refresh the list when the refresh icon is pressed
            },
          ),
        ],
      ),
      body: _buildBody(),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: 'ADD',
            onPressed: () {
              _navigateToItemEntry(context);
            },
            tooltip: 'Add New Subject',
            child: const Icon(Icons.add),
          ),
          const SizedBox(height: 16),
          FloatingActionButton(
            heroTag: 'Search',
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
    return FutureBuilder<List<Subject>>(
      future: items,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(loadingIndicatorColor),
              strokeWidth: 6.0,
            ),
          );
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No Subjects added Yet'));
        } else {
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final subject = snapshot.data![index];
              return Card(
                elevation: 4,
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                  title: Text(subject.subName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24.0)),
                  subtitle: Text(subject.subCode, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0)),
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(10), bottomRight: Radius.circular(8)),
                  ),
                  onTap: () => _onItemTapped(context, subject),
                  onLongPress: () => _deleteSubject(context, subject.subName),
                  trailing: Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(width: 5, color: _getPercentageColor(subject.percent.toInt())),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      subject.percent.toStringAsFixed(2),
                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
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
    if (percent >= 80) {
      return Colors.green;
    } else if (percent >= 75) {
      return Colors.yellow;
    } else {
      return Colors.red;
    }
  }
}

class ItemEntryDialog extends StatelessWidget {
  final Function(String, String) onAddSubject;

  const ItemEntryDialog({Key? key, required this.onAddSubject}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextEditingController subjectNameController = TextEditingController();
    TextEditingController subjectCodeController = TextEditingController();

    return Column(
      children: [
        TextFormField(
          controller: subjectNameController,
          decoration: const InputDecoration(labelText: 'Subject Name'),
        ),
        TextFormField(
          controller: subjectCodeController,
          decoration: const InputDecoration(labelText: 'Subject Code'),
        ),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: () {
            onAddSubject(
              subjectNameController.text,
              subjectCodeController.text,
            );
          },
          child: const Text('Add Subject'),
        ),
      ],
    );
  }
}
