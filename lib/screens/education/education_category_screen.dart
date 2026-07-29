import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

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
            _buildHeader(context, searchController),
            SizedBox(height: 20),
            _buildList(),
          ],
        ),
      ),
    );
  }
}

Widget _buildHeader(
  BuildContext context,
  TextEditingController searchController,
) {
  return Container(
    height: 180,
    width: double.infinity,
    color: AppColors.primary,
    child: Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: SafeArea(
        bottom: false,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
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
                  'Kategori Antibiotik',
                  style: AppTextStyles.titleLarge.copyWith(
                    color: AppColors.textWhite,
                  ),
                ),
                Spacer(),
              ],
            ),
            SizedBox(height: 16),
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
    physics: NeverScrollableScrollPhysics(),
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
