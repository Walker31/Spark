  import 'package:flutter/material.dart';
  import 'package:provider/provider.dart';
  import 'package:hive_flutter/hive_flutter.dart';
  import 'Boxes/attendance_count.dart';
  import 'Boxes/subject.dart';
  import 'Providers/attendance_provider.dart';
  import 'my_app.dart';

  void main() async {
    await Hive.initFlutter();
    Hive.registerAdapter(SubjectAdapter());
    await Hive.openBox<Subject>('subjects');
    Hive.registerAdapter(AttendanceCountAdapter());
    await Hive.openBox<AttendanceCount>('attendance_counts');

    runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => AttendanceProvider()),
        ],
        child: const Spark(),
      ),
    );
  }
