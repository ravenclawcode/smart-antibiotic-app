import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import 'package:smart_antibiotic/providers/antibiotic_provider.dart';
import 'package:smart_antibiotic/utils/app_colors.dart';
import 'package:smart_antibiotic/utils/app_text.dart';
import 'package:smart_antibiotic/utils/custom_video_card.dart';
import 'package:smart_antibiotic/utils/custom_youtube_player_screen.dart';

class EducationAntibiotikDetailScreen extends StatefulWidget {
  final int categoryId;
  final int antibioticId;

  const EducationAntibiotikDetailScreen({
    super.key,
    required this.categoryId,
    required this.antibioticId,
  });

  @override
  State<EducationAntibiotikDetailScreen> createState() =>
      _EducationAntibiotikDetailScreenState();
}

class _EducationAntibiotikDetailScreenState
    extends State<EducationAntibiotikDetailScreen> {
  String selectedCategory = 'Ringkasan';
  bool _isLoading = true;

  final ScrollController _scrollController = ScrollController();
  final Map<String, GlobalKey> _sectionKeys = {};

  final List<String> _tabs = [
    'Ringkasan',
    'Indikasi',
    'Mekanisme',
    'Dosis',
    'Video',
  ];

  @override
  void initState() {
    super.initState();

    for (final item in _tabs) {
      _sectionKeys[item] = GlobalKey();
    }

    _fetchData();
  }

  Future<void> _fetchData() async {
    await Future.delayed(const Duration(milliseconds: 600));
    if (mounted) {
      await context.read<AntibioticProvider>().loadDetail(
        categoryId: widget.categoryId,
        antibioticId: widget.antibioticId,
      );
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToSection(String category) {
    final key = _sectionKeys[category];

    if (key != null && key.currentContext != null) {
      Scrollable.ensureVisible(
        key.currentContext!,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        alignment: 0.0,
      );
    }
  }

  void _onCategorySelected(String category) {
    setState(() {
      selectedCategory = category;
    });

    _scrollToSection(category);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AntibioticProvider>(
      builder: (context, provider, child) {
        final detail = provider.detail;
        final isLoading = _isLoading || provider.isLoadingDetail;

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
                  title: detail?.name ?? '',
                  selectedCategory: selectedCategory,
                  onCategorySelected: _onCategorySelected,
                  isLoading: isLoading,
                ),

                Expanded(
                  child: isLoading
                      ? _buildShimmerContent()
                      : provider.detailError != null
                      ? Center(child: Text(provider.detailError!))
                      : detail == null
                      ? const Center(child: Text('Data tidak ditemukan.'))
                      : _buildContent(detail),
                ),

                const SizedBox(height: 26),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildContent(dynamic detail) {
    final List<Map<String, dynamic>> items = [
      {'title': 'Ringkasan', 'description': detail.summary ?? ''},
      {'title': 'Indikasi', 'description': detail.indication ?? ''},
      {'title': 'Mekanisme', 'description': detail.mechanism ?? ''},
      {'title': 'Dosis', 'description': detail.dosage ?? ''},
      {'title': 'Video', 'videoUrl': detail.videoUrl},
    ];

    return SingleChildScrollView(
      controller: _scrollController,
      child: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        padding: EdgeInsets.zero,
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];

          final String title = item['title'] as String;
          final String description = item['description']?.toString() ?? '';
          final String? videoUrl = item['videoUrl']?.toString();

          final bool isVideo = title == 'Video';

          final List<String> lines = description.split('\n');

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                key: _sectionKeys[title],
                padding: const EdgeInsets.only(top: 20),
                child: Container(
                  height: 36,
                  width: double.infinity,
                  color: AppColors.surfaceAccent,
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text(title, style: AppTextStyles.bodyLarge),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: isVideo
                    ? videoUrl != null && videoUrl.isNotEmpty
                          ? CustomVideoCard(
                              videoUrl: videoUrl,
                              title: detail.videoTitle,
                              duration: detail.videoDuration,
                              thumbnailUrl: detail.videoThumbnail,
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => CustomYoutubePlayerScreen(
                                      videoUrl: videoUrl,
                                    ),
                                  ),
                                );
                              },
                            )
                          : Text(
                              'Video belum tersedia.',
                              style: AppTextStyles.bodyMedium,
                            )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: lines.map<Widget>((line) {
                          final trimmed = line.trim();

                          if (trimmed.isEmpty) {
                            return const SizedBox(height: 8);
                          }

                          if (trimmed.startsWith('•')) {
                            final cleanText = trimmed.replaceFirst(
                              RegExp(r'^•\s*'),
                              '',
                            );

                            return Padding(
                              padding: const EdgeInsets.only(bottom: 4),
                              child: _buildBulletItem(cleanText),
                            );
                          }

                          return Padding(
                            padding: const EdgeInsets.only(bottom: 4),
                            child: Text(
                              line,
                              style: AppTextStyles.bodyMedium.copyWith(
                                fontSize: 18,
                              ),
                            ),
                          );
                        }).toList(),
                      ),
              ),

              const SizedBox(height: 4),
            ],
          );
        },
      ),
    );
  }

  Widget _buildBulletItem(String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4),
          child: Text(
            '• ',
            style: AppTextStyles.bodyMedium.copyWith(fontSize: 18),
          ),
        ),
        Expanded(
          child: Text(
            text,
            style: AppTextStyles.bodyMedium.copyWith(fontSize: 18, height: 1.4),
          ),
        ),
      ],
    );
  }

  Widget _buildShimmerContent() {
    return Shimmer.fromColors(
      baseColor: AppColors.surfaceSecondary,
      highlightColor: AppColors.surfaceCool,
      child: SingleChildScrollView(
        child: Column(
          children: List.generate(4, (index) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Container(
                    height: 36,
                    width: double.infinity,
                    color: AppColors.surfacePrimary,
                  ),
                ),
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: double.infinity,
                        height: 16,
                        decoration: BoxDecoration(
                          color: AppColors.surfacePrimary,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        width: double.infinity,
                        height: 16,
                        decoration: BoxDecoration(
                          color: AppColors.surfacePrimary,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        width: 220,
                        height: 16,
                        decoration: BoxDecoration(
                          color: AppColors.surfacePrimary,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
              ],
            );
          }),
        ),
      ),
    );
  }
}

