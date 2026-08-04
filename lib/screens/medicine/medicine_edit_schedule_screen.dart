import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shimmer/shimmer.dart';

import '../../utils/app_colors.dart';
import '../../utils/app_text.dart';
import '../../utils/custom_medicine_sheet.dart';

class MedicineEditScheduleScreen extends StatefulWidget {
  const MedicineEditScheduleScreen({super.key});

  @override
  State<MedicineEditScheduleScreen> createState() =>
      _MedicineEditScheduleScreenState();
}

class _MedicineEditScheduleScreenState
    extends State<MedicineEditScheduleScreen> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    await Future.delayed(const Duration(milliseconds: 600));
    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

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
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
      child: Scaffold(
        body: Column(
          children: [
            _buildHeader(context, isLoading: _isLoading),
            const SizedBox(height: 20),
            Expanded(
              child: _isLoading
                  ? _buildShimmerContent()
                  : _buildContent(
                      context: context,
                      frequency: frequency,
                      duration: duration,
                      times: timesList,
                      timesPerDay: timesPerDay,
                      medicineData: medicineData,
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget _buildHeader(BuildContext context, {required bool isLoading}) {
  return Container(
    height: 115,
    width: double.infinity,
    color: AppColors.primary,
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: SafeArea(
        bottom: false,
        child: Row(
          children: [
            if (isLoading)
              Shimmer.fromColors(
                baseColor: AppColors.accent,
                highlightColor: AppColors.primary,
                child: Container(
                  width: 36,
                  height: 36,
                  decoration: const BoxDecoration(
                    color: AppColors.accent,
                    shape: BoxShape.circle,
                  ),
                ),
              )
            else
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
            const SizedBox(width: 14),
            if (isLoading)
              Shimmer.fromColors(
                baseColor: AppColors.accent,
                highlightColor: AppColors.primary,
                child: Container(
                  width: 80,
                  height: 22,
                  decoration: BoxDecoration(
                    color: AppColors.accent,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              )
            else
              Text(
                'Jadwal',
                style: AppTextStyles.titleLarge.copyWith(
                  color: AppColors.textWhite,
                ),
              ),
            const Spacer(),
          ],
        ),
      ),
    ),
  );
}

Widget _buildShimmerContent() {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20),
    child: Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: const Color(0xFFE7ECF0)),
          ),
          child: Shimmer.fromColors(
            baseColor: AppColors.surfaceSecondary,
            highlightColor: AppColors.surfaceCool,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 80,
                            height: 18,
                            decoration: BoxDecoration(
                              color: AppColors.surfacePrimary,
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                          const SizedBox(height: 6),
                          Container(
                            width: 110,
                            height: 14,
                            decoration: BoxDecoration(
                              color: AppColors.surfacePrimary,
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                      Container(
                        width: 30,
                        height: 18,
                        decoration: BoxDecoration(
                          color: AppColors.surfacePrimary,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                const Divider(color: Color(0xFFE7ECF0)),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 4,
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 90,
                        height: 16,
                        decoration: BoxDecoration(
                          color: AppColors.surfacePrimary,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      const Spacer(),
                      Container(
                        width: 45,
                        height: 16,
                        decoration: BoxDecoration(
                          color: AppColors.surfacePrimary,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 18),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: const Color(0xFFE7ECF0)),
          ),
          child: Shimmer.fromColors(
            baseColor: AppColors.surfaceSecondary,
            highlightColor: AppColors.surfaceCool,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Container(
                    width: 60,
                    height: 18,
                    decoration: BoxDecoration(
                      color: AppColors.surfacePrimary,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  const Spacer(),
                  Container(
                    width: 90,
                    height: 18,
                    decoration: BoxDecoration(
                      color: AppColors.surfacePrimary,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    ),
  );
}

Widget _buildContent({
  required BuildContext context,
  required String frequency,
  required String duration,
  required List<dynamic> times,
  required int timesPerDay,
  required Map<String, dynamic> medicineData,
}) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20),
    child: Column(
      children: [
        _buildFrequency(
          context: context,
          frequency: frequency,
          times: times,
          timesPerDay: timesPerDay,
        ),
        const SizedBox(height: 18),
        _buildDuration(
          context: context,
          duration: duration,
          medicineData: medicineData,
        ),
      ],
    ),
  );
}

Widget _buildFrequency({
  required BuildContext context,
  required String frequency,
  required List<dynamic> times,
  required int timesPerDay,
}) {
  final List<String> frequencyOptions = [
    '1 kali sehari',
    '2 kali sehari',
    '3 kali sehari',
    'Lebih dari 3 kali sehari',
    'Hari Tertentu',
    'Setiap X Hari',
    'Setiap X Minggu',
    'Setiap X Bulan',
  ];

  int? currentSelectedIndex;
  if (timesPerDay >= 1 && timesPerDay <= 3) {
    currentSelectedIndex = timesPerDay - 1;
  } else if (timesPerDay > 3) {
    currentSelectedIndex = 3;
  }

  return Container(
    padding: const EdgeInsets.symmetric(vertical: 16),
    width: double.infinity,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(14),
      border: Border.all(color: const Color(0xFFE7ECF0)),
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
              const Spacer(),
              InkWell(
                focusColor: Colors.transparent,
                hoverColor: Colors.transparent,
                highlightColor: Colors.transparent,
                splashColor: Colors.transparent,
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    builder: (bottomSheetContext) => CustomMedicineSheet(
                      title: 'Atur Frekuensi',
                      list: frequencyOptions,
                      selectedIndex: currentSelectedIndex,
                      onItemTap: (index) {
                        Navigator.pop(bottomSheetContext);
                      },
                    ),
                  );
                },
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
        const Divider(color: Color(0xFFE7ECF0)),
        const SizedBox(height: 10),
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
                  const Spacer(),
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
  required Map<String, dynamic> medicineData,
}) {
  return Container(
    padding: const EdgeInsets.symmetric(vertical: 16),
    width: double.infinity,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(14),
      border: Border.all(color: const Color(0xFFE7ECF0)),
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
              const Spacer(),
              InkWell(
                focusColor: Colors.transparent,
                hoverColor: Colors.transparent,
                highlightColor: Colors.transparent,
                splashColor: Colors.transparent,
                onTap: () => Navigator.pushNamed(
                  context,
                  '/medicine-edit-duration',
                  arguments: medicineData,
                ),
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
