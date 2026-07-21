import 'package:flutter/material.dart';
import 'package:smart_antibiotic/core/utils/custom_button.dart';

import '../../core/utils/app_text.dart';

class OnboardingIntroScreen extends StatelessWidget {
  const OnboardingIntroScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 26),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Spacer(),
              _buildContent(),
              Spacer(),
              _buildActionButton(context),
              SizedBox(height: 30),
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
    onTap: () => Navigator.pushNamed(context, '/input-name'),
    label: 'Lanjut',
  );
}
