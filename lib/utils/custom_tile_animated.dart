import 'package:flutter/material.dart';
import 'package:smart_antibiotic/utils/app_assets.dart';
import 'package:smart_antibiotic/utils/app_colors.dart';
import 'package:smart_antibiotic/utils/app_text.dart';

class CustomTileAnimated extends StatefulWidget {
  final String soundName;
  final bool isItemChosen;
  final bool isItemPlaying;
  final VoidCallback onSelect;
  final VoidCallback onTogglePlay;

  const CustomTileAnimated({
    super.key,
    required this.soundName,
    required this.isItemChosen,
    required this.isItemPlaying,
    required this.onSelect,
    required this.onTogglePlay,
  });

  @override
  State<CustomTileAnimated> createState() => CustomTileAnimatedState();
}

class CustomTileAnimatedState extends State<CustomTileAnimated>
    with SingleTickerProviderStateMixin {
  late final AnimationController _rotationController;

  @override
  void initState() {
    super.initState();
    _rotationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );

    if (widget.isItemPlaying) {
      _rotationController.repeat();
    }
  }

  @override
  void didUpdateWidget(covariant CustomTileAnimated oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isItemPlaying != oldWidget.isItemPlaying) {
      if (widget.isItemPlaying) {
        _rotationController.repeat();
      } else {
        _rotationController.stop();
      }
    }
  }

  @override
  void dispose() {
    _rotationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        widget.onSelect();
        widget.onTogglePlay();
      },
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      tileColor: widget.isItemChosen
          ? AppColors.surfaceAccent
          : AppColors.surfaceSecondary,
      splashColor: AppColors.surfaceAccent,
      hoverColor: AppColors.surfaceAccent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
      title: Row(
        children: [
          Text(widget.soundName, style: AppTextStyles.titleSmall),
          const Spacer(),

          AnimatedSwitcher(
            duration: const Duration(milliseconds: 350),
            transitionBuilder: (Widget child, Animation<double> animation) {
              final offsetAnimation =
                  Tween<Offset>(
                    begin: const Offset(1.4, 0.0),
                    end: Offset.zero,
                  ).animate(
                    CurvedAnimation(
                      parent: animation,
                      curve: Curves.easeOutCubic,
                    ),
                  );

              return SlideTransition(
                position: offsetAnimation,
                child: FadeTransition(opacity: animation, child: child),
              );
            },
            child: widget.isItemPlaying
                ? Image.asset(
                    audioWave,
                    key: const ValueKey('audio_wave_gif'),
                    width: 28,
                    height: 24,
                    fit: BoxFit.contain,
                  )
                : const SizedBox(
                    key: ValueKey('empty_space'),
                    width: 0,
                    height: 24,
                  ),
          ),
        ],
      ),
      leading: RotationTransition(
        turns: _rotationController,
        child: Image.asset(imgVinylDisk, width: 40),
      ),
      trailing: widget.isItemChosen
          ? InkWell(
              borderRadius: BorderRadius.circular(14),
              onTap: widget.onTogglePlay,
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  color: AppColors.surfacePrimary,
                ),
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 250),
                  transitionBuilder:
                      (Widget child, Animation<double> animation) {
                        return ScaleTransition(
                          scale: animation,
                          child: FadeTransition(
                            opacity: animation,
                            child: child,
                          ),
                        );
                      },
                  child: widget.isItemPlaying
                      ? Icon(
                          Icons.pause,
                          key: const ValueKey('pause_icon'),
                          size: 24,
                          color: AppColors.primary,
                        )
                      : Icon(
                          Icons.play_arrow_rounded,
                          key: const ValueKey('play_icon'),
                          size: 30,
                          color: AppColors.primary,
                        ),
                ),
              ),
            )
          : const SizedBox(),
    );
  }
}
