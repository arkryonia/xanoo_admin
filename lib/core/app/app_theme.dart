import 'package:flutter/material.dart';
import 'package:xanoo_admin/core/app/app_constants.dart';

class AppTheme {
  static ThemeData theme() {
    return ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: palette.primary,
      ),
      inputDecorationTheme: InputDecorationTheme(
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: palette.inversePrimary,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: palette.inversePrimary,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: palette.error,
          ),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
          backgroundColor: WidgetStatePropertyAll(palette.primary),
          foregroundColor: WidgetStatePropertyAll(palette.onPrimary),
          minimumSize: const WidgetStatePropertyAll(
            Size.fromHeight(50),
          ),
          shape: WidgetStatePropertyAll(
            ContinuousRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ),
      useMaterial3: true,
    );
  }
}
