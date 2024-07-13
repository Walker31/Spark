import 'package:flutter/material.dart';

class CustomScaffold extends StatelessWidget {
  final Widget page;
  final int selectedIndex;
  final Function(int) onNavigationItemTapped;

  const CustomScaffold({
    super.key,
    required this.page,
    required this.selectedIndex,
    required this.onNavigationItemTapped,
  });

  @override
  Widget build(BuildContext context) {
    const String backgroundImagePath = 'assets/background_image.jpeg';

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(backgroundImagePath),
            fit: BoxFit.cover,
            opacity: 0.8,
          ),
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: AnimatedSwitcher(
            duration: const Duration(milliseconds: 500),
            child: page,
          ),
          bottomNavigationBar: BottomNavigationBar(
            backgroundColor: Colors.transparent,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: "Calendar",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.calendar_month_outlined),
                label: "Attendance",
              ),
            ],
            currentIndex: selectedIndex,
            onTap: onNavigationItemTapped,
            iconSize: 30, // Adjust the icon size
            selectedItemColor:
                Colors.blueGrey, // Set the color of the selected item
            unselectedItemColor:
                Colors.grey, // Set the color of unselected items
          ),
        ),
      ),
    );
  }
}
