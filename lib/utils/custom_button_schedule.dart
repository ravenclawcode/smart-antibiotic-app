import 'package:flutter/material.dart';
import 'package:smart_antibiotic/utils/app_assets.dart';
import 'package:smart_antibiotic/utils/app_colors.dart';
import 'package:smart_antibiotic/utils/app_text.dart';

class CustomButtonSchedule extends StatelessWidget {
  final VoidCallback? onTap;
  final String label;
  const CustomButtonSchedule({
    super.key,
    required this.onTap,
    required this.label,
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
        width: 230,
        decoration: BoxDecoration(
          color: AppColors.surfaceAccent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(icClock, height: 22, color: AppColors.primary),
            SizedBox(width: 14),
            Text(
              label,
              style: AppTextStyles.bodyLarge.copyWith(color: AppColors.primary),
            ),
          ],
        ),
      ),
    );
  }
}
