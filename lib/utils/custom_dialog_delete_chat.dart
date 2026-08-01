import 'package:flutter/material.dart';
import 'package:smart_antibiotic/utils/app_colors.dart';
import 'package:smart_antibiotic/utils/app_text.dart';
import 'package:smart_antibiotic/utils/custom_button_dialog.dart';

class CustomDialogDeleteChat extends StatefulWidget {
  const CustomDialogDeleteChat({super.key});

  @override
  State<CustomDialogDeleteChat> createState() => _CustomDialogDeleteChatState();
}

class _CustomDialogDeleteChatState extends State<CustomDialogDeleteChat> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Material(
          borderRadius: BorderRadius.circular(16),
          clipBehavior: Clip.antiAlias,
          child: Container(
            padding: EdgeInsets.only(top: 20, bottom: 16, left: 20, right: 20),
            decoration: BoxDecoration(color: AppColors.surfacePrimary),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Hapus Percakapan', style: AppTextStyles.titleMedium),
                SizedBox(height: 10),
                Text(
                  'Apakah Anda yakin ingin menghapus semua pesan percakapan ini?',
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontSize: 18,
                    color: AppColors.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20),
                CustomButtonDialog(
                  onTap: () => Navigator.pop(context, true),
                  label: 'Hapus',
                  color: AppColors.primary,
                  textColor: AppColors.textWhite,
                ),
                SizedBox(height: 6),
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
