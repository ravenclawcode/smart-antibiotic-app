import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_text.dart';

class MedicineSetScheduleHourScreen extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final TimeOfDay initialValue;
  final String selectedFrequency;
  final ValueChanged<String> onNameChanged;

  const MedicineSetScheduleHourScreen({
    super.key,
    required this.formKey,
    required this.initialValue,
    this.selectedFrequency = '',
    required this.onNameChanged,
  });

  @override
  State<MedicineSetScheduleHourScreen> createState() =>
      _MedicineSetScheduleHourScreenState();
}

class _MedicineSetScheduleHourScreenState
    extends State<MedicineSetScheduleHourScreen> {
  late int selectedHour;
  late int selectedMinute;

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
  void initState() {
    super.initState();
    selectedHour = widget.initialValue.hour;
    selectedMinute = widget.initialValue.minute;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _notifyParent();
    });
  }

  void _notifyParent() {
    final h = selectedHour.toString().padLeft(2, '0');
    final m = selectedMinute.toString().padLeft(2, '0');
    widget.onNameChanged('$h:$m');
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),
          Text(
            'Jadwal Minum Obat',
            style: AppTextStyles.titleLarge,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),
          Text(
            widget.selectedFrequency.isNotEmpty
                ? widget.selectedFrequency
                : '1 kali sehari',
            style: AppTextStyles.bodyMedium.copyWith(
              fontSize: 18,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 40),
          SizedBox(
            height: 120,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 50,
                  child: CupertinoPicker(
                    itemExtent: 50,
                    diameterRatio: 10000,
                    squeeze: 1.0,
                    magnification: 1.0,
                    useMagnifier: false,
                    selectionOverlay: _buildSelectionOverlay(),
                    scrollController: FixedExtentScrollController(
                      initialItem: selectedHour,
                    ),
                    onSelectedItemChanged: (index) {
                      setState(() {
                        selectedHour = index;
                      });
                      _notifyParent();
                    },
                    children: List.generate(24, (i) {
                      final isSelected = selectedHour == i;
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
                          child: Text('$i'.padLeft(2, '0')),
                        ),
                      );
                    }),
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
                  child: CupertinoPicker(
                    itemExtent: 50,
                    diameterRatio: 10000,
                    squeeze: 1.0,
                    magnification: 1.0,
                    useMagnifier: false,
                    selectionOverlay: _buildSelectionOverlay(),
                    scrollController: FixedExtentScrollController(
                      initialItem: selectedMinute,
                    ),
                    onSelectedItemChanged: (index) {
                      setState(() {
                        selectedMinute = index;
                      });
                      _notifyParent();
                    },
                    children: List.generate(60, (i) {
                      final isSelected = selectedMinute == i;
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
                          child: Text('$i'.padLeft(2, '0')),
                        ),
                      );
                    }),
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
