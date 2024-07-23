import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

import '../../Models/attendance_count.dart';
import '../../Models/subject.dart';
import '../../Providers/attendance_provider.dart';

class InsertAttendanceDialog extends StatelessWidget {
  final Subject? item;

  const InsertAttendanceDialog({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      alignment: Alignment.center,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(30))),
      title: const Center(child: Text('Mark Attendance')),
      content: Enter(item: item),
    );
  }
}

class Enter extends StatefulWidget {
  final Subject? item;

  const Enter({super.key, required this.item});

  @override
  EnterState createState() => EnterState();
}

class EnterState extends State<Enter> {
  DateTime? selectedDate;
  bool isFirstEntry = true;
  TextEditingController dateCtl = TextEditingController();
  final Logger logger = Logger();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    dateCtl.dispose();
    super.dispose();
  }

  bool isDateValid() {
    return selectedDate != null;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          _buildDetailRow("Subject Name", widget.item!.subName),
          const SizedBox(height: 10.0),
          _buildDetailRow("Subject Code", widget.item!.subCode),
          const SizedBox(height: 10.0),
          buildDatePicker(),
          const SizedBox(height: 16),
          buildButtons(context),
        ],
      ),
    );
  }

  Widget buildDatePicker() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
      child: Column(
        children: [
          TextFormField(
            showCursor: false,
            readOnly: true,
            controller: dateCtl,
            decoration: const InputDecoration(
              labelText: 'Date of Class',
              labelStyle: TextStyle(
                fontWeight: FontWeight.bold,
              ),
              border: OutlineInputBorder(),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.green, width: 2.0),
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              contentPadding:
                  EdgeInsets.symmetric(vertical: 20.0, horizontal: 12.0),
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
                  color: Colors.redAccent,
                  fontSize: 12.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Row buildButtons(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        ElevatedButton(
          onPressed: isDateValid() ? () => attendance(context, true) : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green.shade700,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
            elevation: 4,
          ),
          child: const Text(
            'PRESENT',
            style: TextStyle(
                fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
        ElevatedButton(
          onPressed: isDateValid() ? () => attendance(context, false) : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red.shade900,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
            elevation: 4,
          ),
          child: const Text(
            'ABSENT',
            style: TextStyle(
                fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
      ],
    );
  }

  void attendance(BuildContext context, bool isPresent) {
    setState(() {
      isFirstEntry = false;
    });

    if (!isDateValid()) {
      return;
    }

    if (selectedDate != null) {
      logger.i("Date of class: ${selectedDate.toString()}");

      final attendanceProvider =
          Provider.of<AttendanceProvider>(context, listen: false);

      AttendanceCount markAttendance = AttendanceCount(
          subName: widget.item!.subName,
          date: selectedDate!,
          attend: isPresent);
      attendanceProvider.addAttendance(markAttendance);

      Navigator.pop(context, true); // Close the dialog
    }
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
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontSize: 16),
          maxLines: 1,
        ),
      ],
    );
  }
}
