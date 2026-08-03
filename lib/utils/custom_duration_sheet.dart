import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smart_antibiotic/utils/app_colors.dart';
import 'package:smart_antibiotic/utils/app_text.dart';
import 'package:smart_antibiotic/utils/custom_base_bottom_sheet.dart';

class CustomDurationSheet extends StatefulWidget {
  final String title;
  final DateTime initialDate;
  final Function(DateTime newDate) onSave;
  final VoidCallback? onDelete;

  const CustomDurationSheet({
    super.key,
    required this.title,
    required this.initialDate,
    required this.onSave,
    this.onDelete,
  });

  @override
  State<CustomDurationSheet> createState() => _CustomDurationSheetState();
}

class _CustomDurationSheetState extends State<CustomDurationSheet> {
  late int selectedDate;
  late int selectedMonth;
  late int selectedYear;

  final List<String> months = [
    'Januari',
    'Februari',
    'Maret',
    'April',
    'Mei',
    'Juni',
    'Juli',
    'Agustus',
    'September',
    'Oktober',
    'November',
    'Desember',
  ];

  late final List<int> years;

  @override
  void initState() {
    super.initState();
    selectedDate = widget.initialDate.day;
    selectedMonth = widget.initialDate.month;
    selectedYear = widget.initialDate.year;

    years = List.generate(16, (index) => 2020 + index);
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

  DateTime _getValidDate() {
    final maxDaysInMonth = DateTime(selectedYear, selectedMonth + 1, 0).day;
    final validDate = selectedDate > maxDaysInMonth
        ? maxDaysInMonth
        : selectedDate;
    return DateTime(selectedYear, selectedMonth, validDate);
  }

  @override
  Widget build(BuildContext context) {
    final yearIndex = years.contains(selectedYear)
        ? years.indexOf(selectedYear)
        : 0;

    return CustomBaseBottomSheet(
      title: widget.title,
      reset: 'HAPUS',
      onResetTap: () {
        if (widget.onDelete != null) widget.onDelete!();
        Navigator.pop(context);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 12),
            SizedBox(
              height: 140,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: CupertinoPicker(
                      itemExtent: 40,
                      diameterRatio: 10000,
                      squeeze: 1.0,
                      magnification: 1.0,
                      useMagnifier: false,
                      selectionOverlay: _buildSelectionOverlay(),
                      scrollController: FixedExtentScrollController(
                        initialItem: selectedDate - 1,
                      ),
                      onSelectedItemChanged: (index) {
                        setState(() {
                          selectedDate = index + 1;
                        });
                      },
                      children: List.generate(31, (i) {
                        final dayVal = i + 1;
                        final isSelected = selectedDate == dayVal;
                        return Center(
                          child: AnimatedDefaultTextStyle(
                            duration: const Duration(milliseconds: 200),
                            curve: Curves.easeOut,
                            style: AppTextStyles.titleMedium.copyWith(
                              fontWeight: FontWeight.bold,
                              color: isSelected
                                  ? AppColors.textPrimary
                                  : const Color(0xFFCFD8E0),
                            ),
                            child: Text('$dayVal'.padLeft(2, '0')),
                          ),
                        );
                      }),
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    flex: 2,
                    child: CupertinoPicker(
                      itemExtent: 40,
                      diameterRatio: 10000,
                      squeeze: 1.0,
                      magnification: 1.0,
                      useMagnifier: false,
                      selectionOverlay: _buildSelectionOverlay(),
                      scrollController: FixedExtentScrollController(
                        initialItem: selectedMonth - 1,
                      ),
                      onSelectedItemChanged: (index) {
                        setState(() {
                          selectedMonth = index + 1;
                        });
                      },
                      children: List.generate(months.length, (i) {
                        final isSelected = selectedMonth == (i + 1);
                        return Center(
                          child: AnimatedDefaultTextStyle(
                            duration: const Duration(milliseconds: 200),
                            curve: Curves.easeOut,
                            style: AppTextStyles.titleMedium.copyWith(
                              fontWeight: FontWeight.bold,
                              color: isSelected
                                  ? AppColors.textPrimary
                                  : const Color(0xFFCFD8E0),
                            ),
                            child: Text(months[i]),
                          ),
                        );
                      }),
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: CupertinoPicker(
                      itemExtent: 40,
                      diameterRatio: 10000,
                      squeeze: 1.0,
                      magnification: 1.0,
                      useMagnifier: false,
                      selectionOverlay: _buildSelectionOverlay(),
                      scrollController: FixedExtentScrollController(
                        initialItem: yearIndex,
                      ),
                      onSelectedItemChanged: (index) {
                        setState(() {
                          selectedYear = years[index];
                        });
                      },
                      children: List.generate(years.length, (i) {
                        final isSelected = selectedYear == years[i];
                        return Center(
                          child: AnimatedDefaultTextStyle(
                            duration: const Duration(milliseconds: 200),
                            curve: Curves.easeOut,
                            style: AppTextStyles.titleMedium.copyWith(
                              fontWeight: FontWeight.bold,
                              color: isSelected
                                  ? AppColors.textPrimary
                                  : const Color(0xFFCFD8E0),
                            ),
                            child: Text('${years[i]}'),
                          ),
                        );
                      }),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 28),
            Row(
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
                    widget.onSave(_getValidDate());
                    Navigator.pop(context);
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
          ],
        ),
      ),
    );
  }
}
