import 'package:flutter/material.dart';
import 'package:smart_antibiotic/core/utils/app_assets.dart';
import 'package:smart_antibiotic/core/utils/app_colors.dart';
import 'package:smart_antibiotic/core/utils/app_text.dart';

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
      title: Text(widget.soundName, style: AppTextStyles.titleSmall),
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
                child: Icon(
                  widget.isItemPlaying ? Icons.pause : Icons.play_arrow_rounded,
                  size: widget.isItemPlaying ? 24 : 30,
                  color: AppColors.primary,
                ),
              ),
            )
          : const SizedBox(),
    );
  }
}
