import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:smart_antibiotic/core/utils/app_assets.dart';
import 'package:smart_antibiotic/core/utils/app_colors.dart';
import 'package:smart_antibiotic/core/utils/app_text.dart';

class CustomLoading extends StatefulWidget {
  const CustomLoading({super.key});

  @override
  State<CustomLoading> createState() => _CustomLoadingState();
}

class _CustomLoadingState extends State<CustomLoading>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1400),
      vsync: this,
    )..repeat();

    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 140,
      height: 120,
      decoration: BoxDecoration(
        color: AppColors.surfacePrimary,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 5),
          RotationTransition(
            turns: _animation,
            child: const Image(
              width: 63,
              height: 59,
              image: AssetImage(icLoading),
            ),
          ),
          const SizedBox(height: 10),
          Text('Mohon tunggu', maxLines: 1, style: AppTextStyles.bodySmall),
        ],
      ),
    );
  }
}
