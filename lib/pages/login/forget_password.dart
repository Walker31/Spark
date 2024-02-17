import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:spark/data/bg_data.dart';
import 'package:spark/utils/text_utils.dart';

class ForgetPasswordScreen extends StatelessWidget {
  final int selectedIndex;

  const ForgetPasswordScreen({super.key, required this.selectedIndex});

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
            top: 40,
            left: 10,
            child: IconButton(
              icon: const Icon(Icons.arrow_back),
              color: Colors.black,
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
          Container(
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
                        Center(child: TextUtil(text: "Forget Password", weight: true, size: 30)),
                        const Spacer(),
                        TextUtil(text: "Email"),
                        buildInputField('Enter your email', Icons.mail, theme),
                        const Spacer(),
                        buildSubmitButton(theme),
                        const Spacer(),
                      ],
                    ),
                  ),
                ),
              ),
            ),
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

  Widget buildSubmitButton(ThemeData theme) {
    return Container(
      height: 40,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
      ),
      alignment: Alignment.center,
      child: TextUtil(text: "Submit", color: Colors.black),
    );
  }
}
