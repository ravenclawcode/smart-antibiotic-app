import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../utils/app_assets.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_text.dart';
import '../../utils/custom_dialog_delete_medicine.dart';

class MedicineDetailScreen extends StatefulWidget {
  const MedicineDetailScreen({super.key});

  @override
  State<MedicineDetailScreen> createState() => _MedicineDetailScreenState();
}

class _MedicineDetailScreenState extends State<MedicineDetailScreen> {
  void _deleteMedicine() async {
    showDialog(
      context: context,
      builder: (dialogContext) => const CustomDialogDeleteMedicine(),
    );
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

    final String rawName = (medicineData['name'] as String?)?.trim() ?? '';
    final String name = rawName.isNotEmpty ? rawName : '-';

    final int? timesPerDay = medicineData['times_per_day'] as int?;
    final String? rawFreqType = medicineData['frequency_type'] as String?;

    String frequency = '-';
    if (timesPerDay != null) {
      final String frequencyType = rawFreqType == 'daily'
          ? 'Sehari'
          : (rawFreqType ?? 'Sehari');
      frequency = '$timesPerDay kali, $frequencyType';
    }

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

    final String dosage = (medicineData['dosage'] as String?) ?? '-';
    final String instruction = (medicineData['instruction'] as String?) ?? '-';

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
      child: Scaffold(
        body: Column(
          children: [
            _buildHeader(context, _deleteMedicine, name, medicineData),
            const SizedBox(height: 20),
            _buildContent(
              context: context,
              frequency: frequency,
              duration: duration,
              dosage: dosage,
              instruction: instruction,
              medicineData: medicineData,
            ),
          ],
        ),
      ),
    );
  }
}

Widget _buildHeader(
  BuildContext context,
  VoidCallback onDeleteTap,
  String name,
  Map<String, dynamic> medicineData,
) {
  return Container(
    height: 160,
    width: double.infinity,
    decoration: const BoxDecoration(color: AppColors.primary),
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: SafeArea(
        bottom: false,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
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
                const Spacer(),
                InkWell(
                  focusColor: Colors.transparent,
                  hoverColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  splashColor: Colors.transparent,
                  onTap: onDeleteTap,
                  child: Image.asset(
                    icDelete,
                    height: 20,
                    color: AppColors.surfacePrimary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Text(
                  name,
                  style: AppTextStyles.titleLarge.copyWith(
                    color: AppColors.textWhite,
                  ),
                ),
                const SizedBox(width: 20),
                InkWell(
                  focusColor: Colors.transparent,
                  hoverColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  splashColor: Colors.transparent,
                  onTap: () => Navigator.pushNamed(
                    context,
                    '/medicine-edit-name',
                    arguments: medicineData,
                  ),
                  child: Image.asset(
                    icEditPen,
                    height: 18,
                    color: AppColors.surfacePrimary,
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

Widget _buildContent({
  required BuildContext context,
  required String frequency,
  required String duration,
  required String dosage,
  required String instruction,
  required Map<String, dynamic> medicineData,
}) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20),
    child: Column(
      children: [
        _buildSchedule(
          context: context,
          frequency: frequency,
          duration: duration,
          medicineData: medicineData,
        ),
        const SizedBox(height: 18),
        _buildDosage(
          context: context,
          dosage: dosage,
          instruction: instruction,
        ),
      ],
    ),
  );
}

Widget _buildSchedule({
  required BuildContext context,
  required String frequency,
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
                'Jadwal',
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
                  '/medicine-edit-schedule',
                  arguments: medicineData,
                ),
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
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              Expanded(
                flex: 4,
                child: Text(
                  'Frekuensi',
                  style: AppTextStyles.bodyMedium.copyWith(fontSize: 18),
                ),
              ),
              Expanded(
                flex: 6,
                child: Text(
                  frequency,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              Expanded(
                flex: 4,
                child: Text(
                  'Durasi',
                  style: AppTextStyles.bodyMedium.copyWith(fontSize: 18),
                ),
              ),
              Expanded(
                flex: 6,
                child: Text(
                  duration,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
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

Widget _buildDosage({
  required BuildContext context,
  required String dosage,
  required String instruction,
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
                'Dosis',
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
                onTap: () =>
                    Navigator.pushNamed(context, '/medicine-edit-dosage'),
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
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              Expanded(
                flex: 4,
                child: Text(
                  'Jumlah',
                  style: AppTextStyles.bodyMedium.copyWith(fontSize: 18),
                ),
              ),
              Expanded(
                flex: 6,
                child: Text(
                  dosage,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              Expanded(
                flex: 4,
                child: Text(
                  'Instruksi',
                  style: AppTextStyles.bodyMedium.copyWith(fontSize: 18),
                ),
              ),
              Expanded(
                flex: 6,
                child: Text(
                  instruction,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
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
