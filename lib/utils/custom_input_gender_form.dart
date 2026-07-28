import 'package:flutter/material.dart';
import 'package:smart_antibiotic/utils/app_colors.dart';
import 'package:smart_antibiotic/utils/app_text.dart';

class CustomInputGenderForm extends StatefulWidget {
  final TextEditingController controller;
  const CustomInputGenderForm({super.key, required this.controller});

  @override
  State<CustomInputGenderForm> createState() => _CustomInputGenderFormState();
}

class _CustomInputGenderFormState extends State<CustomInputGenderForm> {
  final List<String> _genderOptions = ['Laki-laki', 'Perempuan'];

  @override
  Widget build(BuildContext context) {
    String? currentValue = _genderOptions.contains(widget.controller.text)
        ? widget.controller.text
        : null;
    return DropdownButtonFormField<String>(
      initialValue: currentValue,
      items: _genderOptions.map((String value) {
        return DropdownMenuItem<String>(value: value, child: Text(value));
      }).toList(),
      hint: Text('Pilih jenis kelamin', style: AppTextStyles.hint),
      style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.normal),
      icon: Icon(Icons.arrow_drop_down, color: AppColors.textPrimary),
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        filled: true,
        fillColor: AppColors.surfaceSecondary,
        hintText: 'Pilih jenis kelamin',
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
