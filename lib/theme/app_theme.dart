import 'package:flutter/material.dart';
import 'package:gas_com/constants.dart';

class AppTheme {
  static const Color lightScaffoldBackgroundColor = Color(0xFFF7F7F7);
  static const Color lightTextColor = Color(0xFF16161E);
  static const Color lightSurfaceColor = Colors.white;

  static const Color darkScaffoldBackgroundColor = Color(0xFF0D0D0D);
  static const Color darkTextColor = Colors.white;
  static const Color darkSurfaceColor = Color(0xFF1D1D1D);

  static ThemeData lightTheme(BuildContext context) {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      primaryColor: primaryColor,
      scaffoldBackgroundColor: lightScaffoldBackgroundColor,
      fontFamily: grandisExtendedFont,
      colorScheme: const ColorScheme.light(
        primary: primaryColor,
        secondary: primaryColor,
        surface: lightSurfaceColor,
        onSurface: lightTextColor,
        error: errorColor,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: lightTextColor),
        titleTextStyle: TextStyle(
            color: lightTextColor,
            fontSize: 18,
            fontWeight: FontWeight.bold,
            fontFamily: grandisExtendedFont),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          textStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              fontFamily: grandisExtendedFont),
        ),
      ),
    );
  }

  static ThemeData darkTheme(BuildContext context) {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      primaryColor: primaryColor,
      scaffoldBackgroundColor: darkScaffoldBackgroundColor,
      fontFamily: grandisExtendedFont,
      colorScheme: const ColorScheme.dark(
        primary: primaryColor,
        secondary: primaryColor,
        surface: darkSurfaceColor,
        onSurface: darkTextColor,
        error: errorColor,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: darkTextColor),
        titleTextStyle: TextStyle(
            color: darkTextColor,
            fontSize: 18,
            fontWeight: FontWeight.bold,
            fontFamily: grandisExtendedFont),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          textStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              fontFamily: grandisExtendedFont),
        ),
      ),
    );
  }
}