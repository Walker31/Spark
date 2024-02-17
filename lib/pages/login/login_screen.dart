import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:spark/pages/login/forget_password.dart';
import 'package:spark/utils/animations.dart';
import '../../data/bg_data.dart';
import '../../utils/text_utils.dart';
import 'register_user.dart';
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}
class _LoginScreenState extends State<LoginScreen> {
  int selectedIndex = 0;
  bool showOption = false;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      floatingActionButton: Container(
        margin: const EdgeInsets.symmetric(vertical: 10),
        height: 49,
        width: double.infinity,
        child: Row(
          children: [
            Expanded(
              child: showOption
                  ? ShowUpAnimation(
                      delay: 100,
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: bgList.length,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedIndex = index;
                              });
                            },
                            child: CircleAvatar(
                              radius: 30,
                              backgroundColor: selectedIndex == index
                                  ? Colors.white
                                  : Colors.transparent,
                              child: Padding(
                                padding: const EdgeInsets.all(1),
                                child: CircleAvatar(
                                  radius: 30,
                                  backgroundImage: AssetImage(bgList[index]),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    )
                  : const SizedBox(),
            ),
            const SizedBox(width: 20),
            showOption
                ? GestureDetector(
                    onTap: () {
                      setState(() {
                        showOption = false;
                      });
                    },
                    child: const Icon(Icons.close, color: Colors.white, size: 30),
                  )
                : GestureDetector(
                    onTap: () {
                      setState(() {
                        showOption = true;
                      });
                    },
                    child: CircleAvatar(
                      backgroundColor: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.all(1),
                        child: CircleAvatar(
                          radius: 30,
                          backgroundImage: AssetImage(bgList[selectedIndex]),
                        ),
                      ),
                    ),
                  )
          ],
        ),
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: buildBackgroundDecoration(selectedIndex),
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
                    Center(child: TextUtil(text: "Login", weight: true, size: 30)),
                    const Spacer(),
                    TextUtil(text: "Email"),
                    buildInputField('Enter your email', Icons.mail, theme),
                    const Spacer(),
                    TextUtil(text: "Password"),
                    buildInputField('Enter your password', Icons.lock, theme),
                    const Spacer(),
                    Row(
                      children: [
                        Container(
                          height: 15,
                          width: 15,
                          color: Colors.white,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: GestureDetector(
                            onTap: (){
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => ForgetPasswordScreen(selectedIndex: selectedIndex))
                              );
                            },
                            child: TextUtil(
                              text: "Remember Me, FORGET PASSWORD",
                              size: 12,
                              weight: true,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    buildLoginButton(theme),
                    const Spacer(),
                    Center(
                      child: GestureDetector(
                        onTap: (){
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => RegisterScreen(
                              selectedIndex: selectedIndex)),
                          );
                        },
                        child: TextUtil(
                          text: "Don't have an account? REGISTER",
                          size: 12,
                          weight: true,
                        ),
                      ),
                    ),
                    const Spacer(),
                  ],
                ),
              ),
            ),
          ),
        ),
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
  Widget buildLoginButton(ThemeData theme) {
    return GestureDetector(
      onTap: (){
      },
      child: Container(
        height: 40,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
        ),
        alignment: Alignment.center,
        child: TextUtil(text: "Log In", color: Colors.black),
      ),
    );
  }
  BoxDecoration buildBackgroundDecoration(int selectedIndex) {
    return BoxDecoration(
      image: DecorationImage(
        image: AssetImage(bgList[selectedIndex]),
        fit: BoxFit.fill,
      ),
    );
  }
}