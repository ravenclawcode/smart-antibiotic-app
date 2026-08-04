import 'package:flutter/material.dart';
import 'package:smart_antibiotic/utils/app_assets.dart';
import 'package:smart_antibiotic/utils/app_colors.dart';
import 'package:smart_antibiotic/utils/app_text.dart';

class CustomInputAddMedicineForm extends StatefulWidget {
  final TextEditingController controller;
  final Function(String)? onChanged;

  const CustomInputAddMedicineForm({
    super.key,
    required this.controller,
    this.onChanged,
  });

  @override
  State<CustomInputAddMedicineForm> createState() =>
      _CustomInputAddMedicineFormState();
}

class _CustomInputAddMedicineFormState
    extends State<CustomInputAddMedicineForm> {
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
      keyboardType: TextInputType.text,
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
        prefixIcon: Padding(
          padding: const EdgeInsets.only(left: 16, right: 4),
          child: Image.asset(
            icSearch,
            height: 18,
            width: 18,
            color: AppColors.textMuted,
          ),
        ),
        prefixIconConstraints: const BoxConstraints(minWidth: 30),
        hintText: 'Ketik di sini...',
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
