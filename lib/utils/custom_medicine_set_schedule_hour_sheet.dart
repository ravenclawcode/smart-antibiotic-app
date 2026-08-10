import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_text.dart';
import '../../utils/custom_button.dart';
import '../../utils/custom_progress_bar.dart';

class CustomMedicineSetScheduleHourSheet extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final TimeOfDay initialValue;
  final String selectedFrequency;
  final String? slotLabel;
  final bool isStandaloneRoute;
  final double? progressValue;
  final ValueChanged<String> onNameChanged;

  const CustomMedicineSetScheduleHourSheet({
    super.key,
    required this.formKey,
    required this.initialValue,
    this.selectedFrequency = '',
    this.slotLabel,
    this.isStandaloneRoute = false,
    this.progressValue,
    required this.onNameChanged,
  });

  @override
  State<CustomMedicineSetScheduleHourSheet> createState() =>
      _CustomMedicineSetScheduleHourSheetState();
}

class _CustomMedicineSetScheduleHourSheetState
    extends State<CustomMedicineSetScheduleHourSheet> {
  late int selectedHour;
  late int selectedMinute;
  late FixedExtentScrollController hourController;
  late FixedExtentScrollController minuteController;

  static const int _kLoopOffset = 1000;

  @override
  void initState() {
    super.initState();
    _initPickerValues(widget.initialValue);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _notifyParent();
      }
    });
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
  void didUpdateWidget(covariant CustomMedicineSetScheduleHourSheet oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialValue != oldWidget.initialValue) {
      setState(() {
        _initPickerValues(widget.initialValue);
      });
    }
  }

  @override
  void dispose() {
    hourController.dispose();
    minuteController.dispose();
    super.dispose();
  }

  void _notifyParent() {
    final h = selectedHour.toString().padLeft(2, '0');
    final m = selectedMinute.toString().padLeft(2, '0');
    widget.onNameChanged('$h:$m');
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

  Widget _buildPickerContent() {
    final String subTitleText =
        (widget.slotLabel != null && widget.slotLabel!.isNotEmpty)
        ? widget.slotLabel!
        : (widget.selectedFrequency.isNotEmpty
              ? widget.selectedFrequency
              : '1 kali sehari');

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),
          Text(
            'Jadwal Minum Obat',
            style: AppTextStyles.titleLarge,
            textAlign: TextAlign.start,
          ),
          const SizedBox(height: 6),
          Text(
            subTitleText,
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
                      _notifyParent();
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
                      _notifyParent();
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
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isStandaloneRoute) {
      return Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 26),
            child: Column(
              children: [
                const SizedBox(height: 14),
                Row(
                  children: [
                    InkWell(
                      onTap: () => Navigator.pop(context),
                      child: Padding(
                        padding: const EdgeInsets.only(right: 6),
                        child: Icon(
                          Icons.arrow_back_ios_new_rounded,
                          size: 26,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: CustomProgressBar(
                        value: widget.progressValue ?? 0.5,
                        height: 18,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Expanded(child: _buildPickerContent()),
                CustomButton(
                  onTap: () {
                    Navigator.pop(
                      context,
                      TimeOfDay(hour: selectedHour, minute: selectedMinute),
                    );
                  },
                  label: 'Simpan',
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      );
    }

    return _buildPickerContent();
  }
}
