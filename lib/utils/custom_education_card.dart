import 'package:flutter/material.dart';
import 'package:smart_antibiotic/utils/app_text.dart';

class CustomEducationCard extends StatelessWidget {
  final String title;
  final Widget image;
  final Color colorCard;
  final Color colorText;
  final VoidCallback? onTap;

  const CustomEducationCard({
    super.key,
    required this.title,
    required this.image,
    required this.colorCard,
    required this.colorText,
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
        width: 110,
        height: 155,
        decoration: BoxDecoration(
          color: colorCard,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: AppTextStyles.bodySmall.copyWith(
                fontSize: 14,
                color: colorText,
                fontWeight: FontWeight.bold,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            Spacer(),
            image,
            Spacer(),
          ],
        ),
      ),
    );
  }
}
