import 'package:flutter/material.dart';
import 'package:smart_antibiotic/utils/app_assets.dart';
import 'package:smart_antibiotic/utils/app_colors.dart';
import 'package:smart_antibiotic/utils/app_text.dart';

class CustomSearchBar extends StatefulWidget {
  final TextEditingController controller;
  final Function(String)? onChanged;

  const CustomSearchBar({super.key, required this.controller, this.onChanged});

  @override
  State<CustomSearchBar> createState() => _CustomSearchBarState();
}

class _CustomSearchBarState extends State<CustomSearchBar> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      onChanged: widget.onChanged,
      keyboardType: TextInputType.text,
      style: AppTextStyles.bodyMedium,
      maxLines: 1,
      cursorColor: AppColors.primary,
      cursorErrorColor: AppColors.primary,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
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
        prefixIconConstraints: BoxConstraints(minWidth: 30),
        hintText: 'Cari antibiotik...',
        hintStyle: AppTextStyles.hint,
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(30)),
          borderSide: BorderSide(color: AppColors.surfacePrimary),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(30)),
          borderSide: BorderSide(color: AppColors.surfacePrimary),
        ),
      ),
      validator: (value) {
        return null;
      },
    );
  }
}
