import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smart_antibiotic/core/utils/app_colors.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.light(primary: AppColors.primary),
      textTheme: GoogleFonts.nunitoTextTheme(),
    );
  }
}
