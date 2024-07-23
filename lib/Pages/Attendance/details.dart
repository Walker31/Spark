import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:logger/logger.dart';
import 'package:spark/color_schemes.dart';
import 'package:spark/fonts.dart';
import '../../Models/subject.dart';
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
  static const String backgroundImagePath = 'assets/background_image.jpg';
  Subject? item;

  @override
  void initState() {
    super.initState();
    _fetchSubject();
  }

  Future<void> _fetchSubject() async {
    try {
      var subject =
          await Provider.of<AttendanceProvider>(context, listen: false)
              .getSubject(widget.id);
      setState(() {
        item = subject;
      });
    } catch (e) {
      logger.e("Failed to fetch subject: $e");
      // Optionally show an error message to the user
    }
  }

  Future<void> _getHistory(BuildContext context, Subject item) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => History(item: item)),
    );
    _fetchSubject(); // Refresh the state when coming back
  }

  Future<void> _showInsertAttendanceDialog(BuildContext context) async {
    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return InsertAttendanceDialog(item: item!);
      },
    );

    if (result ?? false) {
      _fetchSubject(); // Refresh the state when the dialog indicates success
    }
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
                icon: const Icon(Icons.arrow_back_ios, color: Colors.blueGrey),
                onPressed: () {
                  Navigator.of(context).pop();
                }),
            backgroundColor: Colors.transparent,
            elevation: 0,
            title: const Text("S U B J E C T   D E T A I L S",
                style: appBarTitleStyle),
            centerTitle: true,
          ),
          floatingActionButton: FloatingActionButton(
              backgroundColor: FAB,
              onPressed: () => _getHistory(context, item!),
              heroTag: 'History',
              tooltip: 'Get previous Attendance',
              child: const Icon(Icons.history)),
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
                                _buildDetailRow("Subject Name", item!.subName),
                                const SizedBox(height: 10.0),
                                _buildDetailRow("Subject Code", item!.subCode),
                                const SizedBox(height: 10.0),
                                _buildDetailRow(
                                    "Total Classes", item!.nTotal.toString()),
                                const SizedBox(height: 10.0),
                                _buildDetailRow("Attended Classes",
                                    item!.nPresent.toString()),
                                const SizedBox(height: 10.0),
                                _buildAttendancePercentage(),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        buildButtons(context),
                      ],
                    ),
                  ),
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
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
        ),
      ],
    );
  }

  Widget _buildAttendancePercentage() {
    double percentage =
        item!.nTotal > 0 ? (item!.nPresent / item!.nTotal) * 100 : 0.0;
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "Attendance Percentage",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            Text(
              "${percentage.toStringAsFixed(2)}%",
              style: TextStyle(
                fontSize: 16,
                color: percentage >= 75 ? Colors.green : Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10.0),
        LinearProgressIndicator(
          value: percentage / 100,
          backgroundColor: Colors.grey[300],
          valueColor: AlwaysStoppedAnimation<Color>(
            percentage >= 75 ? Colors.green : Colors.red,
          ),
        ),
      ],
    );
  }

  Widget buildButtons(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ElevatedButton(
          onPressed: () => _showInsertAttendanceDialog(context),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.grey.shade600,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
            elevation: 4,
          ),
          child: const Text(
            'Mark Attendance',
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black87),
          ),
        ),
      ],
    );
  }
}
