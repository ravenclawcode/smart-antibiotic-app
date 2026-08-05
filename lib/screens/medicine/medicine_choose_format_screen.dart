import 'package:flutter/material.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_text.dart';

class MedicineChooseFormatScreen extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final String initialValue;
  final String medicineName;
  final ValueChanged<String> onNameChanged;

  const MedicineChooseFormatScreen({
    super.key,
    required this.formKey,
    required this.initialValue,
    this.medicineName = '',
    required this.onNameChanged,
  });

  @override
  State<MedicineChooseFormatScreen> createState() =>
      _MedicineChooseFormatScreenState();
}

class _MedicineChooseFormatScreenState
    extends State<MedicineChooseFormatScreen> {
  late String _selectedFormat;

  final List<String> formatOptions = ['Tablet', 'Kapsul', 'Kaplet'];

  @override
  void initState() {
    super.initState();
    _selectedFormat = widget.initialValue;
  }

  @override
  void didUpdateWidget(covariant MedicineChooseFormatScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialValue != oldWidget.initialValue) {
      _selectedFormat = widget.initialValue;
    }
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
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),
          Text(
            widget.medicineName.isNotEmpty
                ? widget.medicineName
                : 'Amoxicillin',
            style: AppTextStyles.bodyMedium.copyWith(
              fontSize: 18,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 10),
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
                    onTap: () {
                      setState(() {
                        _selectedFormat = formatName;
                      });
                      widget.onNameChanged(formatName);
                    },
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
