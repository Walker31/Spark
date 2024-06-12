import 'package:flutter/material.dart';
import 'package:spark/Pages/Calendar/calendar.dart';

import 'Attendance/attendance_main.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  
  var selectedIndex = 0;
  @override
  Widget build(BuildContext context) {

    var colorScheme = Theme.of(context).colorScheme;
    const String backgroundImagePath = 'assets/background_image.jpeg';

    Widget page;

    switch (selectedIndex) {
      case 0:
        page = const CalendarPage();
      case 1:
        page = const Attendance();
      default:
        throw UnimplementedError('no widget for $selectedIndex');
    }

    var mainArea = Container(
      decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(backgroundImagePath),
            fit: BoxFit.cover,
            opacity: 0.8
          ),
        ),
      child: ColoredBox(
        color: colorScheme.surfaceVariant,
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 500),
          child: page,
        ),
      ),
    );

    return Scaffold(body: LayoutBuilder(builder: (context, constraints) {
      return Column(
        children: [
          Expanded(child: mainArea),
          const SizedBox(height: 0),
          Opacity(
              opacity: 0.9,
              child: BottomNavigationBar(
                elevation: 100,
                items: const [
                  BottomNavigationBarItem(
                      icon: Icon(Icons.home), label: "Home"),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.calendar_month_outlined),
                      label: "Attendance"),
                ],
                currentIndex: selectedIndex,
                onTap: (value) {
                  setState(() {
                    selectedIndex = value;
                  });
                },
                iconSize: 30, // Adjust the unselected item font size
                selectedItemColor:
                    Colors.blueGrey, // Set the color of the selected item
                unselectedItemColor: Colors.grey,
              )),
        ],
      );
    }));
  }
}
