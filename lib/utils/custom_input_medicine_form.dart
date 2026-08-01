import 'package:flutter/material.dart';
import 'package:smart_antibiotic/utils/app_colors.dart';
import 'package:smart_antibiotic/utils/app_text.dart';

class CustomInputMedicineForm extends StatefulWidget {
  final TextEditingController controller;
  const CustomInputMedicineForm({super.key, required this.controller});

  @override
  State<CustomInputMedicineForm> createState() =>
      _CustomInputMedicineFormState();
}

class _CustomInputMedicineFormState extends State<CustomInputMedicineForm> {
  final List<String> _medicineOptions = ['Amoxicillin', 'Ampicillin'];

  @override
  Widget build(BuildContext context) {
    String? currentValue = _medicineOptions.contains(widget.controller.text)
        ? widget.controller.text
        : null;
    return DropdownButtonFormField<String>(
      initialValue: currentValue,
      items: _medicineOptions.map((String value) {
        return DropdownMenuItem<String>(value: value, child: Text(value));
      }).toList(),
      hint: Text('Pilih obat', style: AppTextStyles.hint),
      style: AppTextStyles.bodyMedium.copyWith(fontSize: 18),
      icon: Icon(Icons.arrow_drop_down, color: AppColors.textPrimary),
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        filled: true,
        fillColor: AppColors.surfaceSecondary,
        hintText: 'Pilih obat',
        errorStyle: AppTextStyles.error,
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(20)),
          borderSide: BorderSide(color: AppColors.surfaceSecondary),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(20)),
          borderSide: BorderSide(color: AppColors.surfaceSecondary),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(20)),
          borderSide: BorderSide(width: 2, color: AppColors.surfaceSecondary),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(20)),
          borderSide: BorderSide(width: 2, color: AppColors.surfaceSecondary),
        ),
      ),
      onChanged: (String? value) {
        setState(() {
          widget.controller.text = value ?? '';
        });
      },
    );
  }
}
