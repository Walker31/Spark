import 'package:flutter/material.dart';
import 'package:spark/data/subject_details.dart';
import 'package:spark/pages/attendance/history.dart';
import 'package:spark/pages/attendance/insert_attendance.dart';

class DetailScreen extends StatelessWidget {
  final Subject item;
  const DetailScreen({super.key, required this.item});

  void _getHistory(BuildContext context,Subject item){
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => History(item: item)
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Detail Screen"),
      ),
      body: SingleChildScrollView(
        child: Container(
          height: 200,
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
                          Text(item.nTotal.toString()),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16), // Adjusted space between Card and buttons

              ElevatedButton(
                onPressed: () {
                  _navigateToInsertAttendance(context);
                },
                child: const Text("Add Attendance"),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'History',
        onPressed: (){
          _getHistory(context, item);
        },
        child: const Icon(Icons.history)
      ),
    );
  }

  void _navigateToInsertAttendance(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => InsertAttendance(item: item), // Replace 'InsertAttendance' with the actual widget or screen for attendance insertion
      ),
    );
  }
}
