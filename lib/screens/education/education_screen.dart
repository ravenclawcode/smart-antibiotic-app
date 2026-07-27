import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../utils/app_assets.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_text.dart';
import '../../utils/custom_education_card.dart';

class EducationScreen extends StatelessWidget {
  const EducationScreen({super.key});

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
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: _buildEducationList(context),
            ),
          ],
        ),
      ),
    );
  }
}

Widget _buildHeader(BuildContext context) {
  return Container(
    height: 220,
    width: double.infinity,
    clipBehavior: Clip.hardEdge,
    decoration: BoxDecoration(color: AppColors.primary),
    child: Stack(
      children: [
        Positioned(
          top: -55,
          right: -55,
          child: Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.accent,
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: SafeArea(
            bottom: false,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
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
                SizedBox(height: 12),
                Text(
                  'Antibiotik',
                  style: AppTextStyles.titleLarge.copyWith(
                    color: AppColors.textWhite,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Jelajahi informasi penting tentang\nantibiotik secara bertahap',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textWhite,
                  ),
                ),
                SizedBox(height: 14),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}

Widget _buildEducationList(BuildContext context) {
  final items = [
    {
      'title': 'Apa itu\nAntibiotik?',
      'image': imgEdu1,
      'cardColor': Color(0xFFE3EFFD),
      'textColor': Color(0xFF1A61CB),
      'route': '/education-definition',
    },
    {
      'title': 'Jenis-Jenis\nAntibiotik',
      'image': imgEdu2,
      'cardColor': Color(0xFFE2F5F1),
      'textColor': Color(0xFF076151),
      'route': '/education-type',
    },
    {
      'title': 'Kapan\nDiperlukan?',
      'image': imgEdu3,
      'cardColor': Color(0xFFFEECD5),
      'textColor': Color(0xFF8D4402),
      'route': '/education-indications',
    },
    {
      'title': 'Cara\nPenggunaan\nAntibiotik',
      'image': imgEdu4,
      'cardColor': Color(0xFFE7E5FE),
      'textColor': Color(0xFF4A29A3),
      'route': '/education-usage',
    },
    {
      'title': 'Resistensi\nAntibiotik',
      'image': imgEdu5,
      'cardColor': Color(0xFFFEE1E3),
      'textColor': Color(0xFFAA2125),
      'route': '/education-resistance',
    },
    {
      'title': 'Kategori\nAntibiotik',
      'image': imgEdu6,
      'cardColor': Color(0xFFE1F6F9),
      'textColor': Color(0xFF0C6C79),
      'route': '/education-category',
    },
  ];

  return GridView.builder(
    shrinkWrap: true,
    physics: NeverScrollableScrollPhysics(),
    padding: EdgeInsets.all(0),
    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 3,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 0.70,
    ),
    itemCount: items.length,
    itemBuilder: (context, index) {
      final item = items[index];
      return CustomEducationCard(
        title: item['title'] as String,
        image: Image.asset(item['image'] as String),
        colorCard: item['cardColor'] as Color,
        colorText: item['textColor'] as Color,
        onTap: () => Navigator.pushNamed(context, item['route'] as String),
      );
    },
  );
}
