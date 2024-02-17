import 'package:flutter/material.dart';
import 'package:spark/pages/login/login_screen.dart';
import 'package:spark/pages/notes/notes_main.dart';
import 'package:spark/pages/schedule/schedule_main.dart';
import 'attendance/attendance_main.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;

    Widget page;
    switch (selectedIndex) {
      case 0:
        page = const LoginScreen();
        break;
      case 1:
        page = const AttendanceMain();
        break;
      case 2:
        page= const Notes();
        break;
      case 3:
        page= const Schedule();
        break;
      default:
        throw UnimplementedError('no widget for $selectedIndex');
    }
    var mainArea = ColoredBox(
      color: colorScheme.surfaceVariant,
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 500),
        child: page,
      ),
    );

    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth < 450) {
            return Column(
              children: [
                Expanded(child: mainArea),
                const SizedBox(height: 0), // Add this line to remove space between the screen and BottomNavigationBar
                Opacity(
                  opacity: 0.9,
                  child: BottomNavigationBar(
                    elevation: 100,
                    items: const [
                      BottomNavigationBarItem(
                        icon: Icon(Icons.home),
                        label: 'Home',
                        ),
                      BottomNavigationBarItem(
                        icon: Icon(Icons.calendar_month),
                        label: 'Attendance',
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(Icons.article_outlined),
                        label: 'Notes',
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(Icons.paste_outlined),
                        label: 'Schedule',
                      ),
                    ],
                    currentIndex: selectedIndex,
                    onTap: (value) {
                      setState(() {
                        selectedIndex = value;
                      });
                    },
                    iconSize: 30, // Adjust the unselected item font size
                    selectedItemColor: Colors.blueGrey, // Set the color of the selected item
                    unselectedItemColor: Colors.grey,
                  ),
                ),
              ],
            );
          } else {
            return Row(
              children: [
                SafeArea(
                  child: NavigationRail(
                    extended: constraints.maxWidth >= 600,
                    destinations: const [
                      NavigationRailDestination(
                        icon: Icon(Icons.home),
                        label: Text('Home'),
                      ),
                      NavigationRailDestination(
                        icon: Icon(Icons.calendar_month),
                        label: Text('Attendance'),
                      ),
                      NavigationRailDestination(
                        icon: Icon(Icons.article_outlined),
                        label: Text('Notes'),
                      ),
                      NavigationRailDestination(
                        icon: Icon(Icons.paste_outlined),
                        label: Text('Schedule'),
                      ),
                    ],
                    selectedIndex: selectedIndex,
                    onDestinationSelected: (value) {
                      setState(() {
                        selectedIndex = value;
                      });
                    },
                  ),
                ),
                Expanded(child: mainArea),
              ],
            );
          }
        },
      ),
    );
  }
}
