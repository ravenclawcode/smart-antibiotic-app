import 'package:flutter/material.dart';
import 'package:smart_antibiotic/utils/app_colors.dart';
import 'package:smart_antibiotic/utils/app_text.dart';

class CustomHistoryCard extends StatelessWidget {
  final String time;
  final Widget image;
  final String name;
  final String dosage;
  final bool isTaken;
  final bool isSkipped;
  final bool isMissed;
  final bool isReschedule;
  final Widget imgStatus;
  final String? statusText;

  const CustomHistoryCard({
    super.key,
    required this.time,
    required this.image,
    required this.name,
    required this.dosage,
    required this.isTaken,
    required this.isSkipped,
    required this.isMissed,
    required this.isReschedule,
    required this.imgStatus,
    this.statusText,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14, vertical: 16),
      decoration: BoxDecoration(
        color: AppColors.surfaceSecondary,
        borderRadius: BorderRadius.circular(16),
      ),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: Text(
                time,
                style: AppTextStyles.bodyMedium.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(width: 10),
            VerticalDivider(width: 1, color: AppColors.border),
            SizedBox(width: 10),
            Center(
              child: Stack(
                children: [
                  Padding(
                    padding: (isTaken || isSkipped || isMissed || isReschedule)
                        ? const EdgeInsets.only(top: 14, right: 4)
                        : const EdgeInsets.only(left: 2, right: 2),
                    child: image,
                  ),
                  Positioned(top: 0, right: 0, child: imgStatus),
                ],
              ),
            ),
            SizedBox(width: 10),
            VerticalDivider(width: 1, color: AppColors.border),
            SizedBox(width: 10),
            Expanded(
              flex: 5,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    name,
                    style: AppTextStyles.bodyMedium.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    dosage,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: 10),
            if (statusText != null) ...[
              Expanded(
                flex: 4,
                child: Text(
                  statusText!,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: isTaken
                        ? AppColors.success
                        : isMissed
                        ? AppColors.error
                        : isReschedule
                        ? AppColors.primary
                        : AppColors.textSecondary,
                  ),
                  maxLines: 2,
                  textAlign: TextAlign.right,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
