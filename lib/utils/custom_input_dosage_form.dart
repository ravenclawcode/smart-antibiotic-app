import 'package:flutter/material.dart';
import 'package:smart_antibiotic/utils/custom_dosage_sheet.dart';

import '../../utils/app_colors.dart';
import '../../utils/app_text.dart';

class CustomInputDosageForm extends StatefulWidget {
  final TextEditingController controller;
  final String initialUnit;
  final ValueChanged<String>? onUnitChanged;

  const CustomInputDosageForm({
    super.key,
    required this.controller,
    this.initialUnit = 'Tablet',
    this.onUnitChanged,
  });

  @override
  State<CustomInputDosageForm> createState() => _CustomInputDosageFormState();
}

class _CustomInputDosageFormState extends State<CustomInputDosageForm> {
  late String _selectedUnit;

  @override
  void initState() {
    super.initState();

    _selectedUnit = widget.initialUnit.isNotEmpty
        ? widget.initialUnit
        : 'Tablet';
  }

  @override
  void didUpdateWidget(covariant CustomInputDosageForm oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.initialUnit != oldWidget.initialUnit &&
        widget.initialUnit.isNotEmpty &&
        widget.initialUnit != _selectedUnit) {
      setState(() {
        _selectedUnit = widget.initialUnit;
      });
    }
  }

  void _showDosageSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return CustomDosageSheet(
          initialUnit: _selectedUnit,
          onSelect: (selectedUnit) {
            setState(() {
              _selectedUnit = selectedUnit;
            });

            widget.onUnitChanged?.call(selectedUnit);
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE7ECF0), width: 1),
      ),
      child: IntrinsicHeight(
        child: Row(
          children: [
            Expanded(
              flex: 4,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 4,
                ),
                child: TextField(
                  controller: widget.controller,
                  maxLines: 1,
                  keyboardType: TextInputType.number,
                  style: AppTextStyles.bodyMedium.copyWith(fontSize: 18),
                  decoration: InputDecoration(
                    hintText: 'Masukkan dosis',
                    hintStyle: AppTextStyles.hint,
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
              ),
            ),
            const VerticalDivider(
              width: 1,
              thickness: 1,
              color: Color(0xFFE7ECF0),
            ),
            Expanded(
              flex: 6,
              child: InkWell(
                focusColor: Colors.transparent,
                hoverColor: Colors.transparent,
                highlightColor: Colors.transparent,
                splashColor: Colors.transparent,
                onTap: _showDosageSheet,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _selectedUnit,
                        style: AppTextStyles.bodyMedium.copyWith(fontSize: 18),
                      ),
                      Icon(
                        Icons.keyboard_arrow_down,
                        size: 18,
                        color: AppColors.textPrimary,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
