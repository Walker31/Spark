import 'package:flutter/material.dart';

BoxDecoration appBackgroundDecoration = BoxDecoration(
  image: DecorationImage(
    image: const AssetImage(backgroundImagePath),
    fit: BoxFit.cover,
    colorFilter: ColorFilter.mode(
      Colors.black.withOpacity(0.8),
      BlendMode.dstATop,
    ),
  ),
);

const String backgroundImagePath = 'assets/background_image.jpg';
