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

    final String name = (medicineData['name'] as String?) ?? 'Obat';
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

    final String duration = '$startDateStr - $endDateStr';

    final String dosage = (medicineData['dosage'] as String?) ?? '-';
    final String instruction = (medicineData['instruction'] as String?) ?? '-';

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
      child: Scaffold(
        body: Column(
          children: [
            _buildHeader(context, _deleteMedicine, name),
            SizedBox(height: 20),
            _buildContent(
              context: context,
              frequency: frequency,
              duration: duration,
              dosage: dosage,
              instruction: instruction,
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
) {
  return Container(
    height: 160,
    width: double.infinity,
    decoration: BoxDecoration(color: AppColors.primary),
    child: Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
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
                Spacer(),
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
            SizedBox(height: 12),
            Row(
              children: [
                Text(
                  name,
                  style: AppTextStyles.titleLarge.copyWith(
                    color: AppColors.textWhite,
                  ),
                ),
                SizedBox(width: 20),
                InkWell(
                  focusColor: Colors.transparent,
                  hoverColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  splashColor: Colors.transparent,
                  onTap: () =>
                      Navigator.pushNamed(context, '/medicine-edit-name'),
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
}) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20),
    child: Column(
      children: [
        _buildSchedule(
          context: context,
          frequency: frequency,
          duration: duration,
        ),
        SizedBox(height: 18),
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
                'Jadwal',
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
                    Navigator.pushNamed(context, '/medicine-edit-schedule'),
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
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              Text(
                'Frekuensi',
                style: AppTextStyles.bodyMedium.copyWith(fontSize: 18),
              ),
              SizedBox(width: 38),
              Expanded(
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
        SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              Text(
                'Durasi',
                style: AppTextStyles.bodyMedium.copyWith(fontSize: 18),
              ),
              SizedBox(width: 64),
              Expanded(
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
                'Dosis',
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
        Divider(color: Color(0xFFE7ECF0)),
        SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              Text(
                'Jumlah',
                style: AppTextStyles.bodyMedium.copyWith(fontSize: 18),
              ),
              SizedBox(width: 60),
              Expanded(
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
        SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              Text(
                'Instruksi',
                style: AppTextStyles.bodyMedium.copyWith(fontSize: 18),
              ),
              SizedBox(width: 48),
              Expanded(
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
