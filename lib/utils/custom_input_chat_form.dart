import 'package:flutter/material.dart';
import 'package:smart_antibiotic/utils/app_colors.dart';
import 'package:smart_antibiotic/utils/app_text.dart';

class CustomInputChatForm extends StatefulWidget {
  final TextEditingController controller;

  const CustomInputChatForm({super.key, required this.controller});

  @override
  State<CustomInputChatForm> createState() => _CustomInputChatFormState();
}

class _CustomInputChatFormState extends State<CustomInputChatForm> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      keyboardType: TextInputType.multiline,
      minLines: 1,
      maxLines: 4,
      textAlign: TextAlign.left,
      cursorColor: AppColors.primary,
      cursorErrorColor: AppColors.primary,
      autofocus: false,
      style: AppTextStyles.bodyMedium.copyWith(fontSize: 18),
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        filled: true,
        fillColor: AppColors.surfaceSecondary,
        hintText: 'Tuliskan pesan Anda...',
        hintStyle: AppTextStyles.hint,
        errorStyle: AppTextStyles.error,
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          borderSide: BorderSide(color: AppColors.surfaceSecondary),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          borderSide: BorderSide(color: AppColors.surfaceSecondary),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          borderSide: BorderSide(width: 2, color: AppColors.surfaceSecondary),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          borderSide: BorderSide(width: 2, color: AppColors.surfaceSecondary),
        ),
      ),
    );
  }
}
