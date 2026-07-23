import 'package:flutter/material.dart';
import 'package:smart_antibiotic/core/utils/custom_button.dart';

import '../../core/utils/app_text.dart';

class OnboardingIntroScreen extends StatefulWidget {
  const OnboardingIntroScreen({super.key});

  @override
  State<OnboardingIntroScreen> createState() => _OnboardingIntroScreenState();
}

class _OnboardingIntroScreenState extends State<OnboardingIntroScreen> {
  double _contentOpacity = 0.0;
  double _buttonOpacity = 0.0;

  @override
  void initState() {
    super.initState();
    _startAnimationSequence();
  }

  Future<void> _startAnimationSequence() async {
    await Future.delayed(const Duration(milliseconds: 300));
    if (!mounted) return;

    setState(() {
      _contentOpacity = 1.0;
    });

    await Future.delayed(const Duration(milliseconds: 1000));
    if (!mounted) return;

    setState(() {
      _buttonOpacity = 1.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 26),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              AnimatedOpacity(
                opacity: _contentOpacity,
                duration: const Duration(milliseconds: 800),
                curve: Curves.easeIn,
                child: _buildContent(),
              ),
              const Spacer(),
              AnimatedOpacity(
                opacity: _buttonOpacity,
                duration: const Duration(milliseconds: 800),
                curve: Curves.easeIn,
                child: _buildActionButton(context),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}

Widget _buildContent() {
  return Text(
    'Mari sesuaikan aplikasi dengan kebutuhan Anda!',
    style: AppTextStyles.titleLarge,
    textAlign: TextAlign.center,
  );
}

Widget _buildActionButton(BuildContext context) {
  return CustomButton(
    onTap: () => Navigator.pushNamed(context, '/onboarding-steps'),
    label: 'Lanjut',
  );
}
