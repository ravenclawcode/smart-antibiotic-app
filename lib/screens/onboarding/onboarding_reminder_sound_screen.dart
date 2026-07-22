import 'package:flutter/material.dart';
import 'package:smart_antibiotic/core/utils/app_text.dart';
import 'package:smart_antibiotic/core/utils/custom_tile_animated.dart';

import '../../core/utils/app_colors.dart';
import '../../core/utils/custom_button.dart';
import '../../core/utils/custom_button_off.dart';
import '../../core/utils/custom_loading.dart';
import '../../core/utils/custom_progress_bar_onboarding.dart';

class OnboardingReminderSoundScreen extends StatefulWidget {
  const OnboardingReminderSoundScreen({super.key});

  @override
  State<OnboardingReminderSoundScreen> createState() =>
      _OnboardingReminderSoundScreenState();
}

class _OnboardingReminderSoundScreenState
    extends State<OnboardingReminderSoundScreen> {
  late final TextEditingController soundController;

  int? playingIndex;
  bool isLoading = false;

  final List<String> soundList = [
    'Nada Standar',
    'Melodi Lembut',
    'Suara Alam',
  ];

  @override
  void initState() {
    super.initState();
    soundController = TextEditingController(
      text: soundList.isNotEmpty ? soundList[0] : '',
    );
  }

  @override
  void dispose() {
    soundController.dispose();
    super.dispose();
  }

  bool get isSelected => soundController.text.isNotEmpty;

  void selectSound(String sound) {
    setState(() {
      soundController.text = sound;
    });
  }

  void togglePlay(int index) {
    setState(() {
      if (playingIndex == index) {
        playingIndex = null;
      } else {
        playingIndex = index;
      }
    });
  }

  Future<void> _submitData({
    required String nameInputted,
    required String reminderType,
    required String reminderSound,
  }) async {
    setState(() {
      isLoading = true;
    });

    try {
      await Future.delayed(const Duration(seconds: 3));

      if (!mounted) return;

      Navigator.pushNamed(context, '/permission');
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Gagal menyimpan data: $e')));
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final previousArgs =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>? ??
        {};
    final String nameInputted = previousArgs['nameInputted'] ?? '';
    final String reminderType = previousArgs['reminderType'] ?? '';

    return Scaffold(
      body: Stack(
        children: [
          SafeArea(
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
                          soundList: soundList,
                          selectedSound: soundController.text,
                          playingIndex: playingIndex,
                          onSelect: selectSound,
                          onTogglePlay: togglePlay,
                        ),
                        const Spacer(),
                        _buildActionButton(
                          context: context,
                          isSelected: isSelected,
                          onPressed: () {
                            _submitData(
                              nameInputted: nameInputted,
                              reminderType: reminderType,
                              reminderSound: soundController.text,
                            );
                          },
                        ),
                        const SizedBox(height: 30),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (isLoading)
            Container(
              color: AppColors.textPrimary.withValues(alpha: 0.4),
              child: const Center(child: CustomLoading()),
            ),
        ],
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
          Expanded(child: CustomProgressBarOnboarding(value: 1)),
        ],
      ),
    ],
  );
}

Widget _buildContent({
  required List<String> soundList,
  required String selectedSound,
  required int? playingIndex,
  required Function(String) onSelect,
  required Function(int) onTogglePlay,
}) {
  return Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      Text(
        'Pilih suara pengingat',
        style: AppTextStyles.titleLarge,
        textAlign: TextAlign.center,
      ),
      const SizedBox(height: 50),
      Column(
        children: List.generate(soundList.length, (index) {
          final soundName = soundList[index];
          final isItemChosen = selectedSound == soundName;
          final isItemPlaying = playingIndex == index;

          return Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: CustomTileAnimated(
              soundName: soundName,
              isItemChosen: isItemChosen,
              isItemPlaying: isItemPlaying,
              onSelect: () => onSelect(soundName),
              onTogglePlay: () => onTogglePlay(index),
            ),
          );
        }),
      ),
    ],
  );
}

Widget _buildActionButton({
  required BuildContext context,
  required bool isSelected,
  required VoidCallback onPressed,
}) {
  return isSelected
      ? CustomButton(onTap: onPressed, label: 'Simpan')
      : const CustomButtonOff(label: 'Simpan');
}
