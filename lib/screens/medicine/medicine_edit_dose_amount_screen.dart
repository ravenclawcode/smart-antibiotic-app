import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../utils/app_colors.dart';
import '../../utils/app_text.dart';
import '../../utils/custom_input_dosage_form.dart';

class MedicineEditDoseAmountScreen extends StatefulWidget {
  const MedicineEditDoseAmountScreen({super.key});

  @override
  State<MedicineEditDoseAmountScreen> createState() =>
      _MedicineEditDoseAmountScreenState();
}

class _MedicineEditDoseAmountScreenState
    extends State<MedicineEditDoseAmountScreen> {
  late TextEditingController dosageController;

  @override
  void initState() {
    super.initState();
    dosageController = TextEditingController();
  }

  @override
  void dispose() {
    dosageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
            _buildContent(dosageController),
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
              'Jumlah Dosis',
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

Widget _buildContent(TextEditingController dosageController) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20),
    child: CustomInputDosageForm(controller: dosageController),
  );
}
