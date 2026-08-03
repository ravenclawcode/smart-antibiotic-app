import 'package:flutter/material.dart';
import 'package:smart_antibiotic/utils/app_colors.dart';
import 'package:smart_antibiotic/utils/app_text.dart';
import 'package:smart_antibiotic/utils/custom_base_bottom_sheet.dart';

class CustomMedicineSheet extends StatelessWidget {
  final String? title;
  final List<String> list;
  final int? selectedIndex;
  final Function(int index)? onItemTap;

  const CustomMedicineSheet({
    super.key,
    this.title,
    required this.list,
    this.selectedIndex,
    this.onItemTap,
  });

  @override
  Widget build(BuildContext context) {
    return CustomBaseBottomSheet(
      title: title,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(list.length, (index) {
          final isLastItem = index == list.length - 1;
          final isSelected = index == selectedIndex;

          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                onTap: () {
                  if (onItemTap != null) onItemTap!(index);
                },
                title: Text(
                  list[index],
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontSize: 18,
                    color: isSelected ? AppColors.primary : null,
                  ),
                ),
              ),
              if (!isLastItem)
                const Divider(color: Color(0xFFE7ECF0), height: 1),
            ],
          );
        }),
      ),
    );
  }
}
