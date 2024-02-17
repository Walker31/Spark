import 'package:flutter/material.dart';
import 'package:spark/pages/home_page.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';

class Splash extends StatefulWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  SplashState createState() => SplashState();
}

class SplashState extends State<Splash> {
  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      duration: 1500,
      splash: Center(
        child: SizedBox(
          width: double.infinity, // Ensure the container takes up full width
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Use Expanded instead of Flexible
              Expanded(
                child: Icon(
                  Icons.flash_on,
                  size: MediaQuery.of(context).size.width * 0.5, // Adjust relative size as needed
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 20), 
            ],
          ),
        ),
      ),
      nextScreen: const MyHomePage(),
      splashTransition: SplashTransition.fadeTransition,
      backgroundColor: Colors.black,
    );
  }
}