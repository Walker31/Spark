import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import '../../Boxes/attendance_count.dart';
import '../../Boxes/subject.dart';
import '../../Providers/attendance_provider.dart';
import 'package:uuid/uuid.dart' as uuid;

class InsertAttendance extends StatelessWidget {
  final Subject item;
  const InsertAttendance({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text(
            "Attendance",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        centerTitle: true,
      ),
      body: Enter(item: item),
    );
  }
}

class Enter extends StatefulWidget {
  final Subject item;

  const Enter({super.key, required this.item});

  @override
  EnterState createState() => EnterState();
}

class EnterState extends State<Enter> {
  DateTime? selectedDate;
  bool isFirstEntry = true;
  TextEditingController dateCtl = TextEditingController();

  @override
  void initState() {
    super.initState();
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
                              Text(widget.item.subName),
                            ],
                          ),
                          const SizedBox(height: 10.0),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text("Subject Code"),
                              Text(widget.item.subCode),
                            ],
                          ),
                          const SizedBox(height: 10.0),
                          Container(
                            height: 70,
                            padding: const EdgeInsets.all(8.0),
                            child: TextFormField(
                              controller: dateCtl,
                              decoration: const InputDecoration(
                                labelText: 'Date of Class',
                                border: OutlineInputBorder(),
                                contentPadding: EdgeInsets.symmetric(vertical: 20.0),
                              ),
                              onTap: () async {
                                FocusScope.of(context).requestFocus(FocusNode());
                                final date = await showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime(2020),
                                  lastDate: DateTime.now(),
                                );
                                if (date != null) {
                                  setState(() {
                                    selectedDate = date;
                                  });
                                  dateCtl.text = DateFormat('dd/MM/yyyy').format(date);
                                }
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
                                  fontSize: 8.0,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                ElevatedButton(
                  onPressed: isDateValid() ? () => attendance(context, true) : null,
                  style: ButtonStyle(
                    fixedSize: MaterialStateProperty.all<Size>(
                      const Size(120, 50),
                    ),
                  ),
                  child: const Text('Present'),
                ),
                ElevatedButton(
                  onPressed: isDateValid() ? () => attendance(context, false) : null,
                  style: ButtonStyle(
                    fixedSize: MaterialStateProperty.all<Size>(
                      const Size(120, 50),
                    ),
                  ),
                  child: const Text("Absent"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String formatDate(DateTime date) {
    return DateFormat('dd/MM/yyyy').format(date);
  }
  final uuidUuid = const uuid.Uuid();
  String generateUuid() {
      return uuidUuid.v4();
    }

  void attendance(BuildContext context, bool attend) {
    String id = generateUuid();
    if (selectedDate != null) {
      try {
        final attendance = AttendanceCount(
          id:id,
          subName: widget.item.subName,
          date: formatDate(selectedDate!),
          attend: attend,
        );
        Provider.of<AttendanceProvider>(context, listen: false).addAttendance(attendance);
        Provider.of<AttendanceProvider>(context, listen: false).updateSubject(widget.item);
        Navigator.of(context).pop();
      } catch (e) {
        Logger().e("Error inserting attendance: $e");
      }
    } else {
      setState(() {
        isFirstEntry = false;
      });
      Logger().e("Selected date is null");
    }
  }
}
