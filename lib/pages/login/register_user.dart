  import 'dart:ui';

  import 'package:flutter/material.dart';
  import '../../data/bg_data.dart';
  import '../../utils/text_utils.dart';

  class RegisterScreen extends StatelessWidget {
    final int selectedIndex;

    const RegisterScreen({super.key, required this.selectedIndex});

    @override
    Widget build(BuildContext context) {
      final theme = Theme.of(context);

      return Scaffold(
        body: Stack(
          children: [
            Container(
              height: double.infinity,
              width: double.infinity,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(bgList[selectedIndex]),
                  fit: BoxFit.fill,
                ),
              ),
              alignment: Alignment.center,
            ),
            Positioned(
              top: 20,
              left: 10,
              child: IconButton(
                icon: const Icon(Icons.arrow_back),
                color: Colors.black,
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
            Column(
              children: [
                const SizedBox(height: kToolbarHeight),
                Expanded(
                  child: Container(
                    height: double.infinity,
                    width: double.infinity,
                    alignment: Alignment.center,
                    child: Container(
                      height: 400,
                      width: double.infinity,
                      margin: const EdgeInsets.symmetric(horizontal: 30),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.white),
                        borderRadius: BorderRadius.circular(15),
                        color: Colors.black.withOpacity(0.1),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaY: 5, sigmaX: 5),
                          child: Padding(
                            padding: const EdgeInsets.all(25),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Spacer(),
                                TextUtil(text: "Name"),
                                buildInputField('Enter your name', Icons.person, theme),
                                const Spacer(),
                                TextUtil(text: "Email"),
                                buildInputField('Enter your email', Icons.mail, theme),
                                const Spacer(),
                                TextUtil(text: "Password"),
                                buildInputField('Enter your password', Icons.lock, theme),
                                const Spacer(),
                                TextUtil(text: "Confirm Password"),
                                buildInputField('Confirm your password', Icons.lock, theme),
                                const Spacer(),
                                buildRegisterButton(theme),
                                const Spacer(),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    }

    Widget buildInputField(String hintText, IconData icon, ThemeData theme) {
      return Container(
        height: 35,
        decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: Colors.white))),
        child: TextFormField(
          style: theme.textTheme.bodyLarge!.copyWith(color: Colors.white),
          decoration: InputDecoration(
            suffixIcon: Icon(icon, color: Colors.white),
            hintText: hintText,
            hintStyle: theme.inputDecorationTheme.hintStyle?.copyWith(color: Colors.white) ?? const TextStyle(color: Colors.white),
            border: InputBorder.none,
          ),
        ),
      );
    }

    Widget buildRegisterButton(ThemeData theme) {
      return Container(
        height: 40,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
        ),
        alignment: Alignment.center,
        child: TextUtil(text: "Register", color: Colors.black),
      );
    }
  }
