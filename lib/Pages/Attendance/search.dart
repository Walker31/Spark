import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import '../../Boxes/attendance_count.dart';
import '../../Database/database_service.dart';
import '../../color_schemes.dart';
import '../../fonts.dart';

class SearchAttendance extends StatelessWidget {
  const SearchAttendance({super.key});

  @override
  Widget build(BuildContext context) {
    return Theme(
      // Apply light or dark theme based on brightness
      data: ThemeData.from(
        colorScheme: Theme.of(context).brightness == Brightness.light
            ? lightColorScheme
            : darkColorScheme,
        textTheme: appTextTheme,
      ),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor:
              Colors.green, // Same background color as the previous page
          title: const Center(
            child: Text("Search Attendance",
                style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          centerTitle: true,
        ),
        body: Stack(fit: StackFit.expand, children: [
          // Background Image
          Positioned.fill(
            child: Image.asset(
              'assets/background_image.jpeg', // Replace with your image path
              fit: BoxFit.cover,
              color: Colors.black
                  .withOpacity(0.6), // Adjust opacity for better readability
              colorBlendMode: BlendMode.darken,
            ),
          ),
          // Attendance Search Widget
          const Search(),
        ]),
      ),
    );
  }
}

class Search extends StatefulWidget {
  const Search({super.key});

  @override
  SearchState createState() => SearchState();
}

class SearchState extends State<Search> {
  late TextEditingController _dateController;
  List<AttendanceCount> _attendanceList = [];
  DateTime? selectedDate;
  final Logger _logger = Logger();
  bool _isButtonEnabled = false;
  final DatabaseHelper _databaseHelper = DatabaseHelper.instance;

  @override
  void initState() {
    super.initState();
    _dateController = TextEditingController();
  }

  @override
  void dispose() {
    _dateController.dispose();
    super.dispose();
  }

  void showLoadingDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const Center(child: CircularProgressIndicator());
      },
    );
  }

  void showErrorSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(
      content: Text(message),
      duration: const Duration(seconds: 3),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  Future<void> _getAttendanceList() async {
    if (selectedDate == null) return;

    try {
      List<AttendanceCount> attendanceList =
          await _databaseHelper.getAttendanceByDate(selectedDate!);
      _logger.d('Fetched Attendance: ${attendanceList.length} records');

      if (mounted) {
        setState(() {
          _attendanceList = attendanceList;
        });
      }
    } catch (error) {
      _logger.e('Error fetching attendance: $error');
      // ignore: use_build_context_synchronously
      showErrorSnackBar(context, 'Error fetching attendance: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 16),
            Container(
              height: 70,
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: _dateController,
                scrollPadding: const EdgeInsets.all(20.0),
                decoration: InputDecoration(
                  labelText: "Date",
                  hintText: "Enter Class's Date",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  filled: true,
                  contentPadding: const EdgeInsets.symmetric(
                      vertical: 20.0, horizontal: 12.0),
                ),
                readOnly: true,
                onTap: () async {
                  FocusScope.of(context).requestFocus(FocusNode());
                  final date = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2024),
                    lastDate: DateTime.now(),
                  );
                  if (date != null) {
                    setState(() {
                      selectedDate = date;
                      _dateController.text =
                          DateFormat("dd/MM/yyyy").format(selectedDate!);
                      _isButtonEnabled = true;
                    });
                  } else {
                    setState(() {
                      _isButtonEnabled = false;
                    });
                  }
                },
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _isButtonEnabled
                  ? () async {
                      showLoadingDialog(context);
                      await _getAttendanceList();
                      // ignore: use_build_context_synchronously
                      Navigator.of(context).pop();
                    }
                  : null,
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.blue, // Background color
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                padding: const EdgeInsets.symmetric(
                    vertical: 16.0, horizontal: 32.0),
              ),
              child: const Text("GET Attendance"),
            ),
            if (_attendanceList.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _attendanceList.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 8.0),
                        child: Card(
                          elevation: 3,
                          child: ListTile(
                            tileColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            title: Text(
                              _attendanceList[index].subName,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black, // Adjust text color
                              ),
                            ),
                            trailing: Text(
                              _attendanceList[index].attend
                                  ? 'Present'
                                  : 'Absent',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black, // Adjust text color
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              )
            else
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'No attendance records available for the selected date.',
                  style: TextStyle(color: Colors.red),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
