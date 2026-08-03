import 'package:flutter/material.dart';
import 'package:smart_antibiotic/utils/custom_dosage_sheet.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_text.dart';

class CustomInputDosageForm extends StatelessWidget {
  final TextEditingController controller;

  const CustomInputDosageForm({super.key, required this.controller});

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
              flex: 3,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 4,
                ),
                child: TextField(
                  controller: controller,
                  maxLines: 1,
                  keyboardType: TextInputType.number,
                  style: AppTextStyles.bodyMedium.copyWith(fontSize: 18),
                  decoration: InputDecoration(
                    hintText: '1',
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
              flex: 7,
              child: InkWell(
                focusColor: Colors.transparent,
                hoverColor: Colors.transparent,
                highlightColor: Colors.transparent,
                splashColor: Colors.transparent,
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    builder: (context) => CustomDosageSheet(
                      initialUnit: 'Tablet',
                      onSelect: (selectedUnit) {},
                    ),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Tablet',
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
