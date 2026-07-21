import 'package:flutter/material.dart';
import 'package:smart_antibiotic/core/utils/app_colors.dart';
import 'package:smart_antibiotic/core/utils/app_text.dart';

class CustomButton extends StatelessWidget {
  final VoidCallback? onTap;
  final String label;
  const CustomButton({super.key, required this.onTap, required this.label});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      focusColor: Colors.transparent,
      hoverColor: Colors.transparent,
      highlightColor: Colors.transparent,
      overlayColor: WidgetStateProperty.all(Colors.transparent),
      onTap: onTap,
      child: Container(
        height: 70,
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(40),
        ),
        alignment: Alignment.center,
        child: Text(label, style: AppTextStyles.bodyLarge),
      ),
    );
  }
}
