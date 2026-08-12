import 'package:flutter/material.dart';
import 'package:smart_antibiotic/utils/app_colors.dart';
import 'package:smart_antibiotic/utils/app_text.dart';

class CustomInputFrequencyForm extends StatefulWidget {
  final TextEditingController controller;
  const CustomInputFrequencyForm({super.key, required this.controller});

  @override
  State<CustomInputFrequencyForm> createState() =>
      _CustomInputFrequencyFormState();
}

class _CustomInputFrequencyFormState extends State<CustomInputFrequencyForm> {
  final List<String> _frequencyOptions = ['Harian', 'Mingguan', 'Bulanan'];

  @override
  Widget build(BuildContext context) {
    String? currentValue = _frequencyOptions.contains(widget.controller.text)
        ? widget.controller.text
        : null;
    return DropdownButtonFormField<String>(
      initialValue: currentValue,
      items: _frequencyOptions.map((String value) {
        return DropdownMenuItem<String>(value: value, child: Text(value));
      }).toList(),
      hint: Text('Pilih frekuensi', style: AppTextStyles.hint),
      style: AppTextStyles.bodyMedium.copyWith(fontSize: 18),
      icon: Icon(Icons.arrow_drop_down, color: AppColors.textPrimary),
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        filled: true,
        fillColor: AppColors.surfaceSecondary,
        hintText: 'Pilih frekuensi',
        errorStyle: AppTextStyles.error,
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)),
          borderSide: BorderSide(color: AppColors.surfaceSecondary),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)),
          borderSide: BorderSide(color: AppColors.surfaceSecondary),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)),
          borderSide: BorderSide(width: 2, color: AppColors.surfaceSecondary),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)),
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
