import 'package:flutter/material.dart';
import 'package:smart_antibiotic/utils/app_text.dart';

class CustomButtonReminder extends StatelessWidget {
  final VoidCallback? onTap;
  final String label;
  final Color colorBg;
  final Color colorText;
  const CustomButtonReminder({
    super.key,
    required this.onTap,
    required this.label,
    required this.colorBg,
    required this.colorText,
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
        height: 70,
        decoration: BoxDecoration(
          color: colorBg,
          borderRadius: BorderRadius.circular(20),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: AppTextStyles.titleSmall.copyWith(color: colorText, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
