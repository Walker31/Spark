import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:spark/Providers/user_provider.dart';
import 'Boxes/attendance_count.dart';
import 'Boxes/subject.dart';
import 'Pages/home_screen.dart';
import 'Providers/attendance_provider.dart';
import 'splash.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(SubjectAdapter());
  await Hive.openBox<Subject>('subjects');
  Hive.registerAdapter(AttendanceCountAdapter());
  await Hive.openBox<AttendanceCount>('attendance_counts');

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
      ],
      child: MaterialApp(
        theme: ThemeData.light(),
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
