import 'package:flutter/material.dart';
import 'package:smart_antibiotic/utils/app_colors.dart';
import 'package:smart_antibiotic/utils/app_text.dart';

class CustomAddMedicineForm extends StatefulWidget {
  final TextEditingController controller;
  final TextInputType keyboardType;
  final String? hintText;
  final Function(String)? onChanged;

  const CustomAddMedicineForm({
    super.key,
    required this.controller,
    required this.keyboardType,
    this.hintText,
    this.onChanged,
  });

  @override
  State<CustomAddMedicineForm> createState() => _CustomAddMedicineFormState();
}

class _CustomAddMedicineFormState extends State<CustomAddMedicineForm> {
  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onTextChange);
  }

  void _onTextChange() {
    setState(() {});
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onTextChange);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      onChanged: widget.onChanged,
      keyboardType: widget.keyboardType,
      style: AppTextStyles.bodyMedium.copyWith(fontSize: 18),
      maxLines: 1,
      cursorColor: AppColors.primary,
      cursorErrorColor: AppColors.primary,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 10,
        ),
        filled: true,
        fillColor: AppColors.surfacePrimary,
        prefixIconConstraints: const BoxConstraints(minWidth: 30),
        hintText: widget.hintText,
        hintStyle: AppTextStyles.hint,
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Color(0xFFE7ECF0)),
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Color(0xFFE7ECF0)),
        ),
      ),
      validator: (value) {
        return null;
      },
    );
  }
}
