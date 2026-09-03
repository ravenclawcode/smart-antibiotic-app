import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import 'package:smart_antibiotic/providers/antibiotic_provider.dart';
import 'package:smart_antibiotic/utils/app_assets.dart';
import 'package:smart_antibiotic/utils/app_colors.dart';
import 'package:smart_antibiotic/utils/app_text.dart';
import 'package:smart_antibiotic/utils/custom_antibiotik_card.dart';

class EducationAntibiotikScreen extends StatefulWidget {
  final int categoryId;
  final String categoryName;

  const EducationAntibiotikScreen({
    super.key,
    required this.categoryId,
    required this.categoryName,
  });

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
      await context.read<AntibioticProvider>().loadAntibiotics(
        widget.categoryId,
      );
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AntibioticProvider>(
      builder: (context, provider, child) {
        final isLoading = _isLoading || provider.isLoadingAntibiotics;

        return AnnotatedRegion<SystemUiOverlayStyle>(
          value: const SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: Brightness.light,
            statusBarBrightness: Brightness.dark,
          ),
          child: Scaffold(
            body: Column(
              children: [
                _buildHeader(
                  context,
                  categoryName: widget.categoryName,
                  isLoading: isLoading,
                  count: provider.antibiotics.length,
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: isLoading
                        ? _buildShimmerList()
                        : _buildList(context, provider),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildList(BuildContext context, AntibioticProvider provider) {
    if (provider.antibioticError != null) {
      return Center(child: Text(provider.antibioticError!));
    }

    if (provider.antibiotics.isEmpty) {
      return const Center(
        child: Text('Belum ada antibiotik pada kategori ini.'),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.zero,
      itemCount: provider.antibiotics.length,
      itemBuilder: (context, index) {
        final antibiotic = provider.antibiotics[index];

        return Padding(
          padding: EdgeInsets.only(top: index == 0 ? 20 : 0, bottom: 10),
          child: CustomAntibiotikCard(
            title: antibiotic.name,
            image: antibiotic.image != null
                ? Image.network(
                    antibiotic.image!,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return Image.asset(imgManyPills, fit: BoxFit.contain);
                    },
                  )
                : Image.asset(imgManyPills, fit: BoxFit.contain),
            onTap: () {
              Navigator.pushNamed(
                context,
                '/education-detail',
                arguments: {
                  'categoryId': widget.categoryId,
                  'antibioticId': antibiotic.id,
                },
              );
            },
          ),
        );
      },
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
            padding: EdgeInsets.only(top: index == 0 ? 20 : 0, bottom: 10),
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

Widget _buildHeader(
  BuildContext context, {
  required String categoryName,
  required bool isLoading,
  required int count,
}) {
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
                      child: const Icon(
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
                    categoryName,
                    style: AppTextStyles.titleLarge.copyWith(
                      color: AppColors.textWhite,
                    ),
                  ),

                  const SizedBox(height: 4),

                  Text(
                    '$count Obat',
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
