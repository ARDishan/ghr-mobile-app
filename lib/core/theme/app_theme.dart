import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_fonts.dart';

/// Carried over from the previous project structure.
/// TODO: review as the redesign progresses.
class AppTheme {
  AppTheme._();

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      fontFamily: AppFonts.inter,
      colorScheme: ColorScheme.light(
        primary: AppColors.primary,
        primaryContainer: AppColors.primaryAccent,
        secondary: AppColors.gold,
        surface: AppColors.surface,
        error: AppColors.error,
        onPrimary: AppColors.white,
        onSurface: AppColors.textPrimary,
      ),
      scaffoldBackgroundColor: AppColors.background,
      // TODO: port over remaining component themes (inputs, buttons,
      // cards, snackbars, bottom nav, etc.) from the previous app_theme.dart.
    );
  }
}
