import 'package:flutter/material.dart';

ThemeData darkTheme = ThemeData(
    fontFamily: 'Poppins',
    brightness: Brightness.dark,
    colorScheme: ColorScheme.dark(
        primaryContainer: const Color.fromARGB(255, 4, 24, 54),
        background: const Color.fromARGB(255, 0, 12, 30),
        primary: Colors.white,
        secondary: Colors.grey.shade400));
