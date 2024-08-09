import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:logger/logger.dart';
import 'package:spark/Pages/Attendance/attendance_utils.dart';
import 'package:spark/Pages/Attendance/calendar_custom.dart';
import 'package:spark/color_schemes.dart';
import 'package:spark/fonts.dart';
import '../../Models/subject.dart';
import '../../Providers/attendance_provider.dart';
import 'history.dart';

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
  DateTime selectedDate = DateTime.now();
  Map<DateTime, bool> attendanceMarked = {};

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
      fetchAttendanceData();
    } catch (e) {
      logger.e("Failed to fetch subject: $e");
      // Optionally show an error message to the user
    }
  }

  Future<void> fetchAttendanceData() async {
    try {
      logger.d('Subname: ${item!.subName}');
      var attendanceList =
          await Provider.of<AttendanceProvider>(context, listen: false)
              .getAttendanceForSubject(item!.subName);

      setState(() {
        attendanceMarked = {
          for (var attendance in attendanceList)
            attendance.date: attendance.attend
        };
      });
    } catch (e) {
      logger.e("Failed to fetch attendance data: $e");
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

  void markAttendance(int selectedItem) {
    if (selectedItem == 1) {
      setState(() {
        item!.nTotal += 1;
        item!.nPresent += 1;
      });
      logger.d('Marked as PRESENT');
    } else if (selectedItem == 2) {
      setState(() {
        item!.nTotal += 1;
      });
      logger.d('Marked as ABSENT');
    }
    Provider.of<AttendanceProvider>(context, listen: false)
        .updateSubject(item!);
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
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.blueGrey.withOpacity(0.5),
                                borderRadius: BorderRadius.circular(8)),
                            child: GestureDetector(
                                child: CustomCalendarDatePicker(
                                    item: item,
                                    attendance: attendanceMarked,
                                    selectedDate: selectedDate,
                                    onDateChanged: (value) {
                                      setState(() {
                                        selectedDate = selectedDate;
                                      });
                                    },
                                    onAttendanceMarked: markAttendance)),
                          ),
                        ),
                        const SizedBox(
                          height: 100,
                        ),
                        Card(
                          color: Colors.grey.shade900.withOpacity(0.5),
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
                color: getPercentageColor(percentage.toInt()),
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
              getPercentageColor(percentage.toInt())),
        ),
      ],
    );
  }
}
