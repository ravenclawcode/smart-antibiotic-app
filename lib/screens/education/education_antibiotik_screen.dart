import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shimmer/shimmer.dart';
import 'package:smart_antibiotic/utils/custom_antibiotik_card.dart';

import '../../utils/app_assets.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_text.dart';

class EducationAntibiotikScreen extends StatefulWidget {
  const EducationAntibiotikScreen({super.key});

  @override
  State<EducationAntibiotikScreen> createState() =>
      _EducationAntibiotikScreenState();
}

class _EducationAntibiotikScreenState extends State<EducationAntibiotikScreen> {
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
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: _isLoading ? _buildShimmerList() : _buildList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShimmerList() {
    return Shimmer.fromColors(
      baseColor: AppColors.surfaceSecondary,
      highlightColor: AppColors.surfaceCool,
      child: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: 4,
        padding: EdgeInsets.zero,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.surfacePrimary, width: 1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: AppColors.surfacePrimary,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Container(
                      width: 140,
                      height: 18,
                      decoration: BoxDecoration(
                        color: AppColors.surfacePrimary,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

Widget _buildHeader(BuildContext context, {required bool isLoading}) {
  return Container(
    height: 186,
    width: double.infinity,
    clipBehavior: Clip.hardEdge,
    decoration: const BoxDecoration(color: AppColors.primary),
    child: Stack(
      children: [
        Positioned(
          top: -55,
          right: -55,
          child: Container(
            width: 200,
            height: 200,
            decoration: const BoxDecoration(
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
                      decoration: const BoxDecoration(
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
                          width: 140,
                          height: 24,
                          decoration: BoxDecoration(
                            color: AppColors.accent,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Container(
                          width: 80,
                          height: 18,
                          decoration: BoxDecoration(
                            color: AppColors.accent,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ],
                    ),
                  )
                else ...[
                  Text(
                    'Penisilin',
                    style: AppTextStyles.titleLarge.copyWith(
                      color: AppColors.textWhite,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '4 Obat',
                    style: AppTextStyles.bodyMedium.copyWith(
                      fontSize: 18,
                      color: AppColors.textWhite,
                    ),
                  ),
                ],
                const SizedBox(height: 2),
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
    physics: const NeverScrollableScrollPhysics(),
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
