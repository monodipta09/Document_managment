import 'package:flutter/material.dart';

class AppColors {
  static const Color primary = Color(0xFF6200EE);
  static const Color secondary = Color(0xFF03DAC6);
  static const Color surface = Color(0xFFF5F5F5);
  static const Color onSurface = Color(0xFF000000);
}

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    primaryColor: AppColors.primary,
    scaffoldBackgroundColor: AppColors.surface,
      colorScheme: ColorScheme.light(
      primary: AppColors.primary,
      secondary: AppColors.secondary,
      surface: AppColors.surface, // Updated
      onSurface: AppColors.onSurface, // Updated
    ),
    textTheme: TextTheme(
      bodyLarge: TextStyle(color: AppColors.onSurface),
      bodyMedium: TextStyle(color: AppColors.onSurface),
    ),
  );

  static ThemeData darkTheme = ThemeData(
    primaryColor: AppColors.primary,
    scaffoldBackgroundColor: Colors.black,
    colorScheme: ColorScheme.dark(
      primary: AppColors.primary,
      secondary: AppColors.secondary,
      surface: Colors.black, // Updated
      onSurface: Colors.white, // Updated
    ),
    textTheme: TextTheme(
      bodyLarge: TextStyle(color: Colors.white),
      bodyMedium: TextStyle(color: Colors.white),
    ),
  );
}
