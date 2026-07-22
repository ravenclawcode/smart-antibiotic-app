import 'package:flutter/material.dart';
import 'package:smart_antibiotic/core/utils/app_colors.dart';

class CustomCheckbox extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;

  const CustomCheckbox({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onChanged(!value),
      child: Container(
        width: 24,
        height: 24,
        decoration: BoxDecoration(
          color: value ? AppColors.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: AppColors.primary, width: 2),
        ),
        child: value
            ? Icon(
                Icons.check_rounded,
                size: 20,
                color: AppColors.surfacePrimary,
                fontWeight: FontWeight.bold,
              )
            : null,
      ),
    );
  }
}
