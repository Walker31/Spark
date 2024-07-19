import 'package:flutter/material.dart';
import 'package:spark/Pages/Calendar/calendar_page.dart';
import 'package:spark/Pages/Attendance/attendance_main.dart'; // Import your custom scaffold
import 'package:spark/custom_scaffold.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    Widget page;

    switch (selectedIndex) {
      case 0:
        page = const CalendarPage();
        break;
      case 1:
        page = const Attendance();
        break;
      default:
        throw UnimplementedError('No widget for $selectedIndex');
    }

    return CustomScaffold(
      page: page,
      selectedIndex: selectedIndex,
      onNavigationItemTapped: (index) {
        setState(() {
          selectedIndex = index;
        });
      },
    );
  }
}
