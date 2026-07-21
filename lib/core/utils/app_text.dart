import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smart_antibiotic/core/utils/app_colors.dart';

class AppTextStyles {
  static TextStyle get titleLarge => GoogleFonts.nunito(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: AppColors.textPrimary,
      );

  static TextStyle get titleMedium => GoogleFonts.nunito(
        fontSize: 22,
        fontWeight: FontWeight.bold,
        color: AppColors.textPrimary,
      );

  static TextStyle get titleSmall => GoogleFonts.nunito(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: AppColors.textPrimary,
      );

  static TextStyle get bodyLarge => GoogleFonts.nunito(
        fontSize: 18,
        color: AppColors.textWhite,
      );

  static TextStyle get bodyMedium => GoogleFonts.nunito(
        fontSize: 16,
        color: AppColors.textPrimary,
      );

  static TextStyle get bodySmall => GoogleFonts.nunito(
        fontSize: 14,
        color: AppColors.textPrimary,
      );

  static TextStyle get labelMedium => GoogleFonts.nunito(
        fontSize: 12,
        color: AppColors.textPrimary,
      );

  static TextStyle get labelSmall => GoogleFonts.nunito(
        fontSize: 10,
        color: AppColors.textPrimary,
      );

  static TextStyle get hint => GoogleFonts.nunito(
        fontSize: 16,
        fontWeight: FontWeight.w300,
        color: AppColors.textMuted,
      );

  static TextStyle get error => GoogleFonts.nunito(
        fontSize: 14,
        fontWeight: FontWeight.w300,
        color: AppColors.error,
      );
}