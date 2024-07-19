import 'package:flutter/material.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:provider/provider.dart';
import 'package:spark/Pages/home_screen.dart';
import 'Providers/user_provider.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  SplashState createState() => SplashState();
}

class SplashState extends State<Splash> {
  @override
  Widget build(BuildContext context) {
    return Consumer<UsersProvider>(
      builder: (context, userProvider, child) {
        return AnimatedSplashScreen(
          duration: 2000,
          splash: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/storm.png',
                width: 100,
                height: 100,
              ),
              const SizedBox(height: 20),
              const Text(
                'S P A R K',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.yellow,
                ),
              ),
            ],
          ),
          nextScreen:
              userProvider.isLoggedIn ? const HomePage() : const HomePage(),
          splashTransition: SplashTransition.fadeTransition,
          backgroundColor: Colors.black,
          splashIconSize: double.infinity,
        );
      },
    );
  }
}
