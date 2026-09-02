import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import '../../models/medicine_model.dart';
import '../../providers/medicine_provider.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_text.dart';
import '../../utils/custom_button.dart';
import '../../utils/custom_button_off.dart';
import '../../utils/custom_input_dosage_form.dart';

class MedicineEditDoseAmountScreen extends StatefulWidget {
  final ValueChanged<String>? onNameChanged;

  const MedicineEditDoseAmountScreen({super.key, this.onNameChanged});

  @override
  State<MedicineEditDoseAmountScreen> createState() =>
      _MedicineEditDoseAmountScreenState();
}

class _MedicineEditDoseAmountScreenState
    extends State<MedicineEditDoseAmountScreen> {
  late TextEditingController dosageController;

  MedicineModel? _medicine;

  int? _medicineId;
  int? _scheduleTimeId;
  String? _scheduledDate;
  bool _isSingleDose = false;

  String _initialDosage = '';
  String _selectedUnit = 'Tablet';

  bool _isLoading = true;
  bool _isNextEnabled = false;
  bool _isInitialized = false;
  bool _isInitializingForm = true;

  @override
  void initState() {
    super.initState();

    dosageController = TextEditingController();
    dosageController.addListener(_checkFormChanges);

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

    if (arguments is MedicineModel) {
      _medicine = arguments;
      _medicineId = arguments.id;
    } else if (arguments is Map) {
      final map = Map<String, dynamic>.from(arguments);
      final medicineData = map['medicine'];

      if (medicineData is MedicineModel) {
        _medicine = medicineData;
      } else if (medicineData is Map) {
        _medicine = MedicineModel.fromJson(
          Map<String, dynamic>.from(medicineData),
        );
      }

      _medicineId = int.tryParse(map['medicineId']?.toString() ?? '');
      _scheduleTimeId = int.tryParse(map['scheduleTimeId']?.toString() ?? '');
      _scheduledDate = map['scheduledDate']?.toString();
    }

    final dosage = _medicine?.dosage?.trim() ?? '';
    final dosageUnit = _medicine?.dosageUnit?.trim() ?? '';

    _initialDosage = dosage;
    _selectedUnit = dosageUnit.isNotEmpty ? dosageUnit : 'Tablet';

    dosageController.text = dosage;

    _isSingleDose =
        _medicineId != null &&
        _scheduleTimeId != null &&
        _scheduledDate != null &&
        _scheduledDate!.trim().isNotEmpty;

    _isInitializingForm = false;
    _isNextEnabled = false;
  }

  Future<void> _fetchData() async {
    await Future.delayed(const Duration(milliseconds: 600));

    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _checkFormChanges() {
    if (_isInitializingForm) {
      return;
    }

    final String currentText = dosageController.text.trim();

    final String initialUnit = _medicine?.dosageUnit?.trim().isNotEmpty == true
        ? _medicine!.dosageUnit!.trim()
        : 'Tablet';

    final bool hasDosageChanged = currentText != _initialDosage;
    final bool hasUnitChanged = _selectedUnit != initialUnit;
    final bool isValid = currentText.isNotEmpty;

    final bool hasChanges = (hasDosageChanged || hasUnitChanged) && isValid;

    if (_isNextEnabled != hasChanges) {
      setState(() {
        _isNextEnabled = hasChanges;
      });
    }

    if (widget.onNameChanged != null) {
      widget.onNameChanged!(dosageController.text);
    }
  }

  void _onUnitChanged(String selectedUnit) {
    setState(() {
      _selectedUnit = selectedUnit;
    });

    _checkFormChanges();
  }

  Future<void> _saveChanges() async {
    final medicine = _medicine;

    if (medicine == null || medicine.id == null) {
      return;
    }

    final provider = context.read<MedicineProvider>();

    if (_isSingleDose) {
      final medicineId = _medicineId;
      final scheduleTimeId = _scheduleTimeId;
      final scheduledDate = _scheduledDate;

      if (medicineId == null ||
          scheduleTimeId == null ||
          scheduledDate == null ||
          scheduledDate.isEmpty) {
        return;
      }

      final success = await provider.updateDose(
        medicineId: medicineId,
        scheduleTimeId: scheduleTimeId,
        scheduledDate: scheduledDate,
        dosage: dosageController.text.trim(),
        dosageUnit: _selectedUnit,
        instruction: medicine.instruction ?? '',
      );

      if (!mounted) {
        return;
      }

      if (!success) {
        return;
      }

      Navigator.pop(context, true);
      return;
    }

    final updatedMedicine = medicine.copyWith(
      dosage: dosageController.text.trim(),
      dosageUnit: _selectedUnit,
    );

    final result = await provider.updateMedicine(medicine.id!, updatedMedicine);

    if (!mounted) {
      return;
    }

    if (result == null) {
      return;
    }

    Navigator.pop(context, result);
  }

  @override
  void dispose() {
    dosageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                      context,
                      _isNextEnabled,
                      dosageController,
                      _selectedUnit,
                      _onUnitChanged,
                      _saveChanges,
                    ),
            ),
            const SizedBox(height: 60),
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
                  width: 120,
                  height: 22,
                  decoration: BoxDecoration(
                    color: AppColors.accent,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              )
            else
              Text(
                'Jumlah Dosis',
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
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFE7ECF0), width: 1),
          ),
          child: IntrinsicHeight(
            child: Row(
              children: [
                Expanded(
                  flex: 4,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 19,
                    ),
                    child: Shimmer.fromColors(
                      baseColor: AppColors.surfaceSecondary,
                      highlightColor: AppColors.surfaceCool,
                      child: Container(
                        height: 18,
                        width: 20,
                        decoration: BoxDecoration(
                          color: AppColors.surfacePrimary,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                  ),
                ),
                const VerticalDivider(
                  width: 1,
                  thickness: 1,
                  color: Color(0xFFE7ECF0),
                ),
                Expanded(
                  flex: 6,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 19,
                    ),
                    child: Shimmer.fromColors(
                      baseColor: AppColors.surfaceSecondary,
                      highlightColor: AppColors.surfaceCool,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            width: 60,
                            height: 18,
                            decoration: BoxDecoration(
                              color: AppColors.surfacePrimary,
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                          Container(
                            width: 14,
                            height: 14,
                            decoration: BoxDecoration(
                              color: AppColors.surfacePrimary,
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const Spacer(),
        Shimmer.fromColors(
          baseColor: AppColors.surfaceSecondary,
          highlightColor: AppColors.surfaceCool,
          child: Container(
            width: double.infinity,
            height: 70,
            decoration: BoxDecoration(
              color: AppColors.surfacePrimary,
              borderRadius: BorderRadius.circular(40),
            ),
          ),
        ),
      ],
    ),
  );
}

Widget _buildContent(
  BuildContext context,
  bool isNextEnabled,
  TextEditingController dosageController,
  String selectedUnit,
  ValueChanged<String> onUnitChanged,
  VoidCallback saveChanges,
) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20),
    child: Column(
      children: [
        CustomInputDosageForm(
          controller: dosageController,
          initialUnit: selectedUnit,
          onUnitChanged: onUnitChanged,
        ),
        const Spacer(),
        _buildActionButton(context, isNextEnabled, saveChanges),
      ],
    ),
  );
}

Widget _buildActionButton(
  BuildContext context,
  bool isNextEnabled,
  VoidCallback saveChanges,
) {
  return isNextEnabled
      ? CustomButton(onTap: saveChanges, label: 'Simpan Perubahan')
      : const CustomButtonOff(label: 'Simpan Perubahan');
}
