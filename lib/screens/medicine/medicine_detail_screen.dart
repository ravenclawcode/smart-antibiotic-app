import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:smart_antibiotic/providers/medicine_provider.dart';

import '../../models/medicine_model.dart';
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
  bool _isLoading = true;

  MedicineModel? _medicine;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
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

    _fetchData();
  }

  Future<void> _fetchData() async {
    await Future.delayed(const Duration(milliseconds: 600));

    if (!mounted) {
      return;
    }

    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _editMedicineDuration() async {
    if (_medicine == null) {
      return;
    }

    final result = await Navigator.pushNamed(
      context,
      '/medicine-edit-duration',
      arguments: _medicine,
    );

    if (!mounted) {
      return;
    }

    if (result is MedicineModel) {
      await _saveEditedMedicine(result);
    }
  }

  void _deleteMedicine() async {
    showDialog(
      context: context,
      builder: (dialogContext) => const CustomDialogDeleteMedicine(),
    );
  }

  String _formatDateString(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty) {
      return '-';
    }

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

  String _formatDosage(MedicineModel? medicine) {
    if (medicine == null) {
      return '-';
    }

    final dosage = medicine.dosage?.trim() ?? '';

    final dosageUnit = medicine.dosageUnit?.trim() ?? '';

    if (dosage.isEmpty) {
      return '-';
    }

    if (dosageUnit.isEmpty) {
      return dosage;
    }

    return '$dosage $dosageUnit';
  }

  String _formatFrequency(MedicineModel? medicine) {
    if (medicine == null) {
      return '-';
    }

    final frequencyType = medicine.frequencyType;

    final timesPerDay = medicine.timesPerDay;

    final intervalValue = medicine.intervalValue;

    switch (frequencyType) {
      case 'daily':
        if (timesPerDay <= 0) {
          return '-';
        }

        if (timesPerDay > 3) {
          return 'Lebih dari 3 kali sehari';
        }

        return '$timesPerDay kali sehari';

      case 'certain_days':
        return 'Hari tertentu';

      case 'interval_days':
        if (intervalValue == null || intervalValue <= 0) {
          return 'Setiap beberapa hari';
        }

        return 'Setiap $intervalValue hari';

      case 'interval_weeks':
        if (intervalValue == null || intervalValue <= 0) {
          return 'Setiap beberapa minggu';
        }

        return 'Setiap $intervalValue minggu';

      case 'interval_months':
        if (intervalValue == null || intervalValue <= 0) {
          return 'Setiap beberapa bulan';
        }

        return 'Setiap $intervalValue bulan';

      default:
        return '-';
    }
  }

  String _formatDuration(MedicineModel? medicine) {
    if (medicine == null) {
      return '-';
    }

    final startDate = _formatDateString(medicine.startDate);

    final endDate = _formatDateString(medicine.endDate);

    if (startDate != '-' && endDate != '-') {
      return '$startDate - $endDate';
    }

    if (startDate != '-' && endDate == '-') {
      return '$startDate -';
    }

    if (startDate == '-' && endDate != '-') {
      return '- $endDate';
    }

    return '-';
  }

  Future<void> _saveEditedMedicine(MedicineModel editedMedicine) async {
    if (editedMedicine.id == null) {
      return;
    }

    if (!mounted) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final medicineProvider = context.read<MedicineProvider>();

    final updatedMedicine = await medicineProvider.updateMedicine(
      editedMedicine.id!,
      editedMedicine,
    );

    if (!mounted) {
      return;
    }

    if (updatedMedicine == null) {
      setState(() {
        _isLoading = false;
      });
      return;
    }

    _medicine = updatedMedicine;

    await Future.delayed(const Duration(milliseconds: 600));

    if (!mounted) {
      return;
    }

    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _editMedicineName() async {
    if (_medicine == null) {
      return;
    }

    final result = await Navigator.pushNamed(
      context,
      '/medicine-edit-name',
      arguments: _medicine,
    );

    if (!mounted) {
      return;
    }

    if (result is MedicineModel) {
      await _saveEditedMedicine(result);
    }
  }

  Future<void> _editMedicineSchedule() async {
    if (_medicine == null) {
      return;
    }

    final result = await Navigator.pushNamed(
      context,
      '/medicine-edit-schedule',
      arguments: _medicine,
    );

    if (!mounted) {
      return;
    }

    if (result is MedicineModel) {
      await _saveEditedMedicine(result);
    }
  }

  Future<void> _editMedicineDosage() async {
    if (_medicine == null) {
      return;
    }

    final result = await Navigator.pushNamed(
      context,
      '/medicine-edit-dosage',
      arguments: _medicine,
    );

    if (!mounted) {
      return;
    }

    if (result is MedicineModel) {
      await _saveEditedMedicine(result);
    }
  }

  Future<void> _editMedicineInstruction() async {
    if (_medicine == null) {
      return;
    }

    final result = await Navigator.pushNamed(
      context,
      '/medicine-edit-instruction',
      arguments: _medicine,
    );

    if (!mounted) {
      return;
    }

    if (result is MedicineModel) {
      await _saveEditedMedicine(result);
    }
  }

  @override
  Widget build(BuildContext context) {
    final medicine = _medicine;

    final String rawName = medicine?.name.trim() ?? '';

    final String name = rawName.isNotEmpty ? rawName : '-';

    final String frequency = _formatFrequency(medicine);

    final String duration = _formatDuration(medicine);

    final String dosage = _formatDosage(medicine);

    final String instruction = medicine?.instruction ?? '-';

    final medicineData = medicine?.toJson() ?? <String, dynamic>{};

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
      child: Scaffold(
        body: Column(
          children: [
            _buildHeader(
              context,
              _deleteMedicine,
              name,
              medicineData,
              isLoading: _isLoading,
              onNameEdit: _editMedicineName,
            ),

            const SizedBox(height: 20),

            _isLoading
                ? _buildShimmerContent()
                : _buildContent(
                    context: context,
                    frequency: frequency,
                    duration: duration,
                    dosage: dosage,
                    instruction: instruction,
                    medicineData: medicineData,
                    onDosageEdit: _editMedicineDosage,
                    onInstructionEdit: _editMedicineInstruction,
                    onScheduleEdit: _editMedicineSchedule,
                    onDurationEdit: _editMedicineDuration,
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
  Map<String, dynamic> medicineData, {
  required bool isLoading,
  required VoidCallback onNameEdit,
}) {
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

                const Spacer(),

                if (isLoading)
                  Shimmer.fromColors(
                    baseColor: AppColors.accent,
                    highlightColor: AppColors.primary,
                    child: Container(
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        color: AppColors.accent,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  )
                else
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

            if (isLoading)
              Row(
                children: [
                  Shimmer.fromColors(
                    baseColor: AppColors.accent,
                    highlightColor: AppColors.primary,
                    child: Container(
                      width: 130,
                      height: 24,
                      decoration: BoxDecoration(
                        color: AppColors.accent,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),

                  const SizedBox(width: 20),

                  Shimmer.fromColors(
                    baseColor: AppColors.accent,
                    highlightColor: AppColors.primary,
                    child: Container(
                      width: 18,
                      height: 18,
                      decoration: BoxDecoration(
                        color: AppColors.accent,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                ],
              )
            else
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
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
                    onTap: onNameEdit,
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
                      Container(
                        width: 70,
                        height: 18,
                        decoration: BoxDecoration(
                          color: AppColors.surfacePrimary,
                          borderRadius: BorderRadius.circular(4),
                        ),
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
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 4,
                        child: Container(
                          height: 20,
                          decoration: BoxDecoration(
                            color: AppColors.surfacePrimary,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ),

                      const SizedBox(width: 20),

                      Expanded(
                        flex: 6,
                        child: Container(
                          height: 20,
                          decoration: BoxDecoration(
                            color: AppColors.surfacePrimary,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 4,
                        child: Container(
                          height: 20,
                          decoration: BoxDecoration(
                            color: AppColors.surfacePrimary,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ),

                      const SizedBox(width: 20),

                      Expanded(
                        flex: 6,
                        child: Container(
                          height: 20,
                          decoration: BoxDecoration(
                            color: AppColors.surfacePrimary,
                            borderRadius: BorderRadius.circular(4),
                          ),
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
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      Container(
                        width: 50,
                        height: 18,
                        decoration: BoxDecoration(
                          color: AppColors.surfacePrimary,
                          borderRadius: BorderRadius.circular(4),
                        ),
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
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 4,
                        child: Container(
                          height: 16,
                          decoration: BoxDecoration(
                            color: AppColors.surfacePrimary,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ),

                      const SizedBox(width: 20),

                      Expanded(
                        flex: 6,
                        child: Container(
                          height: 16,
                          decoration: BoxDecoration(
                            color: AppColors.surfacePrimary,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 14),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 4,
                        child: Container(
                          height: 16,
                          decoration: BoxDecoration(
                            color: AppColors.surfacePrimary,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ),

                      const SizedBox(width: 20),

                      Expanded(
                        flex: 6,
                        child: Container(
                          height: 16,
                          decoration: BoxDecoration(
                            color: AppColors.surfacePrimary,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
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
  required String dosage,
  required String instruction,
  required Map<String, dynamic> medicineData,
  required VoidCallback onScheduleEdit,
  required VoidCallback onDosageEdit,
  required VoidCallback onInstructionEdit,
  required VoidCallback onDurationEdit,
}) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20),
    child: Column(
      children: [
        _buildSchedule(
          context: context,
          frequency: frequency,
          duration: duration,
          onEdit: onScheduleEdit,
          onDurationEdit: onDurationEdit,
        ),

        const SizedBox(height: 18),

        _buildDosage(
          context: context,
          dosage: dosage,
          instruction: instruction,
          onEdit: onDosageEdit,
        ),
      ],
    ),
  );
}

Widget _buildSchedule({
  required BuildContext context,
  required String frequency,
  required String duration,
  required VoidCallback onEdit,
  required VoidCallback onDurationEdit,
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
                onTap: onEdit,
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
            crossAxisAlignment: CrossAxisAlignment.center,
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
                    fontSize: 18,
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
            crossAxisAlignment: CrossAxisAlignment.center,
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
                    fontSize: 18,
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
  required VoidCallback onEdit,
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
                onTap: onEdit,
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
            crossAxisAlignment: CrossAxisAlignment.center,
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
                    fontSize: 18,
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
            crossAxisAlignment: CrossAxisAlignment.center,
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
                    fontSize: 18,
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
