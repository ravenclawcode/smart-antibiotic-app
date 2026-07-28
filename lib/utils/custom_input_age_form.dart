import 'package:flutter/material.dart';
import 'package:smart_antibiotic/utils/app_colors.dart';
import 'package:smart_antibiotic/utils/app_text.dart';

class CustomInputAgeForm extends StatefulWidget {
  final TextEditingController controller;

  const CustomInputAgeForm({super.key, required this.controller});

  @override
  State<CustomInputAgeForm> createState() => _CustomInputAgeFormState();
}

class _CustomInputAgeFormState extends State<CustomInputAgeForm> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      keyboardType: TextInputType.number,
      maxLines: 1,
      textAlign: TextAlign.left,
      cursorColor: AppColors.primary,
      cursorErrorColor: AppColors.primary,
     style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.normal),
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        filled: true,
        fillColor: AppColors.surfaceSecondary,
        hintText: 'Masukkan umur Anda',
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
    );
  }
}
