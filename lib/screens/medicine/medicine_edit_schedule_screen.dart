import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../utils/app_colors.dart';
import '../../utils/app_text.dart';

class MedicineEditScheduleScreen extends StatefulWidget {
  const MedicineEditScheduleScreen({super.key});

  @override
  State<MedicineEditScheduleScreen> createState() =>
      _MedicineEditScheduleScreenState();
}

class _MedicineEditScheduleScreenState
    extends State<MedicineEditScheduleScreen> {
  String _formatDateString(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty) return '-';
    try {
      final dateTime = DateTime.parse(dateStr);
      final months = [
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
      return '${dateTime.day} ${months[dateTime.month - 1]}';
    } catch (_) {
      return dateStr;
    }
  }

  @override
  Widget build(BuildContext context) {
    final medicineData =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>? ??
        {};

    final int timesPerDay = (medicineData['times_per_day'] as int?) ?? 1;
    final String frequencyType =
        (medicineData['frequency_type'] as String?) == 'daily'
        ? 'Sehari'
        : (medicineData['frequency_type'] as String? ?? 'Sehari');
    final String frequency = '$timesPerDay kali, $frequencyType';

    final String startDateStr = _formatDateString(
      medicineData['start_date'] as String?,
    );
    final String endDateStr = _formatDateString(
      medicineData['end_date'] as String?,
    );

    String duration = '-';
    if (startDateStr != '-' && endDateStr != '-') {
      duration = '$startDateStr - $endDateStr';
    } else if (startDateStr != '-') {
      duration = startDateStr;
    } else if (endDateStr != '-') {
      duration = endDateStr;
    }

    final List<dynamic> timesList =
        (medicineData['times'] as List<dynamic>?) ?? [];

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
      child: Scaffold(
        body: Column(
          children: [
            _buildHeader(context),
            SizedBox(height: 20),
            _buildContent(
              context: context,
              frequency: frequency,
              duration: duration,
              times: timesList,
            ),
          ],
        ),
      ),
    );
  }
}

Widget _buildHeader(BuildContext context) {
  return Container(
    height: 115,
    width: double.infinity,
    color: AppColors.primary,
    child: Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: SafeArea(
        bottom: false,
        child: Row(
          children: [
            InkWell(
              focusColor: Colors.transparent,
              hoverColor: Colors.transparent,
              highlightColor: Colors.transparent,
              splashColor: Colors.transparent,
              onTap: () => Navigator.pop(context),
              child: Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: AppColors.accent,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Icon(
                  Icons.arrow_back_ios_new_rounded,
                  size: 20,
                  color: AppColors.surfacePrimary,
                ),
              ),
            ),
            SizedBox(width: 14),
            Text(
              'Jadwal',
              style: AppTextStyles.titleLarge.copyWith(
                color: AppColors.textWhite,
              ),
            ),
            Spacer(),
          ],
        ),
      ),
    ),
  );
}

Widget _buildContent({
  required BuildContext context,
  required String frequency,
  required String duration,
  required List<dynamic> times,
}) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20),
    child: Column(
      children: [
        _buildFrequency(context: context, frequency: frequency, times: times),
        SizedBox(height: 18),
        _buildDuration(context: context, duration: duration),
      ],
    ),
  );
}

Widget _buildFrequency({
  required BuildContext context,
  required String frequency,
  required List<dynamic> times,
}) {
  return Container(
    padding: EdgeInsets.symmetric(vertical: 16),
    width: double.infinity,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(14),
      border: Border.all(color: Color(0xFFE7ECF0)),
    ),
    child: Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Frekuensi',
                    style: AppTextStyles.titleSmall.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    frequency,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
              Spacer(),
              InkWell(
                focusColor: Colors.transparent,
                hoverColor: Colors.transparent,
                highlightColor: Colors.transparent,
                splashColor: Colors.transparent,
                onTap: () {},
                child: Text(
                  'Edit',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.primary,
                  ),
                ),
              ),
            ],
          ),
        ),
        Divider(color: Color(0xFFE7ECF0)),
        SizedBox(height: 10),
        Column(
          children: List.generate(times.isNotEmpty ? times.length : 1, (index) {
            final timeText = times.isNotEmpty ? times[index].toString() : '-';
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
              child: Row(
                children: [
                  Text(
                    'Minum ke-${index + 1}',
                    style: AppTextStyles.bodyMedium.copyWith(fontSize: 18),
                  ),
                  Spacer(),
                  Text(
                    timeText,
                    style: AppTextStyles.bodyMedium.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
            );
          }),
        ),
      ],
    ),
  );
}

Widget _buildDuration({
  required BuildContext context,
  required String duration,
}) {
  return Container(
    padding: EdgeInsets.symmetric(vertical: 16),
    width: double.infinity,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(14),
      border: Border.all(color: Color(0xFFE7ECF0)),
    ),
    child: Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              Text(
                'Durasi',
                style: AppTextStyles.titleSmall.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Spacer(),
              InkWell(
                focusColor: Colors.transparent,
                hoverColor: Colors.transparent,
                highlightColor: Colors.transparent,
                splashColor: Colors.transparent,
                onTap: () =>
                    Navigator.pushNamed(context, '/medicine-edit-duration'),
                child: Text(
                  duration,
                  style: AppTextStyles.bodyMedium.copyWith(
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
