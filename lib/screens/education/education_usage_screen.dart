import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shimmer/shimmer.dart';

import '../../utils/app_assets.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_text.dart';
import '../../utils/custom_list_card.dart';

class EducationUsageScreen extends StatefulWidget {
  const EducationUsageScreen({super.key});

  @override
  State<EducationUsageScreen> createState() => _EducationUsageScreenState();
}

class _EducationUsageScreenState extends State<EducationUsageScreen> {
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
            Expanded(
              child: SingleChildScrollView(
                child: _isLoading
                    ? _buildShimmerContent()
                    : _buildContent(context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShimmerContent() {
    return Shimmer.fromColors(
      baseColor: AppColors.surfaceSecondary,
      highlightColor: AppColors.surfaceCool,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 26),
            Container(
              width: double.infinity,
              height: 18,
              decoration: BoxDecoration(
                color: AppColors.surfacePrimary,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            const SizedBox(height: 6),
            Container(
              width: 240,
              height: 18,
              decoration: BoxDecoration(
                color: AppColors.surfacePrimary,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            const SizedBox(height: 16),
            ListView.builder(
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
                      border: Border.all(
                        color: AppColors.surfacePrimary,
                        width: 1,
                      ),
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
                                width: 180,
                                height: 16,
                                decoration: BoxDecoration(
                                  color: AppColors.surfacePrimary,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                              const SizedBox(height: 6),
                              Container(
                                width: double.infinity,
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
          ],
        ),
      ),
    );
  }
}

Widget _buildHeader(BuildContext context, {required bool isLoading}) {
  final isSmallScreen = MediaQuery.of(context).size.width < 360;

  return Container(
    height: 115,
    width: double.infinity,
    color: AppColors.primary,
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: SafeArea(
        bottom: false,
        child: Row(
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
            Expanded(
              child: isLoading
                  ? Shimmer.fromColors(
                      baseColor: AppColors.accent,
                      highlightColor: AppColors.primary,
                      child: Container(
                        width: 200,
                        height: 22,
                        decoration: BoxDecoration(
                          color: AppColors.accent,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    )
                  : Text(
                      'Cara Penggunaan Antibiotik',
                      style: AppTextStyles.titleLarge.copyWith(
                        fontSize: isSmallScreen ? 24 : 21,
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
        const SizedBox(height: 26),
        Text(
          'Beberapa hal yang perlu diperhatikan dalam penggunaan antibiotik:',
          style: AppTextStyles.bodyMedium.copyWith(fontSize: 18),
        ),
        const SizedBox(height: 16),
        _buildList(context),
      ],
    ),
  );
}

Widget _buildList(BuildContext context) {
  final item = [
    {
      'title': 'Gunakan sesuai resep dokter',
      'subtitle': 'Jangan membeli tanpa resep',
      'image': Image.asset(imgDoctor),
    },
    {
      'title': 'Habiskan sesuai aturan',
      'subtitle':
          'Jangan berhenti di tengah jalan meskipun merasa sudah sembuh',
      'image': Image.asset(imgCalendar),
    },
    {
      'title': 'Gunakan sesuai resep dokter',
      'subtitle': 'Ikuti dosis dan jadwal yang di anjurkan',
      'image': Image.asset(imgPills),
    },
    {
      'title': 'Jangan berbagi antibiotik',
      'subtitle':
          'Obat yang cocok untuk orang lain belum tentu cocok untuk Anda.',
      'image': Image.asset(imgPeople),
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
        child: CustomListCard(
          title: menu['title'] as String,
          subtitle: menu['subtitle'] as String,
          image: menu['image'] as Image,
          color: const Color(0xFFE0EDFA),
        ),
      );
    },
  );
}
