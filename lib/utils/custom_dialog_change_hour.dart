import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_text.dart';

class CustomDialogChangeHour extends StatefulWidget {
  final int slotIndex;
  final TimeOfDay initialTime;
  final ValueChanged<TimeOfDay>? onSave;

  const CustomDialogChangeHour({
    super.key,
    this.slotIndex = 0,
    this.initialTime = const TimeOfDay(hour: 8, minute: 0),
    this.onSave,
  });

  @override
  State<CustomDialogChangeHour> createState() => _CustomDialogChangeHourState();
}

class _CustomDialogChangeHourState extends State<CustomDialogChangeHour> {
  late int selectedHour;
  late int selectedMinute;
  late FixedExtentScrollController hourController;
  late FixedExtentScrollController minuteController;

  static const int _kLoopOffset = 1000;

  @override
  void initState() {
    super.initState();
    _initPickerValues(widget.initialTime);
  }

  void _initPickerValues(TimeOfDay time) {
    selectedHour = time.hour;
    final initialMinute = (time.minute / 5).round() * 5;
    selectedMinute = initialMinute % 60;

    final initialHourIndex = (_kLoopOffset * 24) + selectedHour;
    final initialMinuteIndexStep = selectedMinute ~/ 5;
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

  void _handleSave() {
    final newTime = TimeOfDay(hour: selectedHour, minute: selectedMinute);
    if (widget.onSave != null) {
      widget.onSave!(newTime);
    }
    Navigator.pop(context, newTime);
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
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 26),
      child: Material(
        borderRadius: BorderRadius.circular(16),
        clipBehavior: Clip.antiAlias,
        color: AppColors.surfacePrimary,
        child: Container(
          padding: const EdgeInsets.only(
            top: 26,
            bottom: 30,
            left: 26,
            right: 26,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Jadwal Minum Obat',
                style: AppTextStyles.titleLarge,
                textAlign: TextAlign.start,
              ),
              const SizedBox(height: 6),
              Text(
                'Minum ke-${widget.slotIndex + 1}',
                style: AppTextStyles.bodyMedium.copyWith(
                  fontSize: 18,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 20),
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
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  InkWell(
                    focusColor: Colors.transparent,
                    hoverColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    splashColor: Colors.transparent,
                    overlayColor: WidgetStateProperty.all(Colors.transparent),
                    onTap: () => Navigator.pop(context),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      child: Text(
                        'BATAL',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  InkWell(
                    focusColor: Colors.transparent,
                    hoverColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    splashColor: Colors.transparent,
                    overlayColor: WidgetStateProperty.all(Colors.transparent),
                    onTap: _handleSave,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      child: Text(
                        'SIMPAN',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
