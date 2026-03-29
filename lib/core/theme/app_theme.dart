import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();

  static ThemeData get darkTheme => ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: Colors.black,
        colorScheme: const ColorScheme.dark(
          primary: Colors.white,
          secondary: Color(0xFFFF2D55),
          surface: Colors.black,
        ),
        iconTheme: const IconThemeData(color: Colors.white, size: 28),
        textTheme: const TextTheme(
          titleMedium: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
          bodyMedium: TextStyle(
            color: Colors.white,
            fontSize: 14,
          ),
          bodySmall: TextStyle(
            color: Colors.white70,
            fontSize: 12,
          ),
        ),
      );
}

class AppColors {
  AppColors._();

  static const Color like = Color(0xFFFF2D55);
  static const Color white = Colors.white;
  static const Color white70 = Colors.white70;
  static const Color black = Colors.black;
  static const Color transparent = Colors.transparent;
}
