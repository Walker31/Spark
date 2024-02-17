import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:spark/my_app.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() async {
  if (Platform.isWindows || Platform.isLinux) {
        sqfliteFfiInit();
        databaseFactory = databaseFactoryFfi;
      }
  WidgetsFlutterBinding.ensureInitialized();
  debugPaintSizeEnabled = false;
  runApp(const Spark());
}
