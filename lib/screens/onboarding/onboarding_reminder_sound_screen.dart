import 'package:flutter/material.dart';
import 'package:smart_antibiotic/core/utils/app_text.dart';
import 'package:smart_antibiotic/core/utils/custom_tile_animated.dart';

class OnboardingReminderSoundContent extends StatefulWidget {
  final String selectedSound;
  final ValueChanged<String> onSelectSound;

  const OnboardingReminderSoundContent({
    super.key,
    required this.selectedSound,
    required this.onSelectSound,
  });

  @override
  State<OnboardingReminderSoundContent> createState() =>
      _OnboardingReminderSoundContentState();
}

class _OnboardingReminderSoundContentState
    extends State<OnboardingReminderSoundContent> {
  int? playingIndex;

  final List<String> soundList = [
    'Nada Standar',
    'Melodi Lembut',
    'Suara Alam',
  ];

  void _togglePlay(int index) {
    setState(() {
      if (playingIndex == index) {
        playingIndex = null;
      } else {
        playingIndex = index;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 20),
          Text(
            'Pilih suara pengingat',
            style: AppTextStyles.titleLarge,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 50),
          Column(
            children: List.generate(soundList.length, (index) {
              final soundName = soundList[index];
              final isItemChosen = widget.selectedSound == soundName;
              final isItemPlaying = playingIndex == index;

              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: CustomTileAnimated(
                  soundName: soundName,
                  isItemChosen: isItemChosen,
                  isItemPlaying: isItemPlaying,
                  onSelect: () => widget.onSelectSound(soundName),
                  onTogglePlay: () => _togglePlay(index),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
