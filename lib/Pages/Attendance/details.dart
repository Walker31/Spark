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
  final String backgroundImagePath = 'assets/background_image.jpeg';



  void _getHistory(BuildContext context, Subject item) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => History(item: item)),
    );
  }

  void _navigateToInsertAttendance(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => InsertAttendance(item: item)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        elevation: 15,
        title: const Text(
          "Detail Screen",
          style: TextStyle(
            fontStyle: FontStyle.italic,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Consumer<AttendanceProvider>(
        builder: (context, attendanceProvider, child) {
          return Stack(
            fit: StackFit.expand,
          children: [
          // Background Image
          Image.asset(
            backgroundImagePath,
            fit: BoxFit.cover,
            color: Colors.black
                .withOpacity(0.6), // Adjust opacity for better readability
            colorBlendMode: BlendMode.darken),
            SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Card(
                      elevation: 4,
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            _buildDetailRow("Subject Name:", item.subName),
                            const SizedBox(height: 8),
                            _buildDetailRow("Subject Code:", item.subCode),
                            const SizedBox(height: 8),
                            _buildDetailRow("Total Classes Till Now:", item.nTotal.toString()),
                            const SizedBox(height: 8),
                            _buildDetailRow("Attendance % till now:", item.percent.toString()),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => _navigateToInsertAttendance(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                      ),
                      child: const Text(
                        "Add Attendance",
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            ]
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        heroTag: 'History',
        onPressed: () => _getHistory(context, item),
        child: const Icon(Icons.history),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        Text(
          value,
          style: const TextStyle(fontSize: 16),
        ),
      ],
    );
  }
}
