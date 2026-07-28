import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../utils/app_assets.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_text.dart';
import '../../utils/custom_list_card.dart';

class EducationIndicationsScreen extends StatelessWidget {
  const EducationIndicationsScreen({super.key});

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
  final isSmallScreen = MediaQuery.of(context).size.width < 360;

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
            Expanded(
              child: Text(
                'Kapan Antibiotik Diperlukan?',
                style: AppTextStyles.titleLarge.copyWith(
                  fontSize: isSmallScreen ? 24 : 20,
                  color: AppColors.textWhite,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

Widget _buildContent(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20),
    child: Column(
      children: [
        SizedBox(height: 26),
        Text(
          'Antibiotik digunakan hanya untuk infeksi bakteri, seperti:',
          style: AppTextStyles.bodyMedium.copyWith(fontSize: 18),
        ),
        SizedBox(height: 16),
        _buildList(context),
        SizedBox(height: 12),
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Color(0xFFFEE4E2),
            border: Border.all(color: AppColors.error, width: 1.5),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
            child: Row(
              children: [
                Image.asset(imgAlert, height: 56),
                SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Tidak efektif untuk:',
                        style: AppTextStyles.bodyMedium.copyWith(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        'Flu, pilek, batuk, sakit kepala yang disebabkan oleh virus.',
                        style: AppTextStyles.bodyMedium.copyWith(height: 1.3),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}

Widget _buildList(BuildContext context) {
  final item = [
    {
      'title': 'Infeksi tenggorokan',
      'subtitle': '(Streptococcus)',
      'image': Image.asset(imgThroat),
    },
    {
      'title': 'Infeksi saluran kemih',
      'subtitle': '(Bakteri)',
      'image': Image.asset(imgKidney),
    },
    {
      'title': 'Infeksi kulit',
      'subtitle': '(Bakteri)',
      'image': Image.asset(imgSkin),
    },
    {
      'title': 'Pneumonia',
      'subtitle': '(Bakteri)',
      'image': Image.asset(imgLungs),
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
        child: CustomListCard(
          title: menu['title'] as String,
          subtitle: menu['subtitle'] as String,
          image: menu['image'] as Image,
          color: Color(0xFFFDE9D9),
        ),
      );
    },
  );
}
