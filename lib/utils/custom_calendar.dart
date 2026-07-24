import 'package:flutter/material.dart';
import 'package:smart_antibiotic/utils/app_colors.dart';
import 'package:smart_antibiotic/utils/app_text.dart';

class CustomCalendar extends StatelessWidget {
  final DateTime selectedDate;
  final DateTime currentWeekStart;
  final ValueChanged<DateTime> onDateSelected;
  final ValueChanged<DateTime> onWeekChanged;
  final Function(DateTime today, DateTime weekStart) onResetToToday;

  const CustomCalendar({
    super.key,
    required this.selectedDate,
    required this.currentWeekStart,
    required this.onDateSelected,
    required this.onWeekChanged,
    required this.onResetToToday,
  });

  @override
  Widget build(BuildContext context) {
    final DateTime now = DateTime.now();
    final DateTime today = DateTime(now.year, now.month, now.day);
    final DateTime selectedDayOnly = DateTime(
      selectedDate.year,
      selectedDate.month,
      selectedDate.day,
    );

    List<DateTime> weekDays = List.generate(7, (index) {
      return currentWeekStart.add(Duration(days: index));
    });

    final isSelectedBeforeToday = selectedDayOnly.isBefore(today);
    final isSelectedAfterToday = selectedDayOnly.isAfter(today);
    final isTodaySelected = selectedDayOnly.isAtSameMomentAs(today);

    List<String> dayNames = ['Min', 'Sen', 'Sel', 'Rab', 'Kam', 'Jum', 'Sab'];

    return Container(
      padding: EdgeInsets.symmetric(vertical: 12, horizontal: 12),
      decoration: BoxDecoration(
        color: AppColors.surfacePrimary,
        boxShadow: [
          BoxShadow(
            color: Color(0xFF646464).withValues(alpha: 0.10),
            offset: Offset(0, 3),
            blurRadius: 10,
            spreadRadius: 0,
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              InkWell(
                focusColor: Colors.transparent,
                hoverColor: Colors.transparent,
                highlightColor: Colors.transparent,
                splashColor: Colors.transparent,
                onTap: () {
                  onWeekChanged(currentWeekStart.subtract(Duration(days: 7)));
                },
                child: Icon(Icons.chevron_left, size: 20),
              ),
              SizedBox(width: 4),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(7, (index) {
                    final date = weekDays[index];
                    final isSelected =
                        date.year == selectedDate.year &&
                        date.month == selectedDate.month &&
                        date.day == selectedDate.day;

                    return InkWell(
                      focusColor: Colors.transparent,
                      hoverColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      splashColor: Colors.transparent,
                      onTap: () => onDateSelected(date),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            dayNames[index],
                            style: AppTextStyles.bodySmall.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 6),
                          Container(
                            width: 30,
                            height: 30,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? AppColors.primary
                                  : Colors.transparent,
                              shape: BoxShape.circle,
                            ),
                            child: Text(
                              '${date.day}',
                              style: AppTextStyles.bodySmall.copyWith(
                                fontSize: 14,
                                fontWeight: isSelected
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                                color: isSelected
                                    ? AppColors.textWhite
                                    : AppColors.textPrimary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                ),
              ),
              SizedBox(width: 4),
              InkWell(
                focusColor: Colors.transparent,
                hoverColor: Colors.transparent,
                highlightColor: Colors.transparent,
                splashColor: Colors.transparent,
                onTap: () {
                  onWeekChanged(currentWeekStart.add(Duration(days: 7)));
                },
                child: Icon(Icons.chevron_right, size: 20),
              ),
            ],
          ),
          SizedBox(height: 6),
          SizedBox(
            height: 20,
            child: Stack(
              children: [
                if (isTodaySelected)
                  Center(
                    child: Text(
                      'Hari ini, ${selectedDate.day} ${_getMonthName(selectedDate.month)}',
                      style: AppTextStyles.bodyMedium.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                if (isSelectedBeforeToday) ...[
                  Align(
                    alignment: Alignment.centerLeft,
                    child: InkWell(
                      focusColor: Colors.transparent,
                      hoverColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      splashColor: Colors.transparent,
                      onTap: () {
                        final weekStart = now.subtract(
                          Duration(days: now.weekday % 7),
                        );
                        onResetToToday(now, weekStart);
                      },
                      child: Padding(
                        padding: EdgeInsets.only(left: 8),
                        child: Text(
                          'Hari ini »',
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Center(
                    child: Text(
                      _formatDateIndo(selectedDate),
                      style: AppTextStyles.bodyMedium.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
                if (isSelectedAfterToday) ...[
                  Center(
                    child: Text(
                      _formatDateIndo(selectedDate),
                      style: AppTextStyles.bodyMedium.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: InkWell(
                      focusColor: Colors.transparent,
                      hoverColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      splashColor: Colors.transparent,
                      onTap: () {
                        final weekStart = now.subtract(
                          Duration(days: now.weekday % 7),
                        );
                        onResetToToday(now, weekStart);
                      },
                      child: Padding(
                        padding: EdgeInsets.only(right: 8),
                        child: Text(
                          '« Hari ini',
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

String _getMonthName(int month) {
  const months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'Mei',
    'Jun',
    'Jul',
    'Agu',
    'Sep',
    'Okt',
    'Nov',
    'Des',
  ];
  return months[month - 1];
}

String _formatDateIndo(DateTime date) {
  const fullDayNames = ['Sen', 'Sel', 'Rab', 'Kam', 'Jum', 'Sab', 'Min'];

  const months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'Mei',
    'Jun',
    'Jul',
    'Agu',
    'Sep',
    'Okt',
    'Nov',
    'Des',
  ];

  String dayName = fullDayNames[date.weekday - 1];
  String monthName = months[date.month - 1];

  return '$dayName, ${date.day} $monthName';
}
