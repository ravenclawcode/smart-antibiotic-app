import 'package:flutter/material.dart';
import 'package:smart_antibiotic/utils/app_assets.dart';
import 'package:smart_antibiotic/utils/app_colors.dart';
import 'package:smart_antibiotic/utils/app_text.dart';
import 'package:smart_antibiotic/utils/custom_button_dialog.dart';

class CustomDialogDeleteFeedback extends StatefulWidget {
  const CustomDialogDeleteFeedback({super.key});

  @override
  State<CustomDialogDeleteFeedback> createState() =>
      _CustomDialogDeleteFeedbackState();
}

class _CustomDialogDeleteFeedbackState
    extends State<CustomDialogDeleteFeedback> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 26),
        child: Material(
          borderRadius: BorderRadius.circular(16),
          clipBehavior: Clip.antiAlias,
          child: Container(
            padding: const EdgeInsets.only(
              top: 26,
              bottom: 20,
              left: 26,
              right: 26,
            ),
            decoration: const BoxDecoration(color: AppColors.surfacePrimary),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(icAlert, height: 120),
                const SizedBox(height: 20),
                Text(
                  'Hapus Komentar & Masukan',
                  style: AppTextStyles.titleMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 6),
                Text(
                  'Anda yakin ingin menghapus komentar dan masukan ini?',
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontSize: 18,
                    color: AppColors.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                CustomButtonDialog(
                  onTap: () => Navigator.pop(context, true),
                  label: 'Hapus',
                  color: AppColors.surfaceAccent,
                  textColor: AppColors.primary,
                ),
                const SizedBox(height: 6),
                CustomButtonDialog(
                  onTap: () => Navigator.pop(context, false),
                  label: 'Batal',
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
