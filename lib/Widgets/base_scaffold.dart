import 'package:flutter/material.dart';
import 'background.dart';

class BaseScaffold extends StatefulWidget {
  final Widget body;
  final String? title;

  const BaseScaffold({super.key, required this.body, this.title});

  @override
  BaseScaffoldState createState() => BaseScaffoldState();
}

class BaseScaffoldState extends State<BaseScaffold> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(decoration: appBackgroundDecoration, child: widget.body),
    );
  }
}
