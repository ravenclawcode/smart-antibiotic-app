import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import '../../models/feedback_model.dart';
import '../../providers/feedback_provider.dart';
import '../../providers/settings_provider.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_text.dart';
import '../../utils/custom_feedback_card.dart';
import '../../utils/custom_input_feedback_form.dart';

class SettingsCommentsAndFeedback extends StatefulWidget {
  const SettingsCommentsAndFeedback({super.key});

  @override
  State<SettingsCommentsAndFeedback> createState() =>
      _SettingsCommentsAndFeedbackState();
}

class _SettingsCommentsAndFeedbackState
    extends State<SettingsCommentsAndFeedback> {
  late TextEditingController feedbackController;
  String _userName = '';

  bool _isInitialLoading = true;

  @override
  void initState() {
    super.initState();

    feedbackController = TextEditingController();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchData();
    });
  }

  @override
  void dispose() {
    feedbackController.dispose();
    super.dispose();
  }

  Future<void> _fetchData() async {
    final feedbackProvider = context.read<FeedbackProvider>();
    final settingsProvider = context.read<SettingsProvider>();

    await Future.wait([
      feedbackProvider.fetchFeedbacks(),
      settingsProvider.loadProfile(),
      Future.delayed(const Duration(milliseconds: 600)),
    ]);

    if (!mounted) return;

    setState(() {
      _userName = settingsProvider.profile?.name ?? 'Pengguna';
      _isInitialLoading = false;
    });
  }

  Future<void> _addFeedback() async {
    final inputText = feedbackController.text.trim();

    if (inputText.isEmpty) {
      return;
    }

    final text = _capitalizeWords(inputText);

    final provider = context.read<FeedbackProvider>();

    final success = await provider.submitFeedback(text);

    if (!mounted) return;

    if (success) {
      feedbackController.clear();
      FocusScope.of(context).unfocus();
    }
  }

  Future<void> _deleteFeedback(FeedbackModel feedback) async {
    final provider = context.read<FeedbackProvider>();

    await provider.deleteFeedback(feedback.id);
  }

  String _capitalizeWords(String input) {
    if (input.trim().isEmpty) {
      return input;
    }

    return input
        .trim()
        .split(RegExp(r'\s+'))
        .map((word) {
          if (word.isEmpty) {
            return word;
          }

          return word[0].toUpperCase() + word.substring(1);
        })
        .join(' ');
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
            _buildHeader(context, isLoading: _isInitialLoading),
            Expanded(
              child: _isInitialLoading
                  ? _buildShimmerContent()
                  : _buildContent(),
            ),
            const SizedBox(height: 26),
          ],
        ),
      ),
    );
  }

  Widget _buildShimmerContent() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFE7ECF0), width: 1),
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Shimmer.fromColors(
                      baseColor: AppColors.surfaceSecondary,
                      highlightColor: AppColors.surfaceCool,
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
                            width: 200,
                            height: 16,
                            decoration: BoxDecoration(
                              color: AppColors.surfacePrimary,
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                          const SizedBox(height: 60),
                        ],
                      ),
                    ),
                  ),
                  const Divider(
                    height: 1,
                    thickness: 1,
                    color: Color(0xFFE7ECF0),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    child: Shimmer.fromColors(
                      baseColor: AppColors.surfaceSecondary,
                      highlightColor: AppColors.surfaceCool,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            width: 60,
                            height: 16,
                            decoration: BoxDecoration(
                              color: AppColors.surfacePrimary,
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                          Container(
                            width: 38,
                            height: 34,
                            decoration: BoxDecoration(
                              color: AppColors.surfacePrimary,
                              borderRadius: BorderRadius.circular(6),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFE7ECF0)),
              ),
              child: Shimmer.fromColors(
                baseColor: AppColors.surfaceSecondary,
                highlightColor: AppColors.surfaceCool,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    width: 60,
                                    height: 24,
                                    decoration: BoxDecoration(
                                      color: AppColors.surfacePrimary,
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Container(
                                    width: 80,
                                    height: 12,
                                    decoration: BoxDecoration(
                                      color: AppColors.surfacePrimary,
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
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
                        const SizedBox(width: 12),
                        Container(
                          width: 16,
                          height: 16,
                          decoration: BoxDecoration(
                            color: AppColors.surfacePrimary,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Container(
                      width: double.infinity,
                      height: 104,
                      decoration: BoxDecoration(
                        color: AppColors.surfacePrimary,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent() {
    return Consumer<FeedbackProvider>(
      builder: (context, provider, child) {
        return SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                const SizedBox(height: 20),
                CustomInputFeedbackForm(
                  controller: feedbackController,
                  userName: _userName,
                  onSubmit: provider.isSubmitting ? () {} : _addFeedback,
                ),
                const SizedBox(height: 30),
                _buildFeedbackList(provider),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildFeedbackList(FeedbackProvider provider) {
    if (provider.feedbacks.isEmpty) {
      return SizedBox();
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: provider.feedbacks.length,
      padding: EdgeInsets.zero,
      itemBuilder: (context, index) {
        final feedback = provider.feedbacks[index];

        return CustomFeedbackCard(
          provider,
          key: ValueKey(feedback.id),
          feedback: feedback,
          onDelete: () {
            _deleteFeedback(feedback);
          },
        );
      },
    );
  }

  Widget _buildHeader(BuildContext context, {required bool isLoading}) {
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
              if (isLoading)
                Shimmer.fromColors(
                  baseColor: AppColors.accent,
                  highlightColor: AppColors.primary,
                  child: Container(
                    width: 180,
                    height: 22,
                    decoration: BoxDecoration(
                      color: AppColors.accent,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                )
              else
                Text(
                  'Komentar & Masukan',
                  style: AppTextStyles.titleLarge.copyWith(
                    color: AppColors.textWhite,
                  ),
                ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
