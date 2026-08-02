import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:smart_antibiotic/utils/app_assets.dart';
import 'package:smart_antibiotic/utils/app_colors.dart';
import 'package:smart_antibiotic/utils/app_text.dart';
import 'package:smart_antibiotic/utils/custom_base_bottom_sheet.dart';

class CustomReminderSoundSheet extends StatefulWidget {
  final String? initialSound;
  final ValueChanged<String>? onSoundSelected;

  const CustomReminderSoundSheet({
    super.key,
    this.initialSound,
    this.onSoundSelected,
  });

  @override
  State<CustomReminderSoundSheet> createState() =>
      _CustomReminderSoundSheetState();
}

class _CustomReminderSoundSheetState extends State<CustomReminderSoundSheet> {
  int? playingIndex;
  late String _selectedSound;

  final AudioPlayer _audioPlayer = AudioPlayer();

  final List<Map<String, String>> soundList = [
    {'name': 'Nada Standar', 'path': yQueFue},
    {'name': 'Melodi Lembut', 'path': cartel},
    {'name': 'Suara Alam', 'path': barudakPhonk},
  ];

  @override
  void initState() {
    super.initState();
    _selectedSound = widget.initialSound ?? soundList.first['name']!;

    _audioPlayer.onPlayerComplete.listen((event) {
      if (mounted) {
        setState(() {
          playingIndex = null;
        });
      }
    });
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  Future<void> _togglePlay(int index) async {
    final fullPath = soundList[index]['path']!;
    final cleanPath = fullPath.replaceFirst('assets/', '');

    if (playingIndex == index) {
      await _audioPlayer.stop();
      if (mounted) {
        setState(() {
          playingIndex = null;
        });
      }
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
    return CustomBaseBottomSheet(
      title: 'Pilih Suara Pengingat',
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(soundList.length, (index) {
          final soundName = soundList[index]['name']!;
          final isItemChosen = _selectedSound == soundName;
          final bool isLastItem = index == soundList.length - 1;

          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                onTap: () {
                  setState(() {
                    _selectedSound = soundName;
                  });

                  if (widget.onSoundSelected != null) {
                    widget.onSoundSelected!(soundName);
                  }

                  _togglePlay(index);
                },
                title: Text(
                  soundName,
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontSize: 18,
                    color: isItemChosen
                        ? AppColors.primary
                        : AppColors.textPrimary,
                    fontWeight: isItemChosen
                        ? FontWeight.bold
                        : FontWeight.normal,
                  ),
                ),
                trailing: isItemChosen
                    ? const Icon(Icons.check_rounded, color: AppColors.primary)
                    : null,
              ),
              if (!isLastItem)
                const Divider(color: Color(0xFFE7ECF0), height: 1),
            ],
          );
        }),
      ),
    );
  }
}
