import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spark/Pages/home_screen.dart';
import 'splash.dart';
import 'app_state.dart'; // Ensure the correct path to MyAppState

class Spark extends StatelessWidget {
  const Spark({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<SharedPreferences>(
      future: SharedPreferences.getInstance(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            return _buildErrorWidget();
          } else {
            return ChangeNotifierProvider(
              create: (context) => MyAppState(),
              child: MaterialApp(
                theme: ThemeData.light(),
                darkTheme: ThemeData.dark(),
                title: 'Spark',
                debugShowCheckedModeBanner: false,
                home: const Splash(),
                routes: {
                  '/home': (context) => const HomePage(),
                }
              ),
            );
          }
        } else {
          return _buildLoadingWidget();
        }
      },
    );
  }

  Widget _buildErrorWidget() {
    return const Directionality(
      textDirection: TextDirection.ltr,
      child: Scaffold(
        body: Center(
          child: Text('Error occurred while initializing SharedPreferences.'),
        ),
      ),
    );
  }

  Widget _buildLoadingWidget() {
    return const Directionality(
      textDirection: TextDirection.ltr,
      child: Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}
