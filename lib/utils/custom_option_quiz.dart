import 'package:flutter/material.dart';
import 'package:smart_antibiotic/utils/app_colors.dart';
import 'package:smart_antibiotic/utils/app_text.dart';

class CustomOptionQuiz extends StatelessWidget {
  final String option;
  final String text;
  final Color color;
  final VoidCallback? onTap;

  const CustomOptionQuiz({
    super.key,
    required this.text,
    required this.onTap,
    required this.color,
    required this.option,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      focusColor: Colors.transparent,
      hoverColor: Colors.transparent,
      highlightColor: Colors.transparent,
      splashColor: Colors.transparent,
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Text(
              option,
              style: AppTextStyles.titleSmall.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
            SizedBox(width: 20),
            Expanded(
              child: Text(
                text,
                style: AppTextStyles.bodyMedium.copyWith(fontSize: 17),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
