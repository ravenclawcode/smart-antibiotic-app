import 'package:flutter/material.dart';
import 'package:smart_antibiotic/utils/app_assets.dart';
import 'package:smart_antibiotic/utils/app_colors.dart';
import 'package:smart_antibiotic/utils/app_text.dart';
import 'package:smart_antibiotic/utils/custom_button_dialog.dart';

class CustomDialogQuitQuiz extends StatefulWidget {
  const CustomDialogQuitQuiz({super.key});

  @override
  State<CustomDialogQuitQuiz> createState() => _CustomDialogQuitQuizState();
}

class _CustomDialogQuitQuizState extends State<CustomDialogQuitQuiz> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 26),
        child: Material(
          borderRadius: BorderRadius.circular(16),
          clipBehavior: Clip.antiAlias,
          child: Container(
            padding: EdgeInsets.only(top: 26, bottom: 20, left: 26, right: 26),
            decoration: BoxDecoration(color: AppColors.surfacePrimary),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(icAlert, height: 120),
                SizedBox(height: 20),
                Text('Keluar Kuis', style: AppTextStyles.titleMedium),
                SizedBox(height: 6),
                Text(
                  'Anda yakin ingin keluar sekarang?',
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontSize: 18,
                    color: AppColors.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20),
                CustomButtonDialog(
                  onTap: () => Navigator.pop(context, true),
                  label: 'Keluar',
                  color: AppColors.surfaceAccent,
                  textColor: AppColors.primary,
                ),
                SizedBox(height: 6),
                CustomButtonDialog(
                  onTap: () => Navigator.pop(context, false),
                  label: 'Lanjut Kuis',
                  color: Colors.transparent,
                  textColor: AppColors.textPrimary,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
