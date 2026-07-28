import 'package:flutter/material.dart';
import 'package:smart_antibiotic/utils/app_colors.dart';
import 'package:smart_antibiotic/utils/app_text.dart';

class CustomEditNameForm extends StatefulWidget {
  final TextEditingController controller;

  const CustomEditNameForm({super.key, required this.controller});

  @override
  State<CustomEditNameForm> createState() => _CustomEditNameFormState();
}

class _CustomEditNameFormState extends State<CustomEditNameForm> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      keyboardType: TextInputType.name,
      maxLines: 1,
      textAlign: TextAlign.left,
      cursorColor: AppColors.primary,
      cursorErrorColor: AppColors.primary,
      style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.normal),
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
