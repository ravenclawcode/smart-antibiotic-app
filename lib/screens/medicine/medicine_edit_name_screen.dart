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
import '../../utils/custom_input_add_medicine_form.dart';

class MedicineEditNameScreen extends StatefulWidget {
  const MedicineEditNameScreen({super.key});

  @override
  State<MedicineEditNameScreen> createState() => _MedicineEditNameScreenState();
}

class _MedicineEditNameScreenState extends State<MedicineEditNameScreen> {
  late final TextEditingController _nameMedicineController;

  MedicineModel? _medicine;

  String _initialMedicineName = '';

  bool _isNextEnabled = false;
  bool _isInitialized = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();

    _nameMedicineController = TextEditingController();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_isInitialized) {
      return;
    }

    final arguments = ModalRoute.of(context)?.settings.arguments;

    if (arguments is MedicineModel) {
      _medicine = arguments;
    } else if (arguments is Map<String, dynamic>) {
      _medicine = _medicineFromMap(arguments);
    }

    if (_medicine != null) {
      _initialMedicineName = _medicine!.name.trim();

      _nameMedicineController.text = _initialMedicineName;

      _nameMedicineController.addListener(_checkFormChanges);
    }

    _isInitialized = true;

    _fetchData();
  }

  MedicineModel? _medicineFromMap(Map<String, dynamic> data) {
    try {
      return MedicineModel.fromJson(data);
    } catch (_) {
      return null;
    }
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

  void _checkFormChanges() {
    if (!mounted) {
      return;
    }

    final currentText = _nameMedicineController.text.trim();

    final hasNameChanged =
        currentText.isNotEmpty && currentText != _initialMedicineName;

    if (_isNextEnabled != hasNameChanged) {
      setState(() {
        _isNextEnabled = hasNameChanged;
      });
    }
  }

  Future<void> _saveName() async {
    if (_medicine == null) {
      _showError('Data obat tidak ditemukan.');
      return;
    }

    final medicineId = _medicine!.id;

    if (medicineId == null) {
      _showError('ID obat tidak ditemukan.');
      return;
    }

    final newName = _nameMedicineController.text.trim();

    if (newName.isEmpty) {
      _showError('Nama obat tidak boleh kosong.');
      return;
    }

    if (newName == _initialMedicineName) {
      return;
    }

    final updatedMedicine = _medicine!.copyWith(name: newName);

    final provider = context.read<MedicineProvider>();

    final result = await provider.updateMedicine(medicineId, updatedMedicine);

    if (!mounted) {
      return;
    }

    if (result != null) {
      Navigator.pop(context, result);
      return;
    }

    _showError(provider.errorMessage ?? 'Gagal memperbarui nama obat.');
  }

  void _showError(String message) {
    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  void dispose() {
    _nameMedicineController.removeListener(_checkFormChanges);
    _nameMedicineController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isSaving = context.watch<MedicineProvider>().isSaving;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
      child: Scaffold(
        body: Column(
          children: [
            _buildHeader(context, isLoading: _isLoading, isSaving: isSaving),
            const SizedBox(height: 20),
            Expanded(
              child: _isLoading
                  ? _buildShimmerContent()
                  : _buildContent(
                      context: context,
                      isNextEnabled: _isNextEnabled,
                      controller: _nameMedicineController,
                      isSaving: isSaving,
                      onSave: _saveName,
                    ),
            ),
            const SizedBox(height: 60),
          ],
        ),
      ),
    );
  }
}

Widget _buildHeader(
  BuildContext context, {
  required bool isLoading,
  required bool isSaving,
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
                onTap: isSaving
                    ? null
                    : () {
                        Navigator.pop(context);
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
                  width: 130,
                  height: 22,
                  decoration: BoxDecoration(
                    color: AppColors.accent,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              )
            else
              Text(
                'Nama Obat',
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
  return Shimmer.fromColors(
    baseColor: AppColors.surfaceSecondary,
    highlightColor: AppColors.surfaceCool,
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          Container(
            height: 56,
            width: double.infinity,
            decoration: BoxDecoration(
              color: AppColors.surfacePrimary,
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          const Spacer(),
          Container(
            height: 70,
            width: double.infinity,
            decoration: BoxDecoration(
              color: AppColors.surfacePrimary,
              borderRadius: BorderRadius.circular(24),
            ),
          ),
        ],
      ),
    ),
  );
}

Widget _buildContent({
  required BuildContext context,
  required bool isNextEnabled,
  required TextEditingController controller,
  required bool isSaving,
  required VoidCallback onSave,
}) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20),
    child: Column(
      children: [
        CustomInputAddMedicineForm(controller: controller),
        const Spacer(),
        _buildActionButton(
          context: context,
          isNextEnabled: isNextEnabled,
          onSave: onSave,
        ),
      ],
    ),
  );
}

Widget _buildActionButton({
  required BuildContext context,
  required bool isNextEnabled,
  required VoidCallback onSave,
}) {
  if (!isNextEnabled) {
    return const CustomButtonOff(label: 'Simpan Perubahan');
  }

  return CustomButton(onTap: onSave, label: 'Simpan Perubahan');
}
