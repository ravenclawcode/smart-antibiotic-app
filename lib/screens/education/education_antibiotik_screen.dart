import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:smart_antibiotic/utils/custom_antibiotik_card.dart';

import '../../utils/app_assets.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_text.dart';

class EducationAntibiotikScreen extends StatelessWidget {
  const EducationAntibiotikScreen({super.key});

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
              child: _buildList(),
            ),
          ],
        ),
      ),
    );
  }
}

Widget _buildHeader(BuildContext context) {
  return Container(
    height: 186,
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
                  'Penisilin',
                  style: AppTextStyles.titleLarge.copyWith(
                    color: AppColors.textWhite,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  '4 Obat',
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontSize: 18,
                    color: AppColors.textWhite,
                  ),
                ),
                SizedBox(height: 2),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}

Widget _buildList() {
  final item = [
    {
      'title': 'Amoxicillin',
      'image': Image.asset(imgManyPills),
      'route': '/education-detail',
    },
    {
      'title': 'Ampicillin',
      'image': Image.asset(imgManyPills),
      'route': '/lorem-ipsum',
    },
    {
      'title': 'Piperacillin',
      'image': Image.asset(imgManyPills),
      'route': '/lorem-ipsum',
    },
    {
      'title': 'Oxacillin',
      'image': Image.asset(imgManyPills),
      'route': '/lorem-ipsum',
    },
  ];

  return ListView.builder(
    shrinkWrap: true,
    physics: NeverScrollableScrollPhysics(),
    itemCount: item.length,
    padding: EdgeInsets.zero,
    itemBuilder: (context, index) {
      final menu = item[index];

      return Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: CustomAntibiotikCard(
          title: menu['title'] as String,
          image: menu['image'] as Image,
          onTap: () => Navigator.pushNamed(context, menu['route'] as String),
        ),
      );
    },
  );
}
