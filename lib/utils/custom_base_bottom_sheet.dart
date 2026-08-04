import 'package:flutter/material.dart';
import 'package:smart_antibiotic/utils/app_colors.dart';
import 'package:smart_antibiotic/utils/app_text.dart';

class CustomBaseBottomSheet extends StatelessWidget {
  final String? title;
  final String? reset;
  final Widget child;
  final VoidCallback? onResetTap;

  const CustomBaseBottomSheet({
    super.key,
    this.title,
    required this.child,
    this.reset,
    this.onResetTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: AppColors.surfacePrimary,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  height: 4,
                  width: 50,
                  decoration: BoxDecoration(
                    color: AppColors.textPrimary,
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              if (title != null && title!.isNotEmpty) ...[
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        title!,
                        style: AppTextStyles.titleSmall.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    if (reset != null && reset!.isNotEmpty)
                      InkWell(
                        focusColor: Colors.transparent,
                        hoverColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        splashColor: Colors.transparent,
                        onTap: onResetTap,
                        child: Text(
                          reset!,
                          style: AppTextStyles.bodySmall.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 8),
              ],
              child,
            ],
          ),
        ),
      ),
    );
  }
}
