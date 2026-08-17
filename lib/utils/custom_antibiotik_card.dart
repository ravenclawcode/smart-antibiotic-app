import 'package:flutter/material.dart';
import 'package:smart_antibiotic/utils/app_colors.dart';
import 'package:smart_antibiotic/utils/app_text.dart';

class CustomAntibiotikCard extends StatelessWidget {
  final String title;
  final Widget image;
  final VoidCallback? onTap;

  const CustomAntibiotikCard({
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
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.surfaceSecondary,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: Color(0xFFE0EEFB),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Padding(padding: const EdgeInsets.all(8), child: image),
            ),
            SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTextStyles.bodyMedium.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            SizedBox(width: 10),
            Icon(Icons.arrow_forward_ios_rounded, size: 12),
          ],
        ),
      ),
    );
  }
}
