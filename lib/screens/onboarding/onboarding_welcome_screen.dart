import 'package:flutter/material.dart';
import 'package:smart_antibiotic/core/utils/app_text.dart';

import '../../routes/routes.dart';

class OnboardingWelcomeScreen extends StatefulWidget {
  const OnboardingWelcomeScreen({super.key});

  @override
  State<OnboardingWelcomeScreen> createState() =>
      _OnboardingWelcomeScreenState();
}

class _OnboardingWelcomeScreenState extends State<OnboardingWelcomeScreen> {
  @override
  void initState() {
    super.initState();
    _fontAnimated();
  }

  Future<void> _fontAnimated() async {
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    Navigator.pushReplacementNamed(context, Routes.intro);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 26),
          child: Center(child: _buildContent()),
        ),
      ),
    );
  }
}

Widget _buildContent() {
  return Text(
    'Halo, selamat datang!',
    style: AppTextStyles.titleLarge,
    textAlign: TextAlign.center,
  );
}
