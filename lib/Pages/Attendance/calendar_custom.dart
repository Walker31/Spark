import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'attendance_utils.dart'; // Import the utility function
import '../../Models/subject.dart';
import '../../Providers/attendance_provider.dart';

class CustomCalendarDatePicker extends StatefulWidget {
  final DateTime selectedDate;
  final Subject? item;
  final ValueChanged<DateTime> onDateChanged;
  final Map<DateTime, bool> attendance;
  final ValueChanged<int> onAttendanceMarked;

  const CustomCalendarDatePicker({
    super.key,
    required this.attendance,
    required this.selectedDate,
    required this.onDateChanged,
    required this.item,
    required this.onAttendanceMarked,
  });

  @override
  CustomCalendarDatePickerState createState() =>
      CustomCalendarDatePickerState();
}

class CustomCalendarDatePickerState extends State<CustomCalendarDatePicker> {
  late DateTime _focusedDay;
  late DateTime _selectedDay;
  Logger logger = Logger();
  Map<DateTime, bool> attendanceMarked = {};

  @override
  void initState() {
    super.initState();
    _focusedDay = widget.selectedDate;
    _selectedDay = widget.selectedDate;
    fetchAttendanceData();
  }

  void showDropdownMenu(BuildContext context, Offset position) async {
    final selectedItem = await showMenu(
      context: context,
      position: RelativeRect.fromLTRB(
        position.dx,
        position.dy,
        position.dx,
        position.dy,
      ),
      items: [
        const PopupMenuItem<int>(
          value: 1,
          child: Text('PRESENT'),
        ),
        const PopupMenuItem<int>(
          value: 2,
          child: Text('ABSENT'),
        ),
      ],
    );

    if (selectedItem != null) {
      logger.d('Selected: $selectedItem');
      // ignore: use_build_context_synchronously
      markAttendance(context, widget.item!, _selectedDay, selectedItem);
      fetchAttendanceData(); // Refresh attendance data after marking
      widget.onAttendanceMarked(selectedItem);
    }
  }

  Future<void> fetchAttendanceData() async {
    try {
      var attendanceList =
          await Provider.of<AttendanceProvider>(context, listen: false)
              .getAttendanceForSubject(widget.item!.subName);
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

  @override
  Widget build(BuildContext context) {
    return TableCalendar(
      onDayLongPressed: (selectedDay, focusedDay) {
        setState(() {
          _selectedDay = selectedDay;
          _focusedDay = focusedDay;
        });

        final RenderBox overlay =
            Overlay.of(context).context.findRenderObject() as RenderBox;
        final RenderBox calendarBox = context.findRenderObject() as RenderBox;
        final Offset position = calendarBox.localToGlobal(
            calendarBox.size.center(Offset.zero),
            ancestor: overlay);

        showDropdownMenu(context, position);
      },
      firstDay: DateTime(2024, 1, 1),
      lastDay: DateTime(2099, 12, 31),
      focusedDay: _focusedDay,
      selectedDayPredicate: (day) {
        return isSameDay(_selectedDay, day);
      },
      onDaySelected: (selectedDay, focusedDay) {
        setState(() {
          _selectedDay = selectedDay;
          _focusedDay = focusedDay;
        });
        widget.onDateChanged(selectedDay);
      },
      calendarStyle: const CalendarStyle(
        todayDecoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.blueAccent,
        ),
        selectedDecoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.orange,
        ),
        defaultDecoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.transparent,
        ),
        weekendDecoration: BoxDecoration(
          shape: BoxShape.circle,
        ),
        outsideDecoration: BoxDecoration(
          shape: BoxShape.circle,
        ),
        defaultTextStyle: TextStyle(color: Colors.white),
        weekendTextStyle: TextStyle(color: Colors.red),
        selectedTextStyle: TextStyle(color: Colors.white),
        todayTextStyle: TextStyle(color: Colors.white),
      ),
      daysOfWeekStyle: const DaysOfWeekStyle(
        weekdayStyle: TextStyle(color: Colors.blue),
        weekendStyle: TextStyle(color: Colors.red),
      ),
      headerStyle: const HeaderStyle(
        formatButtonVisible: false,
        titleCentered: true,
      ),
    );
  }
}
