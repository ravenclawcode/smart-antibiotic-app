import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:smart_antibiotic/utils/app_text.dart';
import 'package:smart_antibiotic/utils/custom_tile_animated.dart';

import '../../utils/app_assets.dart';

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
      OnboardingReminderSoundContentState();
}

class OnboardingReminderSoundContentState
    extends State<OnboardingReminderSoundContent> {
  int? playingIndex;

  final AudioPlayer _audioPlayer = AudioPlayer();

  final List<Map<String, String>> soundList = [
    {'name': 'Nada Standar', 'path': yQueFue},
    {'name': 'Melodi Lembut', 'path': cartel},
    {'name': 'Suara Alam', 'path': barudakPhonk},
  ];

  @override
  void initState() {
    super.initState();
    _audioPlayer.onPlayerComplete.listen((event) {
      if (mounted) {
        setState(() {
          playingIndex = null;
        });
      }
    });
  }

  Future<void> stopAudio() async {
    try {
      await _audioPlayer.stop();
    } catch (_) {}

    if (mounted) {
      setState(() {
        playingIndex = null;
      });
    }
  }

  @override
  void dispose() {
    _audioPlayer.stop();
    _audioPlayer.dispose();
    super.dispose();
  }

  Future<void> _togglePlay(int index) async {
    final fullPath = soundList[index]['path']!;
    final cleanPath = fullPath.replaceFirst('assets/', '');

    if (playingIndex == index) {
      await stopAudio();
    } else {
      await _audioPlayer.stop();
      await _audioPlayer.play(AssetSource(cleanPath));
      if (mounted) {
        setState(() {
          playingIndex = index;
        });
      }
    }
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
              final soundName = soundList[index]['name']!;
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
