import 'package:flutter/material.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_text.dart';

class CustomMedicineChooseFormatSheet extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final String initialValue;
  final String medicineName;
  final ValueChanged<String> onNameChanged;

  const CustomMedicineChooseFormatSheet({
    super.key,
    required this.formKey,
    required this.initialValue,
    this.medicineName = '',
    required this.onNameChanged,
  });

  @override
  State<CustomMedicineChooseFormatSheet> createState() =>
      _CustomMedicineChooseFormatSheetState();
}

class _CustomMedicineChooseFormatSheetState
    extends State<CustomMedicineChooseFormatSheet> {
  late String _selectedFormat;

  final List<String> formatOptions = ['Tablet', 'Kapsul', 'Kaplet'];

  @override
  void initState() {
    super.initState();
    _selectedFormat = widget.initialValue;
  }

  @override
  void didUpdateWidget(covariant CustomMedicineChooseFormatSheet oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialValue != oldWidget.initialValue) {
      setState(() {
        _selectedFormat = widget.initialValue;
      });
    }
  }

  void _handleFormatSelection(String formatName) {
    setState(() {
      _selectedFormat = formatName;
    });
    widget.onNameChanged(formatName);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),
          Text(
            'Pilih Bentuk Obat',
            style: AppTextStyles.titleLarge,
            textAlign: TextAlign.start,
          ),
          const SizedBox(height: 6),
          Text(
            widget.medicineName.isNotEmpty ? widget.medicineName : 'Obat',
            style: AppTextStyles.bodyMedium.copyWith(
              fontSize: 18,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 16),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(formatOptions.length, (index) {
              final formatName = formatOptions[index];
              final isItemChosen = _selectedFormat == formatName;
              final bool isLastItem = index == formatOptions.length - 1;

              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  InkWell(
                    focusColor: Colors.transparent,
                    hoverColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    splashColor: Colors.transparent,
                    onTap: () => _handleFormatSelection(formatName),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                      ),
                      title: Text(
                        formatName,
                        style: AppTextStyles.bodyMedium.copyWith(
                          fontSize: 18,
                          color: isItemChosen
                              ? AppColors.primary
                              : AppColors.textPrimary,
                          fontWeight: isItemChosen
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                      ),
                      trailing: isItemChosen
                          ? const Icon(
                              Icons.check_rounded,
                              color: AppColors.primary,
                            )
                          : null,
                    ),
                  ),
                  if (!isLastItem)
                    const Divider(color: Color(0xFFE7ECF0), height: 1),
                ],
              );
            }),
          ),
        ],
      ),
    );
  }
}
