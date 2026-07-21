import 'package:flutter/material.dart';
import 'package:smart_antibiotic/core/utils/app_colors.dart';
import 'package:smart_antibiotic/core/utils/app_text.dart';

class CustomInputFormName extends StatefulWidget {
  final TextEditingController controller;

  const CustomInputFormName({super.key, required this.controller});

  @override
  State<CustomInputFormName> createState() => _CustomInputFormNameState();
}

class _CustomInputFormNameState extends State<CustomInputFormName> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      keyboardType: TextInputType.name,
      maxLines: 1,
      textAlign: TextAlign.center,
      cursorColor: AppColors.primary,
      cursorErrorColor: AppColors.primary,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        filled: true,
        fillColor: AppColors.surfaceSecondary,
        hintText: 'Masukkan nama Anda',
        hintStyle: AppTextStyles.hint,
        errorStyle: AppTextStyles.error,
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(20)),
          borderSide: BorderSide(color: AppColors.surfaceSecondary),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(20)),
          borderSide: BorderSide(color: AppColors.surfaceSecondary),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(20)),
          borderSide: BorderSide(width: 2, color: AppColors.surfaceSecondary),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(20)),
          borderSide: BorderSide(width: 2, color: AppColors.surfaceSecondary),
        ),
      ),
      validator: (value) {
        if (value != null && value.trim().length < 3) {
          return 'Nama pengguna minimal 3 karakter';
        }
        return null;
      },
    );
  }
}
