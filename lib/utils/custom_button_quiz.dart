import 'package:flutter/material.dart';
import 'package:smart_antibiotic/utils/app_text.dart';

class CustomButtonQuiz extends StatelessWidget {
  final VoidCallback? onTap;
  final String label;
  final Color colorText;
  final Color colorBg;
  final Color colorBorder;
  const CustomButtonQuiz({
    super.key,
    required this.onTap,
    required this.label,
    required this.colorText,
    required this.colorBg,
    required this.colorBorder,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      focusColor: Colors.transparent,
      hoverColor: Colors.transparent,
      highlightColor: Colors.transparent,
      overlayColor: WidgetStateProperty.all(Colors.transparent),
      onTap: onTap,
      child: Container(
        height: 50,
        width: double.infinity,
        decoration: BoxDecoration(
          color: colorBg,
          border: Border.all(color: colorBorder, width: 1.5),
          borderRadius: BorderRadius.circular(40),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: AppTextStyles.bodyLarge.copyWith(color: colorText),
        ),
      ),
    );
  }
}
