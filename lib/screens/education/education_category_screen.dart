import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import 'package:smart_antibiotic/providers/antibiotic_provider.dart';
import 'package:smart_antibiotic/utils/app_assets.dart';
import 'package:smart_antibiotic/utils/app_colors.dart';
import 'package:smart_antibiotic/utils/app_text.dart';
import 'package:smart_antibiotic/utils/custom_category_card.dart';
import 'package:smart_antibiotic/utils/custom_search_bar.dart';

class EducationCategoryScreen extends StatefulWidget {
  const EducationCategoryScreen({super.key});

  @override
  State<EducationCategoryScreen> createState() =>
      _EducationCategoryScreenState();
}

class _EducationCategoryScreenState extends State<EducationCategoryScreen> {
  final searchController = TextEditingController();

  Timer? _searchTimer;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    await Future.delayed(const Duration(milliseconds: 600));
    if (mounted) {
      await context.read<AntibioticProvider>().loadCategories();
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _searchTimer?.cancel();
    searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String value) {
    _searchTimer?.cancel();

    _searchTimer = Timer(const Duration(milliseconds: 400), () {
      if (!mounted) return;

      context.read<AntibioticProvider>().searchCategories(value);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AntibioticProvider>(
      builder: (context, provider, child) {
        final isLoading = _isLoading || provider.isLoadingCategories;
        final hasSearch = searchController.text.trim().isNotEmpty;

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
                  searchController,
                  isLoading: isLoading,
                  onChanged: _onSearchChanged,
                ),

                const SizedBox(height: 20),

                Expanded(
                  child: isLoading
                      ? _buildShimmerList()
                      : hasSearch
                      ? _buildSearchResults(provider)
                      : _buildCategoryList(provider),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildCategoryList(AntibioticProvider provider) {
    if (provider.categoryError != null) {
      return _buildError(provider.categoryError!, () {
        provider.loadCategories();
      });
    }

    if (provider.categories.isEmpty) {
      return Center(
        child: Text(
          'Belum ada kategori antibiotik.',
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.zero,
      itemCount: provider.categories.length,
      itemBuilder: (context, index) {
        final category = provider.categories[index];

        return Padding(
          padding: const EdgeInsets.only(bottom: 10, left: 20, right: 20),
          child: CustomCategoryCard(
            title: category.name,
            subtitle: '${category.antibioticsCount} Obat',
            image: category.image != null
                ? Image.network(category.image!, fit: BoxFit.contain)
                : Image.asset(imgManyPills),
            onTap: () {
              Navigator.pushNamed(
                context,
                '/education-antibiotik',
                arguments: {
                  'categoryId': category.id,
                  'categoryName': category.name,
                },
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildSearchResults(AntibioticProvider provider) {
    if (provider.isSearching) {
      return _buildShimmerList();
    }

    if (provider.searchError != null) {
      return _buildError(provider.searchError!, () {
        provider.searchCategories(searchController.text);
      });
    }

    if (provider.searchResults.isEmpty) {
      return Center(
        child: Text(
          'Kategori antibiotik tidak ditemukan.',
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.zero,
      itemCount: provider.searchResults.length,
      itemBuilder: (context, index) {
        final category = provider.searchResults[index];

        return Padding(
          padding: const EdgeInsets.only(bottom: 10, left: 20, right: 20),
          child: CustomCategoryCard(
            title: category.name,
            subtitle: '${category.antibioticsCount} Obat',
            image: category.image != null
                ? Image.network(
                    category.image!,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return Image.asset(imgManyPills, fit: BoxFit.contain);
                    },
                  )
                : Image.asset(imgManyPills, fit: BoxFit.contain),
            onTap: () {
              Navigator.pushNamed(
                context,
                '/education-antibiotik',
                arguments: {
                  'categoryId': category.id,
                  'categoryName': category.name,
                },
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildError(String message, VoidCallback retry) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(message, textAlign: TextAlign.center),
          const SizedBox(height: 12),
          ElevatedButton(onPressed: retry, child: const Text('Coba lagi')),
        ],
      ),
    );
  }

  Widget _buildShimmerList() {
    return Shimmer.fromColors(
      baseColor: AppColors.surfaceSecondary,
      highlightColor: AppColors.surfaceCool,
      child: ListView.builder(
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
  required ValueChanged<String> onChanged,
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
              CustomSearchBar(
                controller: searchController,
                onChanged: onChanged,
              ),
          ],
        ),
      ),
    ),
  );
}
