import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shimmer/shimmer.dart';

import '../../utils/app_assets.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_text.dart';
import '../../utils/custom_education_card.dart';

class EducationScreen extends StatefulWidget {
  const EducationScreen({super.key});

  @override
  State<EducationScreen> createState() => _EducationScreenState();
}

class _EducationScreenState extends State<EducationScreen> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    await Future.delayed(const Duration(milliseconds: 600));
    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
      child: Scaffold(
        body: Column(
          children: [
            _buildHeader(context, isLoading: _isLoading),
            const SizedBox(height: 20),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: _isLoading
                    ? _buildShimmerLoading()
                    : _buildEducationList(context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShimmerLoading() {
    return Shimmer.fromColors(
      baseColor: AppColors.surfaceSecondary,
      highlightColor: AppColors.surfaceCool,
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        padding: EdgeInsets.zero,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 0.70,
        ),
        itemCount: 6,
        itemBuilder: (context, index) {
          return Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.surfacePrimary,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 50,
                      height: 12,
                      decoration: BoxDecoration(
                        color: AppColors.surfacePrimary,
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      width: 35,
                      height: 12,
                      decoration: BoxDecoration(
                        color: AppColors.surfacePrimary,
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                  ],
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: AppColors.surfacePrimary,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

Widget _buildHeader(BuildContext context, {required bool isLoading}) {
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
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: SafeArea(
            bottom: false,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (isLoading)
                  Shimmer.fromColors(
                    baseColor: AppColors.accent,
                    highlightColor: AppColors.primary,
                    child: Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: AppColors.accent,
                        shape: BoxShape.circle,
                      ),
                    ),
                  )
                else
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
                const SizedBox(height: 12),
                if (isLoading)
                  Shimmer.fromColors(
                    baseColor: AppColors.accent,
                    highlightColor: AppColors.primary,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 120,
                          height: 28,
                          decoration: BoxDecoration(
                            color: AppColors.accent,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Container(
                          width: 260,
                          height: 18,
                          decoration: BoxDecoration(
                            color: AppColors.accent,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Container(
                          width: 180,
                          height: 18,
                          decoration: BoxDecoration(
                            color: AppColors.accent,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ],
                    ),
                  )
                else
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Antibiotik',
                        style: AppTextStyles.titleLarge.copyWith(
                          color: AppColors.textWhite,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Jelajahi informasi penting tentang\nantibiotik secara bertahap',
                        style: AppTextStyles.bodyMedium.copyWith(
                          fontSize: 18,
                          color: AppColors.textWhite,
                        ),
                      ),
                    ],
                  ),
                const SizedBox(height: 12),
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
      'cardColor': const Color(0xFFE3EFFD),
      'textColor': const Color(0xFF1A61CB),
      'route': '/education-definition',
    },
    {
      'title': 'Jenis-Jenis\nAntibiotik',
      'image': imgEdu2,
      'cardColor': const Color(0xFFE2F5F1),
      'textColor': const Color(0xFF076151),
      'route': '/education-type',
    },
    {
      'title': 'Kapan\nDiperlukan?',
      'image': imgEdu3,
      'cardColor': const Color(0xFFFEECD5),
      'textColor': const Color(0xFF8D4402),
      'route': '/education-indications',
    },
    {
      'title': 'Cara\nPenggunaan\nAntibiotik',
      'image': imgEdu4,
      'cardColor': const Color(0xFFE7E5FE),
      'textColor': const Color(0xFF4A29A3),
      'route': '/education-usage',
    },
    {
      'title': 'Resistensi\nAntibiotik',
      'image': imgEdu5,
      'cardColor': const Color(0xFFFEE1E3),
      'textColor': const Color(0xFFAA2125),
      'route': '/education-resistance',
    },
    {
      'title': 'Kategori\nAntibiotik',
      'image': imgEdu6,
      'cardColor': const Color(0xFFE1F6F9),
      'textColor': const Color(0xFF0C6C79),
      'route': '/education-category',
    },
  ];

  return GridView.builder(
    shrinkWrap: true,
    physics: const NeverScrollableScrollPhysics(),
    padding: EdgeInsets.zero,
    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
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
