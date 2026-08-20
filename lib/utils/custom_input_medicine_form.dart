import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_text.dart';

class CustomInputMedicineForm extends StatelessWidget {
  final List<Map<String, dynamic>> medicines;
  final String? selectedMedicine;
  final ValueChanged<Map<String, dynamic>?> onChanged;

  const CustomInputMedicineForm({
    super.key,
    required this.medicines,
    required this.selectedMedicine,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final currentValue =
        medicines.any(
          (medicine) => medicine['name']?.toString() == selectedMedicine,
        )
        ? selectedMedicine
        : null;

    return DropdownButtonFormField<String>(
      initialValue: currentValue,
      items: medicines.map((medicine) {
        final name = medicine['name']?.toString() ?? '';

        return DropdownMenuItem<String>(value: name, child: Text(name));
      }).toList(),
      hint: Text('Pilih obat', style: AppTextStyles.hint),
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
      onChanged: (value) {
        if (value == null) {
          onChanged(null);
          return;
        }

        final medicine = medicines.firstWhere(
          (item) => item['name']?.toString() == value,
          orElse: () => <String, dynamic>{},
        );

        onChanged(medicine);
      },
    );
  }
}
