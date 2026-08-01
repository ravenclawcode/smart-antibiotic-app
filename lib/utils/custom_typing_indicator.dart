import 'dart:math';

import 'package:flutter/widgets.dart';
import 'package:smart_antibiotic/utils/app_colors.dart';

class CustomTypingIndicator extends StatefulWidget {
  const CustomTypingIndicator({super.key});

  @override
  State<CustomTypingIndicator> createState() => _CustomTypingIndicatorState();
}

class _CustomTypingIndicatorState extends State<CustomTypingIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
        decoration: BoxDecoration(
          color: AppColors.surfaceSecondary,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(2.5),
            topRight: Radius.circular(15),
            bottomLeft: Radius.circular(15),
            bottomRight: Radius.circular(15),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(3, (index) {
            return AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                double delay = index * 0.3;
                double animValue = sin(
                  (_controller.value * 2 * 3.14159) - delay,
                );
                double yOffset = animValue * 4;
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 2),
                  transform: Matrix4.translationValues(0, yOffset, 0),
                  child: Container(
                    width: 6,
                    height: 6,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(
                        alpha: (0.3 + (animValue.abs() * 0.7)).clamp(0.0, 1.0),
                      ),
                      shape: BoxShape.circle,
                    ),
                  ),
                );
              },
            );
          }),
        ),
      ),
    );
  }
}
