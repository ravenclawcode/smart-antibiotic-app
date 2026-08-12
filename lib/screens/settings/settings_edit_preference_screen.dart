import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import '../../providers/settings_provider.dart';
import '../../utils/app_assets.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_text.dart';
import '../../utils/custom_button.dart';
import '../../utils/custom_button_off.dart';
import '../../utils/custom_checkbox.dart';
import '../../utils/custom_reminder_sound_sheet.dart';

class SettingsEditPreferenceScreen extends StatefulWidget {
  const SettingsEditPreferenceScreen({super.key});

  @override
  State<SettingsEditPreferenceScreen> createState() =>
      _SettingsEditPreferenceScreenState();
}

class _SettingsEditPreferenceScreenState
    extends State<SettingsEditPreferenceScreen> {
  String _currentSelectedType = '';
  String _initialSelectedType = '';

  String _selectedSound = '';
  String _initialSelectedSound = '';

  bool _isLoading = true;

  bool get _hasChanges {
    return _currentSelectedType != _initialSelectedType ||
        _selectedSound != _initialSelectedSound;
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _fetchData();
      }
    });
  }

  Future<void> _fetchData() async {
    final provider = context.read<SettingsProvider>();

    final success = await provider.loadPreferences();

    if (!mounted) {
      return;
    }

    if (success && provider.preferences != null) {
      final preferences = provider.preferences!;

      _initialSelectedType = preferences.reminderType;

      _initialSelectedSound = preferences.reminderSound;

      _currentSelectedType = preferences.reminderType;

      _selectedSound = preferences.reminderSound;
    } else {
      _initialSelectedType = '';
      _currentSelectedType = '';

      _initialSelectedSound = '';
      _selectedSound = '';
    }

    if (!mounted) {
      return;
    }

    setState(() {
      _isLoading = false;
    });
  }

  void _handleTap(String type) {
    setState(() {
      _currentSelectedType = type;
    });
  }

  Future<void> _savePreferences() async {
    if (_currentSelectedType.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Silakan pilih jenis pengingat.')),
      );

      return;
    }

    final provider = context.read<SettingsProvider>();

    final success = await provider.updatePreferences(
      reminderType: _currentSelectedType,
      reminderSound: _selectedSound,
    );

    if (!mounted) {
      return;
    }

    if (success) {
      Navigator.pop(context, true);

      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          provider.errorMessage ?? 'Gagal menyimpan perubahan preferensi.',
        ),
      ),
    );
  }

  void _showReminderSound() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return CustomReminderSoundSheet(
          initialSound: _selectedSound,
          onSoundSelected: (String selectedSound) {
            if (!mounted) {
              return;
            }

            setState(() {
              _selectedSound = selectedSound;
            });
          },
        );
      },
    );
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
            const SizedBox(height: 26),
            Expanded(
              child: _isLoading
                  ? _buildShimmerContent()
                  : LayoutBuilder(
                      builder: (context, constraints) {
                        return SingleChildScrollView(
                          child: ConstrainedBox(
                            constraints: BoxConstraints(
                              minHeight: constraints.maxHeight,
                            ),
                            child: IntrinsicHeight(
                              child: Column(
                                children: [
                                  _buildReminderType(
                                    _currentSelectedType,
                                    _handleTap,
                                  ),

                                  const SizedBox(height: 16),

                                  _buildReminderSound(_showReminderSound),

                                  const Spacer(),

                                  _buildActionButton(
                                    context,
                                    _hasChanges,
                                    _savePreferences,
                                  ),

                                  const SizedBox(height: 60),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShimmerContent() {
    return Shimmer.fromColors(
      baseColor: AppColors.surfaceSecondary,
      highlightColor: AppColors.surfaceCool,
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 26,
                ),
                decoration: BoxDecoration(
                  color: AppColors.surfacePrimary,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 140,
                      height: 18,
                      decoration: BoxDecoration(
                        color: AppColors.surfacePrimary,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(child: _buildSkeletonOptionCard()),
                        const SizedBox(width: 16),
                        Expanded(child: _buildSkeletonOptionCard()),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Container(
                width: double.infinity,
                height: 60,
                decoration: BoxDecoration(
                  color: AppColors.surfacePrimary,
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSkeletonOptionCard() {
    return Column(
      children: [
        Container(
          height: 150,
          width: 95,
          decoration: BoxDecoration(
            color: AppColors.surfacePrimary,
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        const SizedBox(height: 10),
        Container(
          width: 70,
          height: 14,
          decoration: BoxDecoration(
            color: AppColors.surfacePrimary,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(height: 10),
        Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            color: AppColors.surfacePrimary,
            borderRadius: BorderRadius.circular(6),
          ),
        ),
      ],
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
                'Preferensi',
                style: AppTextStyles.titleLarge.copyWith(
                  color: AppColors.textWhite,
                ),
              ),
          ],
        ),
      ),
    ),
  );
}

Widget _buildReminderType(String selectedType, Function(String) handleTap) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20),
    child: Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 26),
      decoration: BoxDecoration(
        color: AppColors.surfaceSecondary,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Jenis Pengingat', style: AppTextStyles.bodyLarge),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: _buildOptionCard(
                  title: 'Layar Penuh',
                  imageAsset: imgFullScreen,
                  isSelected: selectedType == 'Layar Penuh',
                  onTap: () => handleTap('Layar Penuh'),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildOptionCard(
                  title: 'Ringkas',
                  imageAsset: imgSmall,
                  isSelected: selectedType == 'Ringkas',
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
              color: isSelected ? AppColors.secondary : const Color(0xFFD6D6D6),
              width: 4,
            ),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.asset(imageAsset, fit: BoxFit.fill),
          ),
        ),
        const SizedBox(height: 10),
        Text(
          title,
          style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 10),
        CustomCheckbox(value: isSelected, onChanged: (_) => onTap()),
      ],
    ),
  );
}

Widget _buildReminderSound(VoidCallback showReminderSound) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20),
    child: Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surfaceSecondary,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Text('Suara Pengingat', style: AppTextStyles.bodyLarge),
          const Spacer(),
          InkWell(
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

Widget _buildActionButton(
  BuildContext context,
  bool isEnabled,
  VoidCallback savePreferences,
) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20),
    child: isEnabled
        ? CustomButton(onTap: savePreferences, label: 'Simpan Perubahan')
        : CustomButtonOff(label: 'Simpan Perubahan'),
  );
}
