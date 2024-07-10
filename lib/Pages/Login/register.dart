import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:spark/Widgets/base_scaffold.dart';
import '../../Providers/user_provider.dart';
import 'login_page.dart'; // Adjust the import path as per your project structure

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  RegisterPageState createState() => RegisterPageState();
}

class RegisterPageState extends State<RegisterPage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  Logger logger = Logger();
  final UsersProvider _usersProvider =
      UsersProvider(); // Initialize UsersProvider

  String? nameError;
  String? emailError;
  String? passwordError;


  void _register() async {
    setState(() {
      nameError = nameController.text.isEmpty ? 'Name cannot be empty' : null;
      emailError =
          emailController.text.isEmpty ? 'Email cannot be empty' : null;
      passwordError =
          passwordController.text.isEmpty ? 'Password cannot be empty' : null;
    });

    // Check if all fields are filled
    if (nameError == null && emailError == null && passwordError == null) {
      try {
        // Add user to UsersProvider
        _usersProvider.addUser(nameController.text.trim(),
            emailController.text.trim(), passwordController.text.trim());

        // Registration successful dialog
        showDialog(
          context: context,
          builder: (context) {
            return Container(
              color: Colors.black.withOpacity(0.5),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                child: AlertDialog(
                  backgroundColor: Colors.transparent,
                  title: const Text(
                    'Registration Successful',
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                  content: const Text(
                    'You have registered successfully.',
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop(); // Close dialog
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const Login()),
                        );
                      },
                      child: const Text('OK'),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      } catch (e) {
        logger.d('Registration Error: $e');
        // Handle registration errors here
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Error'),
            content: const Text('Registration failed. Please try again later.'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      body: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              // Clear text fields and navigate back
              nameController.clear();
              emailController.clear();
              passwordController.clear();
              Navigator.of(context).pop();
            },
            icon: const Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
            ),
          ),
          backgroundColor: Colors.transparent,
          actions: [
            TextButton(
              onPressed: () {
                // Continue as guest logic
                Navigator.pushReplacementNamed(context, '/home');
              },
              child: const Text(
                'Continue as guest',
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'Caveat',
                  fontSize: 24,
                ),
              ),
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Sign up",
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'Caveat',
                      fontSize: 40,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        // Name text field
                        TextField(
                          controller: nameController,
                          decoration: InputDecoration(
                            labelText: 'Name',
                            labelStyle: const TextStyle(
                              color: Colors.white,
                              fontFamily: 'Caveat',
                              fontSize: 24,
                            ),
                            border: const UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.black),
                            ),
                            errorText: nameError,
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        // Email text field
                        TextField(
                          controller: emailController,
                          decoration: InputDecoration(
                            labelText: 'Email Address',
                            labelStyle: const TextStyle(
                              color: Colors.white,
                              fontFamily: 'Caveat',
                              fontSize: 24,
                            ),
                            border: const UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.black),
                            ),
                            errorText: emailError,
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        // Password text field
                        TextField(
                          controller: passwordController,
                          obscureText: true,
                          decoration: InputDecoration(
                            labelText: 'Password',
                            labelStyle: const TextStyle(
                              color: Colors.white,
                              fontFamily: 'Caveat',
                              fontSize: 24,
                            ),
                            border: const UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.black),
                            ),
                            errorText: passwordError,
                          ),
                        ),
                        const SizedBox(
                          height: 40,
                        ),
                        // Sign up button
                        SizedBox(
                          width: double.infinity,
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 20),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: TextButton(
                              onPressed: _register,
                              child: const Text(
                                'Sign up',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontFamily: 'Caveat',
                                  fontSize: 30,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  // Row for "Already have an account?" and "Log in" link
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Already have an account? ',
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Caveat',
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          // Clear text fields and navigate back to login page
                          nameController.clear();
                          emailController.clear();
                          passwordController.clear();
                          Navigator.pop(context);
                        },
                        child: const Text(
                          'Log in',
                          style: TextStyle(
                            color: Colors.blue,
                            fontFamily: 'Caveat',
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        //bottomNavigationBar: const BottomNavBar(), // Bottom navigation bar
      ),
    );
  }
}
