import 'package:flutter/material.dart';
import 'package:smart_antibiotic/utils/app_assets.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_text.dart';
import '../../utils/custom_checkbox.dart';

class OnboardingReminderTypeContent extends StatelessWidget {
  final String selectedType;
  final ValueChanged<String> onSelectType;

  const OnboardingReminderTypeContent({
    super.key,
    required this.selectedType,
    required this.onSelectType,
  });

  void _handleTap(String type) {
    if (selectedType == type) {
      onSelectType('');
    } else {
      onSelectType(type);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isFullScreenSelected = selectedType == 'Layar Penuh';
    final isCompactSelected = selectedType == 'Ringkas';

    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 20),
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
                  description:
                      'Pengingat layar penuh agar lebih mudah terlihat',
                  imageAsset: imgFullScreen,
                  isSelected: isFullScreenSelected,
                  onTap: () => _handleTap('Layar Penuh'),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildOptionCard(
                  title: 'Ringkas',
                  description: 'Pengingat ringkas untuk yang sudah terbiasa',
                  imageAsset: imgSmall,
                  isSelected: isCompactSelected,
                  onTap: () => _handleTap('Ringkas'),
                ),
              ),
            ],
          ),
        ],
      ),
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
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        children: [
          Container(
            height: 200,
            width: 120,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isSelected
                    ? AppColors.secondary
                    : const Color(0xFFD6D6D6),
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
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),
          CustomCheckbox(value: isSelected, onChanged: (_) => onTap()),
        ],
      ),
    );
  }
}
