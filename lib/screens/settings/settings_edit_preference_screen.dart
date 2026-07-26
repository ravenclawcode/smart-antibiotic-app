import 'package:flutter/material.dart';
import 'package:smart_antibiotic/utils/custom_reminder_sound_sheet.dart';

import '../../utils/app_assets.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_text.dart';
import '../../utils/custom_checkbox.dart';

class SettingsEditPreferenceScreen extends StatefulWidget {
  final String selectedType;
  final ValueChanged<String> onSelectType;

  const SettingsEditPreferenceScreen({
    super.key,
    required this.selectedType,
    required this.onSelectType,
  });

  @override
  State<SettingsEditPreferenceScreen> createState() =>
      _SettingsEditPreferenceScreenState();
}

class _SettingsEditPreferenceScreenState
    extends State<SettingsEditPreferenceScreen> {
  late String _currentSelectedType;

  @override
  void initState() {
    super.initState();
    _currentSelectedType = widget.selectedType;
  }

  void _handleTap(String type) {
    setState(() {
      if (_currentSelectedType == type) {
        _currentSelectedType = '';
      } else {
        _currentSelectedType = type;
      }
    });
    widget.onSelectType(_currentSelectedType);
  }

  void _showReminderSound() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) =>
          CustomReminderSoundSheet(onSoundSelected: (String selectedSound) {}),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          _buildHeader(context),
          SizedBox(height: 26),
          _buildReminderType(_currentSelectedType, _handleTap),
          SizedBox(height: 16),
          _buildReminderSound(_showReminderSound),
        ],
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
      padding: EdgeInsets.symmetric(horizontal: 26),
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
            SizedBox(width: 18),
            Text(
              'Preferensi',
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

Widget _buildReminderType(String selectedType, Function(String) handleTap) {
  final isFullScreenSelected = selectedType == 'Layar Penuh';
  final isCompactSelected = selectedType == 'Ringkas';

  return Padding(
    padding: EdgeInsets.symmetric(horizontal: 20),
    child: Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 26),
      decoration: BoxDecoration(
        color: AppColors.surfaceSecondary,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Jenis Pengingat', style: AppTextStyles.bodyLarge),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _buildOptionCard(
                  title: 'Layar Penuh',
                  imageAsset: imgFullScreen,
                  isSelected: isFullScreenSelected,
                  onTap: () => handleTap('Layar Penuh'),
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: _buildOptionCard(
                  title: 'Ringkas',
                  imageAsset: imgSmall,
                  isSelected: isCompactSelected,
                  onTap: () => handleTap('Ringkas'),
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}

Widget _buildOptionCard({
  required String title,
  required String imageAsset,
  required bool isSelected,
  required VoidCallback onTap,
}) {
  return GestureDetector(
    onTap: onTap,
    behavior: HitTestBehavior.opaque,
    child: Column(
      children: [
        Container(
          height: 150,
          width: 95,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isSelected ? AppColors.secondary : Color(0xFFD6D6D6),
              width: 4,
            ),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.asset(imageAsset, fit: BoxFit.fill),
          ),
        ),
        SizedBox(height: 10),
        Text(
          title,
          style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 10),
        CustomCheckbox(value: isSelected, onChanged: (_) => onTap()),
      ],
    ),
  );
}

Widget _buildReminderSound(VoidCallback showReminderSound) {
  return Padding(
    padding: EdgeInsets.symmetric(horizontal: 20),
    child: Container(
      width: double.infinity,
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surfaceSecondary,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Text('Suara Pengingat', style: AppTextStyles.bodyLarge),
          Spacer(),
          InkWell(
            focusColor: Colors.transparent,
            hoverColor: Colors.transparent,
            highlightColor: Colors.transparent,
            splashColor: Colors.transparent,
            onTap: showReminderSound,
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
  );
}
