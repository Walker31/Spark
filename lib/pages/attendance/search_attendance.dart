import 'package:date_field/date_field.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:spark/data/subject_details.dart';
import 'package:spark/database/subject_db.dart';

class SearchAttendance extends StatelessWidget {
  const SearchAttendance({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text("Search Attendance", style: TextStyle(fontWeight: FontWeight.bold)),
        ),
        centerTitle: true,
      ),
      body: const Search(),
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
  bool isFirstEntry = true;
  final Logger _logger = Logger();
  bool _isButtonEnabled = false;

  bool isDateValid() {
    return selectedDate != null;
  }

  @override
  void initState() {
    super.initState();
    _dateController = TextEditingController();
  }

  void showLoadingDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
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

  @override
  Widget build(BuildContext context) {
    return layout();
  }

  Scaffold layout() {
    _logger.e("_isButtonEnabled: $_isButtonEnabled");
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 16),
            Container(
              height: 70,
              padding: const EdgeInsets.all(8.0),
              child: DateTimeFormField(
                decoration: const InputDecoration(
                  labelText: 'Date of Class',
                  border: OutlineInputBorder(),
                ),
                mode: DateTimeFieldPickerMode.date,
                dateFormat: DateFormat("dd/MM/yyyy"),
                firstDate: DateTime(2022),
                lastDate: DateTime.now(),
                initialPickerDateTime: DateTime.now(),
                onChanged: (DateTime? value) {
                  setState(() {
                    selectedDate = value;
                    if (isFirstEntry) {
                      isFirstEntry = false;
                    }
                    if (selectedDate != null) {
                      _dateController.text = DateFormat("dd/MM/yyyy").format(selectedDate!);
                      _isButtonEnabled = true;
                    } else {
                      _isButtonEnabled = false;
                    }
                  });
                },
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _isButtonEnabled
                  ? () {
                      try {
                        _logger.e("_isButtonEnabled: $_isButtonEnabled");
                        showLoadingDialog(context);
                        String date = _dateController.text;
                        _getAttendanceList(date).catchError((error) {
                          _logger.e('Error fetching attendance: $error');
                        }).whenComplete(() {
                          Navigator.of(context).pop();
                        });
                      } catch (error) {
                        showErrorSnackBar(context, 'Error fetching attendance: $error');
                      }
                    }
                  : null,
              child: const Text("GET Attendance"),
            ),
            if (_attendanceList.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: _attendanceList.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),// Add vertical padding
                        child: Card(
                          elevation: 3, // Add elevation for a raised effect
                          child: ListTile(
                            tileColor: const Color.fromARGB(255, 151, 27, 235),
                            shape: const RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(10),bottomRight: Radius.circular(10),),),
                            title: Text(
                              _attendanceList[index].subName,
                              style: const TextStyle(
                                fontSize: 16, // Increase font size for better visibility
                                fontWeight: FontWeight.bold, // Add bold font weight
                                color: Colors.white, // Set text color to black
                              ),
                            ),
                            trailing: Text(
                              _attendanceList[index].attend ? 'Present' : 'Absent',
                              style: const TextStyle(
                                fontSize: 16, // Increase font size for better visibility
                                fontWeight: FontWeight.bold, // Add bold font weight
                                color: Colors.white, // Set text color based on attendance
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

  Future<void> _getAttendanceList(String date) async {
    SubjectDB subjectDB = SubjectDB();
    List<AttendanceCount> attendanceList = await subjectDB.getAttendanceOnDate(date);

    setState(() {
      _attendanceList = attendanceList;
    });
  }
}

