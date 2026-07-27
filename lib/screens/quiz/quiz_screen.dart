import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../utils/app_assets.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_text.dart';
import '../../utils/custum_quiz_card.dart';

class QuizScreen extends StatelessWidget {
  const QuizScreen({super.key});

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
              child: _buildQuisList(context),
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
          padding: EdgeInsets.symmetric(horizontal: 26),
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
                  'Kuis Antibiotik',
                  style: AppTextStyles.titleLarge.copyWith(
                    color: AppColors.textWhite,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Tingkatkan pengetahuanmu tentang\nantibiotik melalui kuis',
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

Widget _buildQuisList(BuildContext context) {
  return Column(
    children: [
      SingleChildScrollView(
        scrollDirection: Axis.vertical,
        clipBehavior: Clip.none,
        child: Column(
          children: [
            CustomQuizCard(
              title: 'Level 1',
              subtitle: 'Lorem Ipsum',
              image: Image.asset(imgKuis1),
              color: AppColors.surfaceSecondary,
              onTap: () {},
            ),
            SizedBox(height: 10),
            CustomQuizCard(
              title: 'Level 2',
              subtitle: 'Lorem Ipsum',
              image: Image.asset(imgKuis2),
              color: AppColors.surfaceSecondary,
              onTap: () {},
            ),
            SizedBox(height: 10),
            CustomQuizCard(
              title: 'Level 3',
              subtitle: 'Lorem Ipsum',
              image: Image.asset(imgKuis3),
              color: AppColors.surfaceSecondary,
              onTap: () {},
            ),
          ],
        ),
      ),
    ],
  );
}
