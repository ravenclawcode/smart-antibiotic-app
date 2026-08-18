import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shimmer/shimmer.dart';

import '../../models/medicine_model.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_text.dart';
import '../../utils/custom_change_hour_sheet.dart';
import '../../utils/custom_edit_medicine_parent_sheet.dart';

class MedicineEditScheduleScreen extends StatefulWidget {
  const MedicineEditScheduleScreen({super.key});

  @override
  State<MedicineEditScheduleScreen> createState() =>
      _MedicineEditScheduleScreenState();
}

class _MedicineEditScheduleScreenState
    extends State<MedicineEditScheduleScreen> {
  bool _isLoading = true;

  MedicineModel? _medicine;

  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_isInitialized) {
      return;
    }

    _isInitialized = true;

    final arguments = ModalRoute.of(context)?.settings.arguments;

    MedicineModel? medicine;

    if (arguments is MedicineModel) {
      medicine = arguments;
    } else if (arguments is Map<String, dynamic>) {
      medicine = MedicineModel.fromJson(arguments);
    } else if (arguments is Map) {
      medicine = MedicineModel.fromJson(Map<String, dynamic>.from(arguments));
    }

    _medicine = medicine;
  }

  Future<void> _showLoading() async {
    if (!mounted) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    await Future.delayed(const Duration(milliseconds: 600));

    if (!mounted) {
      return;
    }

    setState(() {
      _isLoading = false;
    });
  }

  Map<String, dynamic> _buildMedicineData() {
    if (_medicine == null) {
      return {};
    }

    return _medicine!.toJson();
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

  void _openChangeHourSheet(int index, TimeOfDay initialTime) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return CustomChangeHourSheet(
          slotIndex: index,
          initialTime: initialTime,
          onSave: (newTime) {
            if (_medicine == null) {
              return;
            }

            final currentTimes = List<String>.from(_medicine!.times);

            final formattedTime =
                '${newTime.hour.toString().padLeft(2, '0')}:'
                '${newTime.minute.toString().padLeft(2, '0')}';

            if (index >= currentTimes.length) {
              return;
            }

            currentTimes[index] = formattedTime;

            setState(() {
              _medicine = _medicine!.copyWith(times: currentTimes);
            });
          },
        );
      },
    );
  }

  String _buildFrequencyText(String frequencyType, int timesPerDay) {
    switch (frequencyType) {
      case 'daily':
        return '$timesPerDay kali, Sehari';

      case 'certain_days':
        return 'Hari Tertentu';

      case 'interval_days':
        final interval = _medicine?.intervalValue ?? 1;
        return 'Setiap $interval hari';

      case 'interval_weeks':
        final interval = _medicine?.intervalValue ?? 1;
        return 'Setiap $interval minggu';

      case 'interval_months':
        final interval = _medicine?.intervalValue ?? 1;
        return 'Setiap $interval bulan';

      default:
        return '$timesPerDay kali, Sehari';
    }
  }

  @override
  Widget build(BuildContext context) {
    final medicineData = _buildMedicineData();

    final int timesPerDay =
        (_medicine?.timesPerDay ?? medicineData['times_per_day'] ?? 1) as int;

    final String frequencyType =
        _medicine?.frequencyType ??
        (medicineData['frequency_type'] as String?) ??
        'daily';

    final String frequency = _buildFrequencyText(frequencyType, timesPerDay);

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
      duration = '$startDateStr -';
    } else if (endDateStr != '-') {
      duration = '- $endDateStr';
    }

    final List<dynamic> timesList =
        _medicine?.times ?? (medicineData['times'] as List<dynamic>?) ?? [];

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
      child: Scaffold(
        body: Column(
          children: [
            _buildHeader(context, isLoading: _isLoading, medicine: _medicine),
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
                      onSlotTapped: (index) {
                        TimeOfDay initialTime = const TimeOfDay(
                          hour: 7,
                          minute: 0,
                        );

                        if (index < timesList.length) {
                          final timeParts = timesList[index].toString().split(
                            ':',
                          );

                          if (timeParts.length == 2) {
                            initialTime = TimeOfDay(
                              hour: int.tryParse(timeParts[0]) ?? 7,
                              minute: int.tryParse(timeParts[1]) ?? 0,
                            );
                          }
                        }

                        _openChangeHourSheet(index, initialTime);
                      },
                      medicine: _medicine,
                      onMedicineChanged: (updatedMedicine) {
                        setState(() {
                          _medicine = updatedMedicine;
                        });
                      },
                      onLoading: _showLoading,
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget _buildHeader(
  BuildContext context, {
  required bool isLoading,
  required MedicineModel? medicine,
}) {
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
                onTap: () {
                  Navigator.pop(context, medicine);
                },
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
  required Function(int) onSlotTapped,
  required MedicineModel? medicine,
  required Function(MedicineModel) onMedicineChanged,
  required Future<void> Function() onLoading,
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
          onSlotTapped: onSlotTapped,
          medicine: medicine,
          onMedicineChanged: onMedicineChanged,
        ),
        const SizedBox(height: 18),
        _buildDuration(
          context: context,
          duration: duration,
          medicineData: medicineData,
          medicine: medicine,
          onMedicineChanged: onMedicineChanged,
          onLoading: onLoading,
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
  required Function(int) onSlotTapped,
  required MedicineModel? medicine,
  required Function(MedicineModel) onMedicineChanged,
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
                  if (medicine == null) {
                    return;
                  }

                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    builder: (context) {
                      return FractionallySizedBox(
                        heightFactor: 0.85,
                        child: CustomEditMedicineParentSheet(
                          medicine: medicine,
                          onSave: (updatedMedicine) {
                            onMedicineChanged(updatedMedicine);
                          },
                        ),
                      );
                    },
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

                  InkWell(
                    focusColor: Colors.transparent,
                    hoverColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    splashColor: Colors.transparent,
                    overlayColor: WidgetStateProperty.all(Colors.transparent),
                    onTap: () => onSlotTapped(index),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 2),
                      child: Text(
                        timeText,
                        style: AppTextStyles.bodyMedium.copyWith(
                          fontSize: 18,
                          color: AppColors.primary,
                        ),
                      ),
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
  required MedicineModel? medicine,
  required Function(MedicineModel) onMedicineChanged,
  required Future<void> Function() onLoading,
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

                onTap: () async {
                  if (medicine == null) {
                    return;
                  }

                  final result = await Navigator.pushNamed(
                    context,
                    '/medicine-edit-duration',
                    arguments: medicine,
                  );

                  if (!context.mounted) {
                    return;
                  }

                  if (result is MedicineModel) {
                    onMedicineChanged(result);

                    await onLoading();
                  }
                },

                child: Text(
                  duration,
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontSize: 18,
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
