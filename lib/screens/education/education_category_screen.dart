import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shimmer/shimmer.dart';
import 'package:smart_antibiotic/utils/app_assets.dart';
import 'package:smart_antibiotic/utils/custom_category_card.dart';
import 'package:smart_antibiotic/utils/custom_search_bar.dart';

import '../../utils/app_colors.dart';
import '../../utils/app_text.dart';

class EducationCategoryScreen extends StatefulWidget {
  const EducationCategoryScreen({super.key});

  @override
  State<EducationCategoryScreen> createState() =>
      _EducationCategoryScreenState();
}

class _EducationCategoryScreenState extends State<EducationCategoryScreen> {
  final searchController = TextEditingController();
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
  void dispose() {
    searchController.dispose();
    super.dispose();
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
            _buildHeader(context, searchController, isLoading: _isLoading),
            const SizedBox(height: 20),
            Expanded(child: _isLoading ? _buildShimmerList() : _buildList()),
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
            padding: const EdgeInsets.only(bottom: 10, left: 20, right: 20),
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 140,
                          height: 16,
                          decoration: BoxDecoration(
                            color: AppColors.surfacePrimary,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Container(
                          width: 80,
                          height: 14,
                          decoration: BoxDecoration(
                            color: AppColors.surfacePrimary,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ],
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

Widget _buildHeader(
  BuildContext context,
  TextEditingController searchController, {
  required bool isLoading,
}) {
  return Container(
    height: 180,
    width: double.infinity,
    color: AppColors.primary,
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: SafeArea(
        bottom: false,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
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
                const SizedBox(width: 14),
                if (isLoading)
                  Shimmer.fromColors(
                    baseColor: AppColors.accent,
                    highlightColor: AppColors.primary,
                    child: Container(
                      width: 220,
                      height: 22,
                      decoration: BoxDecoration(
                        color: AppColors.accent,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  )
                else
                  Text(
                    'Kategori Antibiotik',
                    style: AppTextStyles.titleLarge.copyWith(
                      color: AppColors.textWhite,
                    ),
                  ),
                const Spacer(),
              ],
            ),
            const SizedBox(height: 16),
            if (isLoading)
              Shimmer.fromColors(
                baseColor: AppColors.accent,
                highlightColor: AppColors.primary,
                child: Container(
                  width: double.infinity,
                  height: 48,
                  decoration: BoxDecoration(
                    color: AppColors.accent,
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
              )
            else
              CustomSearchBar(controller: searchController),
          ],
        ),
      ),
    ),
  );
}

Widget _buildList() {
  final item = [
    {
      'title': 'Penisilin',
      'subtitle': '4 obat',
      'image': Image.asset(imgManyPills),
      'route': '/education-antibiotik',
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
        padding: const EdgeInsets.only(bottom: 10, left: 20, right: 20),
        child: CustomCategoryCard(
          title: menu['title'] as String,
          subtitle: menu['subtitle'] as String,
          image: menu['image'] as Image,
          onTap: () => Navigator.pushNamed(context, menu['route'] as String),
        ),
      );
    },
  );
}
