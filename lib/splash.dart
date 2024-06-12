import 'package:flutter/material.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'Pages/home_screen.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  SplashState createState() => SplashState();
}

class SplashState extends State<Splash> {
  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      duration: 2000, // Extended duration for better user experience
      splash: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.flash_on,
            size: MediaQuery.of(context).size.width * 0.4, // Adjust relative size as needed
            color: Colors.yellow, // Changed color to make it more vibrant
          ),
          const SizedBox(height: 20),
          const Text(
            'Spark',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.yellow,
            ),
          ),
        ],
      ),
      nextScreen: const HomePage(),
      splashTransition: SplashTransition.fadeTransition,
      backgroundColor: Colors.black,
      splashIconSize: double.infinity, // Ensure the container takes up full width
    );
  }
}
