import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_text.dart';

class CustomInputFrequencyForm extends StatelessWidget {
  final String? selectedValue;
  final ValueChanged<String?> onChanged;

  const CustomInputFrequencyForm({
    super.key,
    required this.selectedValue,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    const options = ['Harian', 'Mingguan', 'Bulanan'];

    return DropdownButtonFormField<String>(
      initialValue: options.contains(selectedValue) ? selectedValue : null,
      items: options.map((value) {
        return DropdownMenuItem<String>(value: value, child: Text(value));
      }).toList(),
      hint: Text('Pilih frekuensi', style: AppTextStyles.hint),
      style: AppTextStyles.bodyMedium.copyWith(fontSize: 18),
      icon: Icon(Icons.arrow_drop_down, color: AppColors.textPrimary),
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 16,
        ),
        filled: true,
        fillColor: AppColors.surfaceSecondary,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
      ),
      onChanged: onChanged,
    );
  }
}
