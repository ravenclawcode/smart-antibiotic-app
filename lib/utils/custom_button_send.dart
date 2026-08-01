import 'package:flutter/material.dart';
import 'package:smart_antibiotic/utils/app_colors.dart';

class CustomButtonSend extends StatelessWidget {
  final VoidCallback? onTap;
  final String icon;
  final Color color;
  const CustomButtonSend({
    super.key,
    required this.onTap,
    required this.icon,
    required this.color,
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
        width: 60,
        height: 56,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(10),
        ),
        padding: EdgeInsets.symmetric(horizontal: 14),
        child: Image.asset(icon, color: AppColors.textWhite),
      ),
    );
  }
}
