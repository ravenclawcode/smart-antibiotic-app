import 'package:flutter/material.dart';
import '../../utils/app_text.dart';

class CustomInputIntructionForm extends StatelessWidget {
  final TextEditingController controller;

  const CustomInputIntructionForm({super.key, required this.controller});

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
                hintText: 'Contoh: Jangan dikonsumsi bersama buah jeruk bali',
                hintStyle: AppTextStyles.hint,
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ),
        ],
      ),
    );
  }
}