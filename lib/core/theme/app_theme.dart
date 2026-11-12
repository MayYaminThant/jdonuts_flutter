import 'package:flutter/material.dart';

abstract final class Palette {
  static const pink = Color(0xFFF5479C);
  static const cyan = Color(0xFF4BCBE3);
  static const ink = Color(0xFF24222A);
  static const pale = Color(0xFFFFF2F7);
  static const muted = Color(0xFF7C7B82);
}

abstract final class AppTheme {
  static ThemeData get light => ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFFFF8FB),
        colorScheme: ColorScheme.fromSeed(seedColor: Palette.pink),
        textTheme: const TextTheme(
            headlineMedium: TextStyle(
                fontSize: 28, fontWeight: FontWeight.w800, color: Palette.ink),
            titleLarge: TextStyle(
                fontSize: 21, fontWeight: FontWeight.w800, color: Palette.ink)),
        inputDecorationTheme: InputDecorationTheme(
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide.none),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 18, vertical: 18)),
      );
}
