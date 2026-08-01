import 'package:flutter/material.dart';
import 'package:smart_antibiotic/utils/app_assets.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_text.dart';

class CustomInputFeedbackForm extends StatelessWidget {
  final TextEditingController controller;
  final String userName;
  final VoidCallback onSubmit;

  const CustomInputFeedbackForm({
    super.key,
    required this.controller,
    required this.userName,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE7ECF0), width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: TextField(
              controller: controller,
              maxLines: 5,
              minLines: 4,
              style: AppTextStyles.bodyMedium.copyWith(fontSize: 18),
              decoration: InputDecoration(
                hintText: 'Tulis pertanyaan atau masukanmu disini...',
                hintStyle: AppTextStyles.hint,
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ),
          const Divider(height: 1, thickness: 1, color: Color(0xFFE7ECF0)),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  userName,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textMuted,
                  ),
                ),
                InkWell(
                  focusColor: Colors.transparent,
                  hoverColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  splashColor: Colors.transparent,
                  onTap: onSubmit,
                  child: Container(
                    width: 38,
                    height: 34,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: Image.asset(icSend, color: AppColors.textWhite),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
