import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:smart_antibiotic/utils/app_assets.dart';

import '../../utils/app_colors.dart';
import '../../utils/app_text.dart';

class EducationResistanceScreen extends StatelessWidget {
  const EducationResistanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
      child: Scaffold(
        body: Column(
          children: [
            _buildHeader(context),
            SingleChildScrollView(child: _buildContent(context)),
          ],
        ),
      ),
    );
  }
}

Widget _buildHeader(BuildContext context) {
  return Container(
    height: 115,
    width: double.infinity,
    color: AppColors.primary,
    child: Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: SafeArea(
        bottom: false,
        child: Row(
          children: [
            InkWell(
              focusColor: Colors.transparent,
              hoverColor: Colors.transparent,
              highlightColor: Colors.transparent,
              splashColor: Colors.transparent,
              onTap: () => Navigator.pop(context),
              child: Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: AppColors.accent,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Icon(
                  Icons.arrow_back_ios_new_rounded,
                  size: 20,
                  color: AppColors.surfacePrimary,
                ),
              ),
            ),
            SizedBox(width: 14),
            Text(
              'Resistensi Antibiotik',
              style: AppTextStyles.titleLarge.copyWith(
                color: AppColors.textWhite,
              ),
            ),
            Spacer(),
          ],
        ),
      ),
    ),
  );
}

Widget _buildContent(BuildContext context) {
  final List<String> causes = [
    'Penggunaan antibiotik yang tidak perlu',
    'Tidak menghabiskan antibiotik',
    'Penggunaan dosis yang tidak tepat',
    'Penggunaan antibiotik pada hewan secara berlebihan.',
  ];

  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 26),
        Center(child: Image.asset(imgResistance, height: 130)),
        SizedBox(height: 26),
        Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: 'Resistensi antibiotik ',
                style: AppTextStyles.bodyLarge,
              ),
              TextSpan(
                text:
                    'terjadi ketika bakteri menjadi kebal terhadap antibiotik. Akibatnya, antibiotik tidak lagi efektif dan infeksi menjadi lebih sulit diobati.',
                style: AppTextStyles.bodyMedium.copyWith(
                  fontSize: 18,
                  height: 1.6,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 26),
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: const Color(0xFFFEE4E2),
            border: Border.all(color: AppColors.error),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Penyebab Resistensi:',
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4),
                ...causes.map((text) => _buildBulletItem(text)),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}

Widget _buildBulletItem(String text) {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Padding(
        padding: const EdgeInsets.only(left: 4),
        child: Text('• ', style: AppTextStyles.bodyMedium),
      ),
      Expanded(
        child: Text(
          text,
          style: AppTextStyles.bodyMedium.copyWith(height: 1.6),
        ),
      ),
    ],
  );
}
