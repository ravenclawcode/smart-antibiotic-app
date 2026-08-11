import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shimmer/shimmer.dart';

import '../../utils/app_colors.dart';
import '../../utils/app_text.dart';
import '../../utils/custom_button.dart';
import '../../utils/custom_button_off.dart';
import '../../utils/custom_input_dosage_form.dart';

class MedicineEditDoseAmountScreen extends StatefulWidget {
  final ValueChanged<String>? onNameChanged;
  const MedicineEditDoseAmountScreen({super.key, required this.onNameChanged});

  @override
  State<MedicineEditDoseAmountScreen> createState() =>
      _MedicineEditDoseAmountScreenState();
}

class _MedicineEditDoseAmountScreenState
    extends State<MedicineEditDoseAmountScreen> {
  late TextEditingController dosageController;

  String _initialDosage = '';
  bool _isLoading = true;
  bool _isNextEnabled = false;

  @override
  void initState() {
    super.initState();
    dosageController = TextEditingController();
    dosageController.addListener(_checkFormChanges);
    _fetchData();
  }

  Future<void> _fetchData() async {
    await Future.delayed(const Duration(milliseconds: 600));
    if (mounted) {
      setState(() {
        _initialDosage = dosageController.text.trim();
        _isLoading = false;
      });
    }
  }

  void _checkFormChanges() {
    final String currentText = dosageController.text.trim();
    final bool hasInstructionChanged =
        currentText != _initialDosage && currentText.isNotEmpty;

    if (_isNextEnabled != hasInstructionChanged) {
      setState(() {
        _isNextEnabled = hasInstructionChanged;
      });
    }

    if (widget.onNameChanged != null) {
      widget.onNameChanged!(dosageController.text);
    }
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
                  : _buildContent(context, _isNextEnabled, dosageController),
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
  return Align(
    alignment: Alignment.topCenter,
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
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
                    child: Row(
                      children: [
                        Container(
                          height: 18,
                          width: 20,
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
    ),
  );
}

Widget _buildContent(
  BuildContext context,
  bool isNextEnabled,
  TextEditingController dosageController,
) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20),
    child: Column(
      children: [
        CustomInputDosageForm(controller: dosageController),
        const Spacer(),
        _buildActionButton(context, isNextEnabled, dosageController),
      ],
    ),
  );
}

Widget _buildActionButton(
  BuildContext context,
  bool isNextEnabled,
  TextEditingController controller,
) {
  return isNextEnabled
      ? CustomButton(
          onTap: () {
            Navigator.pop(context, controller.text.trim());
          },
          label: 'Simpan Perubahan',
        )
      : const CustomButtonOff(label: 'Simpan Perubahan');
}
