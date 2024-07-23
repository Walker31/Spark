import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spark/Providers/notes_provider.dart';
import 'package:spark/Providers/user_provider.dart';
import 'Pages/home_screen.dart';
import 'Providers/attendance_provider.dart';
import 'splash.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  runApp(const Spark());
}

class Spark extends StatelessWidget {
  const Spark({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => UsersProvider()),
        ChangeNotifierProvider(create: (context) => AttendanceProvider()),
        ChangeNotifierProvider(create: (context) => NotesProvider())
      ],
      child: MaterialApp(
        theme: ThemeData.dark(),
        darkTheme: ThemeData.dark(),
        title: 'Spark',
        debugShowCheckedModeBanner: false,
        home: const Splash(),
        routes: {
          '/home': (context) => const HomePage(),
        },
      ),
    );
  }
}
