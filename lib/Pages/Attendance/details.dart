import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import '../../Boxes/subject.dart';
import '../../Providers/attendance_provider.dart';
import 'history.dart';
import 'insert.dart';

class DetailScreen extends StatelessWidget {
  final Subject item;
  DetailScreen({super.key, required this.item});
  final Logger logger = Logger();

  void _getHistory(BuildContext context, Subject item) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => History(item: item)));
  }

  void _navigateToInsertAttendance(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => InsertAttendance(item: item),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Detail Screen"),
      ),
      body: Consumer<AttendanceProvider>(
        builder: (context, attendanceProvider, child) {
          return SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.all(12),
              child: Column(
                children: [
                  Card(
                    child: ListTile(
                      title: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text("Subject Name:"),
                              Text(item.subName),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text("Subject Code:"),
                              Text(item.subCode),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text("Total Classes Till Now: "),
                              Text((item.nTotal).toString()),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      _navigateToInsertAttendance(context);
                    },
                    child: const Text("Add Attendance"),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'History',
        onPressed: () {
          _getHistory(context, item);
        },
        child: const Icon(Icons.history),
      ),
    );
  }
}
