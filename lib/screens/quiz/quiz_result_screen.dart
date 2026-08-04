import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shimmer/shimmer.dart';
import 'package:smart_antibiotic/utils/app_assets.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_text.dart';
import '../../utils/custom_button_quiz.dart';

class QuizResultScreen extends StatefulWidget {
  final int score;
  final int totalQuestions;

  const QuizResultScreen({
    super.key,
    required this.score,
    required this.totalQuestions,
  });

  @override
  State<QuizResultScreen> createState() => _QuizResultScreenState();
}

class _QuizResultScreenState extends State<QuizResultScreen> {
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
        body: _isLoading
            ? _buildShimmerContent()
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildHeader(context, widget.score, widget.totalQuestions),
                  const SizedBox(height: 78),
                  _buildActionButton(context),
                  const Spacer(),
                ],
              ),
      ),
    );
  }

  Widget _buildShimmerContent() {
    return Column(
      children: [
        Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              height: 330,
              width: double.infinity,
              color: AppColors.primary,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: SafeArea(
                  bottom: false,
                  child: Shimmer.fromColors(
                    baseColor: AppColors.accent,
                    highlightColor: AppColors.primary,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Spacer(),
                        Container(
                          width: 140,
                          height: 24,
                          decoration: BoxDecoration(
                            color: AppColors.accent,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          width: 220,
                          height: 16,
                          decoration: BoxDecoration(
                            color: AppColors.accent,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Container(
                          width: 120,
                          height: 56,
                          decoration: BoxDecoration(
                            color: AppColors.accent,
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Container(
                          width: 100,
                          height: 14,
                          decoration: BoxDecoration(
                            color: AppColors.accent,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        const SizedBox(height: 78),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              left: 20,
              right: 20,
              bottom: -45,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
                decoration: BoxDecoration(
                  color: AppColors.surfacePrimary,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.textPrimary.withValues(alpha: 0.1),
                      blurRadius: 15,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Shimmer.fromColors(
                  baseColor: AppColors.surfaceSecondary,
                  highlightColor: AppColors.surfaceCool,
                  child: Row(
                    children: [
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: AppColors.surfacePrimary,
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 120,
                            height: 14,
                            decoration: BoxDecoration(
                              color: AppColors.surfacePrimary,
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                          const SizedBox(height: 6),
                          Container(
                            width: 60,
                            height: 16,
                            decoration: BoxDecoration(
                              color: AppColors.surfacePrimary,
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                          const SizedBox(height: 6),
                          Container(
                            width: 90,
                            height: 14,
                            decoration: BoxDecoration(
                              color: AppColors.surfacePrimary,
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 78),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Shimmer.fromColors(
            baseColor: AppColors.surfaceSecondary,
            highlightColor: AppColors.surfaceCool,
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                      color: AppColors.surfacePrimary,
                      borderRadius: BorderRadius.circular(40),
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                      color: AppColors.surfacePrimary,
                      borderRadius: BorderRadius.circular(40),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const Spacer(),
      ],
    );
  }
}

Widget _buildHeader(BuildContext context, int score, int totalQuestions) {
  final double percentage = (score / totalQuestions) * 100;
  final bool isPassed = percentage >= 80;

  return Stack(
    clipBehavior: Clip.none,
    children: [
      Container(
        height: 330,
        width: double.infinity,
        decoration: const BoxDecoration(color: AppColors.primary),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: SafeArea(
            bottom: false,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(),
                Text(
                  isPassed ? 'Selamat!' : 'Coba Lagi!',
                  style: AppTextStyles.titleLarge.copyWith(
                    color: AppColors.textWhite,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  isPassed
                      ? 'Kamu telah menyelesaikan kuis ini'
                      : 'Silakan pelajari kembali materi yang ada!',
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontSize: 17,
                    color: AppColors.textWhite,
                  ),
                  textAlign: TextAlign.center,
                ),
                Text(
                  '${percentage.round()}%',
                  style: AppTextStyles.titleLarge.copyWith(
                    fontSize: 60,
                    color: AppColors.textWhite,
                  ),
                ),
                Text(
                  '$score dari $totalQuestions benar',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textWhite,
                  ),
                ),
                const SizedBox(height: 78),
              ],
            ),
          ),
        ),
      ),
      Positioned(
        left: 20,
        right: 20,
        bottom: -45,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: AppColors.surfacePrimary,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: AppColors.textPrimary.withValues(alpha: 0.1),
                blurRadius: 15,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: const Color(0xFFE0EEFB),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Image.asset(imgKuis2),
                ),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Level Selanjutnya',
                    style: AppTextStyles.bodyMedium.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                  Text(
                    'Level 2',
                    style: AppTextStyles.bodyMedium.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Lorem Ipsum',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    ],
  );
}

Widget _buildActionButton(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: CustomButtonQuiz(
            onTap: () {
              Navigator.pushNamedAndRemoveUntil(
                context,
                '/quiz-detail',
                (route) => false,
              );
            },
            label: 'Ulangi',
            colorText: AppColors.primary,
            colorBg: Colors.transparent,
            colorBorder: AppColors.primary,
          ),
        ),
        const SizedBox(width: 20),
        Expanded(
          child: CustomButtonQuiz(
            onTap: () {
              Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
            },
            label: 'Lanjut',
            colorText: AppColors.textWhite,
            colorBg: AppColors.primary,
            colorBorder: Colors.transparent,
          ),
        ),
      ],
    ),
  );
}