Widget _buildHeader(
  BuildContext context, {
  required String title,
  required String selectedCategory,
  required ValueChanged<String> onCategorySelected,
  required bool isLoading,
}) {
  return Container(
    height: 164,
    width: double.infinity,
    color: AppColors.primary,
    child: SafeArea(
      bottom: false,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
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
                      child: const Icon(
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
                      width: 150,
                      height: 22,
                      decoration: BoxDecoration(
                        color: AppColors.accent,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  )
                else
                  Expanded(
                    child: Text(
                      title,
                      style: AppTextStyles.titleLarge.copyWith(
                        color: AppColors.textWhite,
                      ),
                    ),
                  ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          if (isLoading)
            Shimmer.fromColors(
              baseColor: AppColors.accent,
              highlightColor: AppColors.primary,
              child: SizedBox(
                height: 38,
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  scrollDirection: Axis.horizontal,
                  itemCount: 5,
                  itemBuilder: (context, index) {
                    return Container(
                      width: 80,
                      margin: const EdgeInsets.only(right: 12),
                      decoration: BoxDecoration(
                        color: AppColors.accent,
                        borderRadius: BorderRadius.circular(20),
                      ),
                    );
                  },
                ),
              ),
            )
          else
            _buildTabBar(selectedCategory, onCategorySelected),

          const SizedBox(height: 4),
        ],
      ),
    ),
  );
}

Widget _buildTabBar(
  String selectedCategory,
  ValueChanged<String> onCategorySelected,
) {
  final items = ['Ringkasan', 'Indikasi', 'Mekanisme', 'Dosis', 'Video'];

  return SizedBox(
    height: 38,
    child: ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      scrollDirection: Axis.horizontal,
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];

        final selected = selectedCategory == item;

        return InkWell(
          focusColor: Colors.transparent,
          hoverColor: Colors.transparent,
          highlightColor: Colors.transparent,
          splashColor: Colors.transparent,
          onTap: () => onCategorySelected(item),
          child: Container(
            margin: EdgeInsets.only(right: index == items.length - 1 ? 0 : 12),
            padding: const EdgeInsets.symmetric(horizontal: 15),
            decoration: BoxDecoration(
              color: selected ? AppColors.surfacePrimary : AppColors.accent,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Center(
              child: Text(
                item,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: selected ? AppColors.primary : AppColors.textWhite,
                  fontWeight: selected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ),
          ),
        );
      },
    ),
  );
}
