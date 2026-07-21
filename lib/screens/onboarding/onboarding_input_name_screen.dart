import 'package:flutter/material.dart';
import 'package:smart_antibiotic/core/utils/app_colors.dart';
import 'package:smart_antibiotic/core/utils/custom_input_form_name.dart';
import 'package:smart_antibiotic/core/utils/custom_progress_bar_onboarding.dart';

import '../../core/utils/app_text.dart';
import '../../core/utils/custom_button.dart';
import '../../core/utils/custom_button_off.dart';

class OnboardingInputNameScreen extends StatefulWidget {
  const OnboardingInputNameScreen({super.key});

  @override
  State<OnboardingInputNameScreen> createState() =>
      _OnboardingInputNameScreenState();
}

class _OnboardingInputNameScreenState extends State<OnboardingInputNameScreen> {
  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();

  bool get isFormFilled => nameController.text.trim().isNotEmpty;

  @override
  void initState() {
    super.initState();
    nameController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 26),
          child: Column(
            children: [
              SizedBox(height: 14),
              _buildHeader(context),
              SizedBox(height: 40),
              _buildContent(formKey, nameController),
              Spacer(),
              _buildActionButton(context, formKey, isFormFilled),
              SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}

Widget _buildHeader(BuildContext context) {
  return Column(
    children: [
      Row(
        children: [
          InkWell(
            focusColor: Colors.transparent,
            hoverColor: Colors.transparent,
            highlightColor: Colors.transparent,
            onTap: () => Navigator.pop(context),
            child: Padding(
              padding: const EdgeInsets.only(right: 6),
              child: Icon(
                Icons.arrow_back_ios_new_rounded,
                size: 26,
                color: AppColors.primary,
              ),
            ),
          ),
          SizedBox(width: 10),
          Expanded(child: CustomProgressBarOnboarding(value: 0.25)),
        ],
      ),
    ],
  );
}

Widget _buildContent(
  GlobalKey<FormState> formKey,
  TextEditingController nameController,
) {
  return Column(
    children: [
      Text(
        'Siapa nama Anda?',
        style: AppTextStyles.titleLarge,
        textAlign: TextAlign.center,
      ),
      SizedBox(height: 30),
      Form(
        key: formKey,
        child: Column(
          children: [CustomInputFormName(controller: nameController)],
        ),
      ),
    ],
  );
}

Widget _buildActionButton(
  BuildContext context,
  GlobalKey<FormState> formKey,
  bool isFormFilled,
) {
  return isFormFilled
      ? CustomButton(
          onTap: () {
            if (formKey.currentState?.validate() ?? false) {
              Navigator.pushNamed(context, '/lorem-ipsum');
            }
          },
          label: 'Lanjut',
        )
      : CustomButtonOff(label: 'Lanjut');
}
