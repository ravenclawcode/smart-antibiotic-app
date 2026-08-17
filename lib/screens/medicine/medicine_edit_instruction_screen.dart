import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shimmer/shimmer.dart';

import '../../models/medicine_model.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_text.dart';
import '../../utils/custom_button.dart';
import '../../utils/custom_button_off.dart';
import '../../utils/custom_input_intruction_form.dart';

class MedicineEditInstructionScreen extends StatefulWidget {
  final ValueChanged<String>? onNameChanged;

  const MedicineEditInstructionScreen({super.key, this.onNameChanged});

  @override
  State<MedicineEditInstructionScreen> createState() =>
      _MedicineEditInstructionScreenState();
}

class _MedicineEditInstructionScreenState
    extends State<MedicineEditInstructionScreen> {
  late TextEditingController instructionController;

  MedicineModel? _medicine;

  String _initialInstruction = '';
  bool _isNextEnabled = false;
  bool _isInitialized = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();

    instructionController = TextEditingController();
    instructionController.addListener(_checkFormChanges);

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
    } else if (arguments is Map<String, dynamic>) {
      _medicine = MedicineModel.fromJson(arguments);
    } else if (arguments is Map) {
      _medicine = MedicineModel.fromJson(Map<String, dynamic>.from(arguments));
    }

    _initialInstruction = _medicine?.instruction ?? '';

    instructionController.text = _initialInstruction;
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
    final String currentText = instructionController.text.trim();
    final String initialText = _initialInstruction.trim();

    final bool hasInstructionChanged = currentText != initialText;

    if (_isNextEnabled != hasInstructionChanged) {
      setState(() {
        _isNextEnabled = hasInstructionChanged;
      });
    }

    if (widget.onNameChanged != null) {
      widget.onNameChanged!(instructionController.text);
    }
  }

  void _saveChanges() {
    final medicine = _medicine;
    if (medicine == null) return;

    final rawText = instructionController.text.trim();

    final formattedInstruction = rawText.isNotEmpty
        ? '${rawText[0].toUpperCase()}${rawText.substring(1)}'
        : rawText;

    final updatedMedicine = medicine.copyWith(
      instruction: formattedInstruction,
    );

    Navigator.pop(context, updatedMedicine);
  }

  @override
  void dispose() {
    instructionController.dispose();
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
                      instructionController,
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
                  width: 90,
                  height: 22,
                  decoration: BoxDecoration(
                    color: AppColors.accent,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              )
            else
              Text(
                'Instruksi',
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
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Shimmer.fromColors(
          baseColor: AppColors.surfaceSecondary,
          highlightColor: AppColors.surfaceCool,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                height: 20,
                decoration: BoxDecoration(
                  color: AppColors.surfacePrimary,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              const SizedBox(height: 8),
              Container(
                width: 220,
                height: 20,
                decoration: BoxDecoration(
                  color: AppColors.surfacePrimary,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        Container(
          width: double.infinity,
          height: 135,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFE7ECF0), width: 1),
          ),
          padding: const EdgeInsets.all(16),
          child: Shimmer.fromColors(
            baseColor: AppColors.surfaceSecondary,
            highlightColor: AppColors.surfaceCool,
            child: Align(
              alignment: Alignment.topLeft,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    height: 16,
                    decoration: BoxDecoration(
                      color: AppColors.surfacePrimary,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    width: 160,
                    height: 16,
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
        const Spacer(),
        Shimmer.fromColors(
          baseColor: AppColors.surfaceSecondary,
          highlightColor: AppColors.surfaceCool,
          child: Container(
            width: double.infinity,
            height: 70,
            decoration: BoxDecoration(
              color: AppColors.surfacePrimary,
              borderRadius: BorderRadius.circular(24),
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
  TextEditingController instructionController,
  VoidCallback onSave,
) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20),
    child: Column(
      children: [
        Text(
          'Tambahkan petunjuk agar obat ini digunakan sesuai anjuran',
          style: AppTextStyles.bodyMedium.copyWith(fontSize: 18),
        ),
        const SizedBox(height: 16),
        CustomInputIntructionForm(controller: instructionController),
        const Spacer(),
        _buildActionButton(
          context,
          isNextEnabled,
          instructionController,
          onSave,
        ),
      ],
    ),
  );
}

Widget _buildActionButton(
  BuildContext context,
  bool isNextEnabled,
  TextEditingController controller,
  VoidCallback onSave,
) {
  return isNextEnabled
      ? CustomButton(onTap: onSave, label: 'Simpan Perubahan')
      : const CustomButtonOff(label: 'Simpan Perubahan');
}
