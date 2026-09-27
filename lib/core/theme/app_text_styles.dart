import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_fonts.dart';

/// Carried over from the previous project structure.
/// TODO: review as the redesign progresses.
class AppTextStyles {
  AppTextStyles._();

  static const TextStyle displayLarge = TextStyle(
    fontFamily: AppFonts.playfair,
    fontSize: 48,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
    height: 1.1,
    letterSpacing: -0.5,
  );

  static const TextStyle displayMedium = TextStyle(
    fontFamily: AppFonts.playfair,
    fontSize: 36,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
    height: 1.15,
    letterSpacing: -0.3,
  );

  static const TextStyle displaySmall = TextStyle(
    fontFamily: AppFonts.playfair,
    fontSize: 28,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    height: 1.2,
  );

  static const TextStyle headlineLarge = TextStyle(
    fontFamily: AppFonts.raleway,
    fontSize: 24,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
    height: 1.3,
    letterSpacing: 0.2,
  );

  static const TextStyle headlineMedium = TextStyle(
    fontFamily: AppFonts.raleway,
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    height: 1.3,
  );

  static const TextStyle headlineSmall = TextStyle(
    fontFamily: AppFonts.raleway,
    fontSize: 17,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    height: 1.4,
  );

  static const TextStyle bodyLarge = TextStyle(
    fontFamily: AppFonts.inter,
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: AppColors.textPrimary,
    height: 1.6,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontFamily: AppFonts.inter,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
    height: 1.6,
  );

  static const TextStyle bodySmall = TextStyle(
    fontFamily: AppFonts.inter,
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
    height: 1.5,
  );

  static const TextStyle labelLarge = TextStyle(
    fontFamily: AppFonts.raleway,
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    letterSpacing: 0.8,
  );

  static const TextStyle labelMedium = TextStyle(
    fontFamily: AppFonts.raleway,
    fontSize: 12,
    fontWeight: FontWeight.w600,
    color: AppColors.textSecondary,
    letterSpacing: 0.6,
  );

  static const TextStyle labelSmall = TextStyle(
    fontFamily: AppFonts.inter,
    fontSize: 10,
    fontWeight: FontWeight.w500,
    color: AppColors.textSecondary,
    letterSpacing: 0.5,
  );

  static const TextStyle buttonLarge = TextStyle(
    fontFamily: AppFonts.raleway,
    fontSize: 15,
    fontWeight: FontWeight.w700,
    letterSpacing: 1.2,
  );

  static const TextStyle buttonMedium = TextStyle(
    fontFamily: AppFonts.raleway,
    fontSize: 13,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.8,
  );

  static const TextStyle caption = TextStyle(
    fontFamily: AppFonts.inter,
    fontSize: 11,
    fontWeight: FontWeight.w400,
    color: AppColors.textHint,
    height: 1.4,
  );

  static const TextStyle sectionTitle = TextStyle(
    fontFamily: AppFonts.raleway,
    fontSize: 18,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
    letterSpacing: 0.3,
  );

  static const TextStyle priceTag = TextStyle(
    fontFamily: AppFonts.playfair,
    fontSize: 22,
    fontWeight: FontWeight.w700,
    color: AppColors.primary,
  );

  static const TextStyle link = TextStyle(
    fontFamily: AppFonts.inter,
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppColors.primaryLight,
    decoration: TextDecoration.underline,
  );
}
