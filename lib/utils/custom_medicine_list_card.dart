import 'package:flutter/material.dart';
import 'package:smart_antibiotic/utils/app_colors.dart';
import 'package:smart_antibiotic/utils/app_text.dart';

class CustomMedicineListCard extends StatelessWidget {
  final String title;
  final Widget image;
  final VoidCallback? onTap;

  const CustomMedicineListCard({
    super.key,
    required this.title,
    required this.image,
    required this.onTap,
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
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: AppColors.surfacePrimary,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Padding(padding: const EdgeInsets.all(8), child: image),
            SizedBox(width: 6),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            Spacer(),
            Icon(Icons.arrow_forward_ios_rounded, size: 12),
          ],
        ),
      ),
    );
  }
}
