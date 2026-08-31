import 'package:flutter/cupertino.dart';
import 'package:smart_antibiotic/utils/app_colors.dart';
import 'package:smart_antibiotic/utils/app_text.dart';
import 'package:smart_antibiotic/utils/custom_base_bottom_sheet.dart';
import 'package:smart_antibiotic/utils/custom_button_sheet.dart';

class CustomRescheduleReminderSheet extends StatefulWidget {
  final String medicineName;
  final int initialMinute;
  final Future<void> Function(int minutes) onSave;

  const CustomRescheduleReminderSheet({
    super.key,
    required this.medicineName,
    this.initialMinute = 5,
    required this.onSave,
  });

  @override
  State<CustomRescheduleReminderSheet> createState() =>
      _CustomRescheduleReminderSheetState();
}

class _CustomRescheduleReminderSheetState
    extends State<CustomRescheduleReminderSheet> {
  late int selectedMinute;
  late FixedExtentScrollController _minuteController;

  static const int _kLoopOffset = 1000;

  @override
  void initState() {
    super.initState();

    final roundedInitial = (widget.initialMinute / 5).round() * 5;
    selectedMinute = roundedInitial == 0
        ? 5
        : (roundedInitial > 60 ? 60 : roundedInitial);

    final initialIndexStep = (selectedMinute ~/ 5) - 1;
    final initialMinuteIndex = (_kLoopOffset * 12) + initialIndexStep;

    _minuteController = FixedExtentScrollController(
      initialItem: initialMinuteIndex,
    );
  }

  @override
  void dispose() {
    _minuteController.dispose();
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
                  width: 60,
                  child: CupertinoPicker.builder(
                    itemExtent: 50,
                    diameterRatio: 10000,
                    squeeze: 1.0,
                    magnification: 1.0,
                    useMagnifier: false,
                    selectionOverlay: _buildSelectionOverlay(),
                    scrollController: _minuteController,
                    onSelectedItemChanged: (index) {
                      setState(() {
                        selectedMinute = ((index % 12) + 1) * 5;
                      });
                    },
                    childCount: null,
                    itemBuilder: (context, index) {
                      final minute = ((index % 12) + 1) * 5;
                      final isSelected = selectedMinute == minute;
                      return Center(
                        child: AnimatedDefaultTextStyle(
                          duration: const Duration(milliseconds: 150),
                          curve: Curves.easeOut,
                          style: AppTextStyles.titleLarge.copyWith(
                            fontSize: 24,
                            fontWeight: isSelected
                                ? FontWeight.bold
                                : FontWeight.normal,
                            color: isSelected
                                ? AppColors.textPrimary
                                : const Color(0xFFCFD8E0),
                          ),
                          child: Text('$minute'),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  'menit',
                  style: AppTextStyles.titleLarge.copyWith(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 40),
          CustomButtonSheet(
            onTap: () async {
              await widget.onSave(selectedMinute);
            },
            label: 'Menunda selama $selectedMinute menit',
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
