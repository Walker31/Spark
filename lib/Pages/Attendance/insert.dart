import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import '../../Boxes/attendance_count.dart';
import '../../Boxes/subject.dart';
import '../../Database/database_service.dart';
import '../../Providers/attendance_provider.dart';

class InsertAttendance extends StatelessWidget {
  final Subject? item;
  const InsertAttendance({super.key, required this.item});
  static const String backgroundImagePath = 'assets/background_image.jpeg';

  @override
  Widget build(BuildContext context) {
    return Container(
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
              icon: const Icon(Icons.arrow_back_ios),
              onPressed: () {
                Navigator.of(context).pop();
              }),
          backgroundColor: Colors.transparent,
          elevation: 15,
          title: const Text(
            "A T T E N D A N C E",
            style: TextStyle(
              fontStyle: FontStyle.italic,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
        ),
        body: Enter(item: item),
      ),
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
  static const String backgroundImagePath = 'assets/background_image.jpeg';

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
      backgroundColor: Colors.transparent,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              buildCard(),
              const SizedBox(height: 16),
              buildButtons(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildCard() {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildDetailRow("Subject Name", widget.item!.subName),
            const SizedBox(height: 10.0),
            _buildDetailRow("Subject Code", widget.item!.subCode),
            const SizedBox(height: 10.0),
            buildDatePicker(),
          ],
        ),
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
                  color: Colors.red,
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

  void attendance(BuildContext context, bool attend) async {
    if (selectedDate != null) {
      try {
        final attendance = AttendanceCount(
          subName: widget.item!.subName,
          date: selectedDate!,
          attend: attend,
        );

        final attendanceProvider =
            Provider.of<AttendanceProvider>(context, listen: false);
        await attendanceProvider.addAttendance(attendance);

        // Get the current attendance summary for the subject
        final attendanceSummary = await DatabaseHelper.instance
            .getAttendanceSummaryBySubject(widget.item!.subName);

        int presentCount = attendanceSummary['present'] ?? 0;
        int absentCount = attendanceSummary['absent'] ?? 0;
        int totalCount = presentCount + absentCount;

        // Update the subject with the new counts and percentage
        final updatedSubject = widget.item!.copyWith(
          nPresent: presentCount,
          nTotal: totalCount,
          percent: (totalCount == 0) ? 0 : (presentCount / totalCount) * 100,
        );

        await attendanceProvider.updateSubject(updatedSubject);

        // ignore: use_build_context_synchronously
        Navigator.of(context).pop();
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(attend ? 'Marked Present' : 'Marked Absent')),
        );
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
