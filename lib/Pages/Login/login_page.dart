import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:spark/Widgets/base_scaffold.dart';
import 'package:spark/models/user.dart';
import '../../Providers/user_provider.dart';
import 'register.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<Login> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final Logger _logger = Logger();
  final UsersProvider _usersProvider = UsersProvider();
  static const Color primaryTextColor = Colors.black;
  bool _isLoading = false;

  Future<void> _login() async {
    setState(() {
      _isLoading = true;
    });

    String enteredEmail = emailController.text.trim();
    String enteredPassword = passwordController.text.trim();

    User nullUser = User(userId: 0, userName: '', email: '', password: '');

    // Remove focus from text fields to dismiss keyboard
    FocusScope.of(context).unfocus();

    if (enteredEmail.isNotEmpty && enteredPassword.isNotEmpty) {
      try {
        // Fetch users from UsersProvider
        await _usersProvider.fetchUsers();

        // Check if the entered email and password match any user
        User user = _usersProvider.users.firstWhere(
          (user) =>
              user.email == enteredEmail && user.password == enteredPassword,
          orElse: () => nullUser,
        );

        if (!mounted) return;

        if (user != nullUser) {
          // Save login state using SharedPreferences or similar
          // Navigate to home page after successful login
          Navigator.pushReplacementNamed(context, '/home');
        } else {
          _logger.d('Invalid credentials. Please try again.');
          emailController.clear();
          passwordController.clear();
          // Handle invalid credentials scenario (show snackbar or dialog)
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Invalid credentials. Please try again.'),
            ),
          );
        }
      } catch (e) {
        _logger.d('Login Error: $e');
        // Handle login errors here
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Login failed. Please try again later.'),
          ),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    } else {
      _logger.d('Please enter valid credentials');
    }
  }

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      body: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          leading: const Text(''), // Empty leading text to adjust alignment
          backgroundColor: Colors.transparent,
          actions: [
            // Action button for continuing as a guest
            TextButton(
              onPressed: () {
                // Add logic for continuing as guest
                Navigator.pushReplacementNamed(context, '/home');
              },
              child: const Text(
                'Continue as guest',
                style: TextStyle(
                  color: primaryTextColor,
                  fontFamily: 'Caveat',
                  fontSize: 24,
                ),
              ),
            ),
          ],
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // Title row for "Login"
                const Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      "Login",
                      style: TextStyle(
                        color: Colors.white,
                        fontStyle: FontStyle.italic,
                        fontFamily: 'Caveat',
                        fontSize: 56,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      // Email text field
                      TextField(
                        controller: emailController,
                        decoration: const InputDecoration(
                          labelText: 'Email Address',
                          labelStyle: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Caveat',
                            fontSize: 24,
                          ),
                          border: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.black),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      // Password text field
                      TextField(
                        controller: passwordController,
                        obscureText: true,
                        decoration: const InputDecoration(
                          labelText: 'Password',
                          labelStyle: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Caveat',
                            fontSize: 24,
                          ),
                          border: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.black),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                // Login button with loading indicator
                _isLoading
                    ? const CircularProgressIndicator() // Show loading indicator while logging in
                    : SizedBox(
                        width: double.infinity, // Expand button to full width
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 20),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: TextButton(
                            onPressed: _login, // Call login function here
                            child: const Text(
                              'Login',
                              style: TextStyle(
                                color: primaryTextColor,
                                fontFamily: 'Caveat',
                                fontSize: 30,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ),
                        ),
                      ),
                const SizedBox(
                  height: 20,
                ),
                // Sign up row with "Do not have an account?" and "Sign up" link
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Do not have an account? ',
                      style: TextStyle(
                        color: Colors.black,
                        fontFamily: 'Caveat',
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        // Clear text fields
                        emailController.clear();
                        passwordController.clear();

                        // Navigate to the registration page
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const RegisterPage(),
                          ),
                        );
                      },
                      child: const Text(
                        'Sign up',
                        style: TextStyle(
                          color: Colors.blue,
                          fontFamily: 'Caveat',
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          fontStyle: FontStyle.italic,
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
    );
  }
}
