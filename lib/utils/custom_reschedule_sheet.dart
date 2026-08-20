import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smart_antibiotic/utils/app_colors.dart';
import 'package:smart_antibiotic/utils/app_text.dart';
import 'package:smart_antibiotic/utils/custom_base_bottom_sheet.dart';

class CustomRescheduleSheet extends StatefulWidget {
  final TimeOfDay initialTime;

  const CustomRescheduleSheet({super.key, required this.initialTime});

  @override
  State<CustomRescheduleSheet> createState() => _CustomRescheduleSheetState();
}

class _CustomRescheduleSheetState extends State<CustomRescheduleSheet> {
  late int selectedHour;
  late int selectedMinute;
  late FixedExtentScrollController hourController;
  late FixedExtentScrollController minuteController;

  static const int _kLoopOffset = 1000;

  @override
  void initState() {
    super.initState();
    selectedHour = widget.initialTime.hour;

    final initialMinute = (widget.initialTime.minute / 5).round() * 5;
    selectedMinute = initialMinute % 60;

    final initialMinuteIndexStep = selectedMinute ~/ 5;

    final initialHourIndex = (_kLoopOffset * 24) + selectedHour;
    final initialMinuteIndex = (_kLoopOffset * 12) + initialMinuteIndexStep;

    hourController = FixedExtentScrollController(initialItem: initialHourIndex);
    minuteController = FixedExtentScrollController(
      initialItem: initialMinuteIndex,
    );
  }

  @override
  void dispose() {
    hourController.dispose();
    minuteController.dispose();
    super.dispose();
  }

  Widget _buildSelectionOverlay() {
    return Container(
      decoration: const BoxDecoration(
        border: Border(
          top: BorderSide(color: Color(0xFFE7ECF0), width: 1),
          bottom: BorderSide(color: Color(0xFFE7ECF0), width: 1),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CustomBaseBottomSheet(
      title: 'Jadwalkan ulang pada',
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
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
                    scrollController: hourController,
                    onSelectedItemChanged: (index) {
                      setState(() {
                        selectedHour = index % 24;
                      });
                    },
                    childCount: null,
                    itemBuilder: (context, index) {
                      final hour = index % 24;
                      final isSelected = selectedHour == hour;
                      return Center(
                        child: AnimatedDefaultTextStyle(
                          duration: const Duration(milliseconds: 200),
                          curve: Curves.easeOut,
                          style: AppTextStyles.titleLarge.copyWith(
                            fontWeight: FontWeight.bold,
                            color: isSelected
                                ? AppColors.textPrimary
                                : const Color(0xFFCFD8E0),
                          ),
                          child: Text('$hour'.padLeft(2, '0')),
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Text(
                    ':',
                    style: AppTextStyles.titleLarge.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(
                  width: 50,
                  child: CupertinoPicker.builder(
                    itemExtent: 50,
                    diameterRatio: 10000,
                    squeeze: 1.0,
                    magnification: 1.0,
                    useMagnifier: false,
                    selectionOverlay: _buildSelectionOverlay(),
                    scrollController: minuteController,
                    onSelectedItemChanged: (index) {
                      setState(() {
                        selectedMinute = (index % 12) * 5;
                      });
                    },
                    childCount: null,
                    itemBuilder: (context, index) {
                      final minute = (index % 12) * 5;
                      final isSelected = selectedMinute == minute;
                      return Center(
                        child: AnimatedDefaultTextStyle(
                          duration: const Duration(milliseconds: 200),
                          curve: Curves.easeOut,
                          style: AppTextStyles.titleLarge.copyWith(
                            fontWeight: FontWeight.bold,
                            color: isSelected
                                ? AppColors.textPrimary
                                : const Color(0xFFCFD8E0),
                          ),
                          child: Text('$minute'.padLeft(2, '0')),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.only(bottom: 16, right: 18),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                InkWell(
                  focusColor: Colors.transparent,
                  hoverColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  splashColor: Colors.transparent,
                  onTap: () => Navigator.pop(context),
                  child: Text(
                    'BATAL',
                    style: AppTextStyles.bodySmall.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                ),
                const SizedBox(width: 24),
                InkWell(
                  focusColor: Colors.transparent,
                  hoverColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  splashColor: Colors.transparent,
                  onTap: () {
                    Navigator.pop(
                      context,
                      TimeOfDay(hour: selectedHour, minute: selectedMinute),
                    );
                  },
                  child: Text(
                    'SIMPAN',
                    style: AppTextStyles.bodySmall.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
