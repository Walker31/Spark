import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import '../../Boxes/subject.dart';
import '../../Providers/attendance_provider.dart';
import 'history.dart';
import 'insert.dart';

class DetailScreen extends StatefulWidget {
  final int id;

  const DetailScreen({super.key, required this.id});

  @override
  DetailScreenState createState() => DetailScreenState();
}

class DetailScreenState extends State<DetailScreen> {
  final Logger logger = Logger();
  static const String backgroundImagePath = 'assets/background_image.jpeg';
  Subject? item;

  @override
  void initState() {
    super.initState();
    _fetchSubject();
  }

  Future<void> _fetchSubject() async {
    var subject = await Provider.of<AttendanceProvider>(context, listen: false)
        .getSubject(widget.id);
    setState(() {
      item = subject;
    });
  }

  Future<void> _getHistory(BuildContext context, Subject item) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => History(item: item)),
    );
    _fetchSubject(); // Refresh the state when coming back
  }

  Future<void> _navigateToInsertAttendance(BuildContext context) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => InsertAttendance(item: item!)),
    );
    _fetchSubject(); // Refresh the state when coming back
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: const AssetImage(backgroundImagePath),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              Colors.black.withOpacity(0.8),
              BlendMode.dstATop,
            ),
          ),
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            leading: IconButton(
                icon: const Icon(
                  Icons.arrow_back_ios,
                  color: Colors.black,
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                }),
            backgroundColor: Colors.transparent,
            elevation: 15,
            title: const Text(
              "S U B J E C T   D E T A I L S",
              style: TextStyle(
                color: Colors.black87,
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
            ),
            centerTitle: true,
          ),
          body: item == null
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
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
                                _buildDetailRow("Subject Name:", item!.subName),
                                const SizedBox(height: 8),
                                _buildDetailRow("Subject Code:", item!.subCode),
                                const SizedBox(height: 8),
                                _buildDetailRow("Total Classes Till Now:",
                                    item!.nTotal.toString()),
                                const SizedBox(height: 8),
                                _buildDetailRow("Attendance % till now:",
                                    item!.percent.toString()),
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
                            padding: const EdgeInsets.symmetric(
                                vertical: 12, horizontal: 20),
                          ),
                          child: const Text(
                            "Add Attendance",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
          floatingActionButton: item == null
              ? null
              : FloatingActionButton(
                  backgroundColor: Colors.green,
                  heroTag: 'History',
                  onPressed: () => _getHistory(context, item!),
                  child: const Icon(Icons.history),
                ),
        ),
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
