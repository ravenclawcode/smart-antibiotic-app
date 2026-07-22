import 'package:flutter/material.dart';
import 'package:smart_antibiotic/core/utils/app_assets.dart';

import '../../core/utils/app_colors.dart';
import '../../core/utils/app_text.dart';
import '../../core/utils/custom_button.dart';
import '../../core/utils/custom_button_off.dart';
import '../../core/utils/custom_checkbox.dart';
import '../../core/utils/custom_progress_bar_onboarding.dart';

class OnboardingReminderTypeScreen extends StatefulWidget {
  const OnboardingReminderTypeScreen({super.key});

  @override
  State<OnboardingReminderTypeScreen> createState() =>
      _OnboardingReminderTypeScreenState();
}

class _OnboardingReminderTypeScreenState
    extends State<OnboardingReminderTypeScreen> {
  late final TextEditingController reminderTypeController;

  bool get isCheck => reminderTypeController.text.isNotEmpty;

  void selectType(String type) {
    setState(() {
      if (reminderTypeController.text == type) {
        reminderTypeController.clear();
      } else {
        reminderTypeController.text = type;
      }
    });
  }

  @override
  void initState() {
    super.initState();
    reminderTypeController = TextEditingController(text: 'fullscreen');
  }

  @override
  void dispose() {
    reminderTypeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 26),
          child: CustomScrollView(
            slivers: [
              SliverFillRemaining(
                hasScrollBody: false,
                child: Column(
                  children: [
                    const SizedBox(height: 14),
                    _buildHeader(context),
                    const SizedBox(height: 40),
                    _buildContent(
                      selectedType: reminderTypeController.text,
                      onSelect: selectType,
                    ),
                    const Spacer(),
                    _buildActionButton(context, isCheck),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
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
          Expanded(child: CustomProgressBarOnboarding(value: 0.50)),
        ],
      ),
    ],
  );
}

Widget _buildContent({
  required String selectedType,
  required Function(String) onSelect,
}) {
  final isFullScreenSelected = selectedType == 'fullscreen';
  final isCompactSelected = selectedType == 'compact';

  return Column(
    children: [
      Text(
        'Pilih jenis pengingat',
        style: AppTextStyles.titleLarge,
        textAlign: TextAlign.center,
      ),
      const SizedBox(height: 50),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: _buildOptionCard(
              title: 'Layar Penuh',
              description: 'Pengingat layar penuh agar lebih mudah terlihat',
              imageAsset: imgFullScreen,
              isSelected: isFullScreenSelected,
              onTap: () => onSelect('fullscreen'),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: _buildOptionCard(
              title: 'Ringkas',
              description: 'Pengingat ringkas untuk yang sudah terbiasa',
              imageAsset: imgSmall,
              isSelected: isCompactSelected,
              onTap: () => onSelect('compact'),
            ),
          ),
        ],
      ),
    ],
  );
}

Widget _buildOptionCard({
  required String title,
  required String description,
  required String imageAsset,
  required bool isSelected,
  required VoidCallback onTap,
}) {
  return GestureDetector(
    onTap: onTap, // Kartu bisa diklik langsung, tidak hanya checkbox
    behavior: HitTestBehavior.opaque,
    child: Column(
      children: [
        Container(
          height: 200,
          width: 120,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isSelected ? AppColors.secondary : const Color(0xFFD6D6D6),
              width: 4,
            ),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.asset(imageAsset, fit: BoxFit.fill),
          ),
        ),
        const SizedBox(height: 10),
        Text(
          title,
          style: AppTextStyles.titleMedium,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 4),
        Text(
          description,
          style: AppTextStyles.bodyMedium,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 10),
        CustomCheckbox(value: isSelected, onChanged: (_) => onTap()),
      ],
    ),
  );
}

Widget _buildActionButton(BuildContext context, bool isCheck) {
  return isCheck
      ? CustomButton(
          onTap: () {
            Navigator.pushNamed(context, '/reminder-sound');
          },
          label: 'Lanjut',
        )
      : CustomButtonOff(label: 'Lanjut');
}
