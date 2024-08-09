// ignore_for_file: use_build_context_synchronously, duplicate_ignore

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:spark/fonts.dart';
import '../../Database/database_service.dart';
import '../../Models/attendance_count.dart';
import '../../Providers/attendance_provider.dart';

class SearchAttendance extends StatelessWidget {
  const SearchAttendance({super.key});

  @override
  Widget build(BuildContext context) {
    const String backgroundImagePath = 'assets/background_image.jpg';

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
        child: const Search(),
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
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
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
      // ignore: duplicate_ignore
      // ignore: use_build_context_synchronously
      showErrorSnackBar(context, 'Error fetching attendance: $error');
    }
  }

  Future<bool> confirmDelete(BuildContext context, int id) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Attendance'),
          content: const Text(
              'Are you sure you want to delete this attendance record?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            ),
            TextButton(
              child: const Text('Delete'),
              onPressed: () {
                Navigator.of(context).pop(true);
              },
            ),
          ],
        );
      },
    );

    if (result == true) {
      await deleteAttendance(id);
      return true;
    } else {
      _getAttendanceList();
      return false;
    }
  }

  Future<void> deleteAttendance(int id) async {
    final attendanceProvider =
        Provider.of<AttendanceProvider>(context, listen: false);
    try {
      await attendanceProvider.deleteAttendance(id);
      _getAttendanceList(); // Refresh the list after deletion
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Attendance record deleted')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error deleting attendance: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.blueGrey,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        backgroundColor: Colors.transparent,
        title: const Center(
          child: Text("Search Attendance", style: appBarTitleStyle),
        ),
        centerTitle: true,
      ),
      backgroundColor: Colors.transparent,
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 16),
            Container(
              height: 70,
              padding: const EdgeInsets.all(8.0),
              margin: const EdgeInsets.only(left: 24, right: 24),
              child: TextFormField(
                controller: _dateController,
                scrollPadding: const EdgeInsets.all(20.0),
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.calendar_today,
                      color: Colors.blueAccent),
                  hintText: "Enter Date to Search",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  filled: false,
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
                      final searchItem = _attendanceList[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16.0,
                          vertical: 8.0,
                        ),
                        child: Dismissible(
                          key: ValueKey(searchItem.id),
                          background: Container(
                            color: Colors.red,
                            alignment: Alignment.centerRight,
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: const Icon(
                              Icons.delete,
                              color: Colors.white,
                            ),
                          ),
                          direction: DismissDirection.endToStart,
                          confirmDismiss: (direction) async {
                            return await confirmDelete(context, searchItem.id!);
                          },
                          child: ListTile(
                            tileColor: Colors.grey.withOpacity(0.2),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            title: Text(
                              DateFormat('dd/MM/yyyy').format(searchItem.date),
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            trailing: Text(
                              searchItem.attend
                                  ? 'P R E S E N T'
                                  : 'A B S E N T',
                              style: TextStyle(
                                fontSize: 16,
                                color: searchItem.attend
                                    ? Colors.green
                                    : const Color.fromARGB(255, 156, 16, 5),
                                fontWeight: FontWeight.bold,
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
