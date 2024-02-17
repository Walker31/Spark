import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spark/pages/splash.dart';
import 'my_app_state.dart';

class Spark extends StatelessWidget {
  const Spark({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<SharedPreferences>(
      future: SharedPreferences.getInstance(),
      builder: (context, snapshot) {
          // Provide the SharedPreferences instance to your app
          return ChangeNotifierProvider(
            create: (context) => MyAppState(),
            child: MaterialApp(
              theme: ThemeData.light(),
              darkTheme: ThemeData.dark(),
              title: 'Spark',
              debugShowCheckedModeBanner: false,
              home: const Splash()
            ),
          );
      },
    );
  }
}