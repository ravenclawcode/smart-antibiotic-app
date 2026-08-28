import 'package:flutter/cupertino.dart';
import 'package:smart_antibiotic/utils/app_colors.dart';
import 'package:smart_antibiotic/utils/app_text.dart';
import 'package:smart_antibiotic/utils/custom_base_bottom_sheet.dart';
import 'package:smart_antibiotic/utils/custom_button_sheet.dart';

enum SnoozeUnit { minute, hour }

extension SnoozeUnitExtension on SnoozeUnit {
  String get label => this == SnoozeUnit.minute ? 'menit' : 'jam';
}

class CustomRescheduleReminderSheet extends StatefulWidget {
  final String medicineName;
  final int initialValue;
  final SnoozeUnit initialUnit;
  final Future<void> Function(int value, SnoozeUnit unit) onSave;

  const CustomRescheduleReminderSheet({
    super.key,
    required this.medicineName,
    this.initialValue = 5,
    this.initialUnit = SnoozeUnit.minute,
    required this.onSave,
  });

  @override
  State<CustomRescheduleReminderSheet> createState() =>
      _CustomRescheduleReminderSheetState();
}

class _CustomRescheduleReminderSheetState
    extends State<CustomRescheduleReminderSheet> {
  late int selectedValue;
  late SnoozeUnit selectedUnit;

  late FixedExtentScrollController _valueController;
  late FixedExtentScrollController _unitController;

  final List<int> _values = List.generate(60, (index) => index + 1);
  final List<SnoozeUnit> _units = [SnoozeUnit.minute, SnoozeUnit.hour];

  @override
  void initState() {
    super.initState();
    selectedValue = widget.initialValue;
    selectedUnit = widget.initialUnit;

    final initialValueIndex = _values.indexOf(selectedValue);
    final initialUnitIndex = _units.indexOf(selectedUnit);

    _valueController = FixedExtentScrollController(
      initialItem: initialValueIndex >= 0 ? initialValueIndex : 4,
    );
    _unitController = FixedExtentScrollController(
      initialItem: initialUnitIndex >= 0 ? initialUnitIndex : 0,
    );
  }

  @override
  void dispose() {
    _valueController.dispose();
    _unitController.dispose();
    super.dispose();
  }

  Widget _buildSelectionOverlay() {
    return Container(
      decoration: const BoxDecoration(
        border: Border(
          top: BorderSide(color: Color(0xFFE7ECF0), width: 1.5),
          bottom: BorderSide(color: Color(0xFFE7ECF0), width: 1.5),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CustomBaseBottomSheet(
      title: 'Menjadwalkan ulang untuk',
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 4),
          Text(
            widget.medicineName,
            style: AppTextStyles.labelMedium.copyWith(
              fontSize: 18,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 150,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 50,
                  child: CupertinoPicker.builder(
                    itemExtent: 50,
                    diameterRatio: 10000,
                    squeeze: 1.0,
                    magnification: 1.0,
                    useMagnifier: false,
                    selectionOverlay: _buildSelectionOverlay(),
                    scrollController: _valueController,
                    onSelectedItemChanged: (index) {
                      setState(() {
                        selectedValue = _values[index];
                      });
                    },
                    childCount: _values.length,
                    itemBuilder: (context, index) {
                      final val = _values[index];
                      final isSelected = selectedValue == val;
                      return Center(
                        child: AnimatedDefaultTextStyle(
                          duration: const Duration(milliseconds: 150),
                          curve: Curves.easeOut,
                          style: AppTextStyles.titleLarge.copyWith(
                            fontSize: 22,
                            fontWeight: isSelected
                                ? FontWeight.bold
                                : FontWeight.normal,
                            color: isSelected
                                ? AppColors.textPrimary
                                : const Color(0xFFCFD8E0),
                          ),
                          child: Text('$val'),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 20),
                SizedBox(
                  width: 80,
                  child: CupertinoPicker.builder(
                    itemExtent: 50,
                    diameterRatio: 10000,
                    squeeze: 1.0,
                    magnification: 1.0,
                    useMagnifier: false,
                    selectionOverlay: _buildSelectionOverlay(),
                    scrollController: _unitController,
                    onSelectedItemChanged: (index) {
                      setState(() {
                        selectedUnit = _units[index];
                      });
                    },
                    childCount: _units.length,
                    itemBuilder: (context, index) {
                      final unit = _units[index];
                      final isSelected = selectedUnit == unit;
                      return Center(
                        child: AnimatedDefaultTextStyle(
                          duration: const Duration(milliseconds: 150),
                          curve: Curves.easeOut,
                          style: AppTextStyles.titleLarge.copyWith(
                            fontSize: 22,
                            fontWeight: isSelected
                                ? FontWeight.bold
                                : FontWeight.normal,
                            color: isSelected
                                ? AppColors.textPrimary
                                : const Color(0xFFCFD8E0),
                          ),
                          child: Text(unit.label),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 40),
          CustomButtonSheet(
            onTap: () async {
              await widget.onSave(selectedValue, selectedUnit);

              if (context.mounted) {
                Navigator.pop(context);
              }
            },
            label: 'Menunda selama $selectedValue ${selectedUnit.label}',
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
