import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import '../../Boxes/attendance_count.dart';
import '../../Boxes/subject.dart';
import '../../Providers/attendance_provider.dart';

class InsertAttendance extends StatelessWidget {
  final Subject item;
  const InsertAttendance({super.key, required this.item});
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        elevation: 15,
        title: const Text(
          "Attendance",
          style: TextStyle(
            fontStyle: FontStyle.italic,
            fontWeight: FontWeight.bold,
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
  final String backgroundImagePath = 'assets/background_image.jpeg';

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
      body: Stack(
        children: [
          Image.asset(
                backgroundImagePath,
                fit: BoxFit.cover,
                color: Colors.black
                .withOpacity(0.6), // Adjust opacity for better readability
                colorBlendMode: BlendMode.darken),
          SingleChildScrollView(
                child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
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
                        _buildDetailRow("Subject Name", widget.item.subName),
                        const SizedBox(height: 10.0),
                        _buildDetailRow("Subject Code", widget.item.subCode),
                        const SizedBox(height: 10.0),
                        Container(
                        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10)
                        ),
                        child: Column(
                          children: [
                            TextFormField(
                              controller: dateCtl,
                              decoration: const InputDecoration(
                                labelText: 'Date of Class',
                                labelStyle: TextStyle(
                                  color: Colors.green,
                                  fontWeight: FontWeight.bold,
                                ),
                                border: OutlineInputBorder(),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.green),
                                  borderRadius: BorderRadius.all(Radius.circular(10)),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.green, width: 2.0),
                                  borderRadius: BorderRadius.all(Radius.circular(10)),
                                ),
                                contentPadding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 12.0),
                                filled: true,
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
                            if (!isDateValid() && !isFirstEntry)
                              Container(
                                padding: const EdgeInsets.only(top: 8.0),
                                alignment: Alignment.centerLeft,
                                child: const Text(
                                  '*Please select a valid date',
                                  style: TextStyle(
                                    color: Colors.red,
                                    fontSize: 12.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    ElevatedButton(
                      onPressed: isDateValid() ? () => attendance(context, true) : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                        fixedSize: const Size(120, 50),
                      ),
                      child: const Text(
                        'Present',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: isDateValid() ? () => attendance(context, false) : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                        fixedSize: const Size(120, 50),
                      ),
                      child: const Text(
                        "Absent",
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        ]
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

  String formatDate(DateTime date) {
    return DateFormat('dd/MM/yyyy').format(date);
  }

  void attendance(BuildContext context, bool attend) {
    if (selectedDate != null) {
      try {
        final attendance = AttendanceCount(
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
