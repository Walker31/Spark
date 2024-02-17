import 'package:flutter/material.dart';
import 'package:date_field/date_field.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:spark/data/subject_details.dart';
import 'package:spark/database/subject_db.dart';

class InsertAttendance extends StatelessWidget {
  final Subject item;
  const InsertAttendance({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:  AppBar(
        title: const Center(
          child: Text("Attendance",
          style: TextStyle(fontWeight: FontWeight.bold,)),
        ),
        centerTitle: true,
        ),
      body: Enter(item: item),
    );
  }
}

class Enter extends StatefulWidget {
  final Subject item;

  const Enter({super.key,required this.item});

  @override
  EnterState createState() => EnterState();
}

class EnterState extends State<Enter> {
  DateTime? selectedDate;
  bool isFirstEntry = true;
  final subjectDB = SubjectDB();
  late List<AttendanceCount> attendanceData;
  late Subject item;

  @override
  void initState() {
    super.initState();
    item = widget.item;
    fetchAttendanceData();
  }

  Future<void> updateSubject(Subject item) async {
  try {
    // Batch database operations
    final presentFuture = subjectDB.countPresent(subName: item.subName);
    final totalFuture = subjectDB.countTotal(subName: item.subName);
    final present = await presentFuture;
    final total = await totalFuture;
    final percent = (present / total) * 100;

    // Update the subject in the database
    await subjectDB.update(
      subName: item.subName,
      nTotal: total,
      nPresent: present,
      percent: percent,
    );

    // Update the local cache if needed
    setState(() {
      item.nTotal = total;
      item.nPresent = present;
      item.percent = percent;
    });
  } catch (e) {
    Logger().e("Error updating subject: $e");
    // Handle the error as needed
  }
}


  Future<void> fetchAttendanceData() async {
    try {
      final attendance = await subjectDB.fetchAttendance();
      setState(() {
        attendanceData = attendance;
      });
    } catch (e) {
      Logger().e("Error fetching attendance: $e");
      // Handle the error as needed
    }
  }


  bool isDateValid() {
    return selectedDate != null;
  }

  @override
  Widget build(BuildContext context) {
    return basicLayout();
  }

  Scaffold basicLayout() {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
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
                              const Text("Subject Name"),
                              Text(item.subName),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text("Subject Code"),
                              Text(item.subCode),
                            ],
                          ),
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
                                });
                              },
                            ),
                          ),
                          if (!isDateValid() && !isFirstEntry)
                            Container(
                              padding: const EdgeInsets.only(top: 1.0),
                              child: const Text(
                                '*Please select a valid date',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 10.0,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                ElevatedButton(
                  onPressed: isDateValid() ? () => attendance(true) : null,
                  style: ButtonStyle(
                    fixedSize: MaterialStateProperty.all<Size>(
                      const Size(120, 50),
                    ),
                  ),
                  child: const Text('Present'),
                ),
                ElevatedButton(
                  onPressed: isDateValid() ? () => attendance(false) : null,
                  style: ButtonStyle(
                    fixedSize: MaterialStateProperty.all<Size>(
                      const Size(120, 50),
                    ),
                  ),
                  child: const Text("Absent"),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  void attendance(bool attend) {
  Logger().d("$attend");
  if (selectedDate != null) {
    try {
      subjectDB.create2(
        subName: item.subName,
        date: selectedDate!.toString(),
        attend: attend,
      );
      Navigator.of(context).pop();
    } catch (e) {
      Logger().e("Error inserting attendance: $e");
      // Handle the error as needed
    }
  } else {
    Logger().e("Selected date is null");
    // Handle the case where selectedDate is null
  }
  updateSubject(item);
}
}
