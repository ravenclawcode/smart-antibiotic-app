import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:smart_antibiotic/utils/custom_dialog_quit_quiz.dart';

import '../../providers/quiz_provider.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_text.dart';
import '../../utils/custom_button.dart';
import '../../utils/custom_button_off.dart';
import '../../utils/custom_loading.dart';
import '../../utils/custom_option_quiz.dart';
import '../../utils/custom_progress_bar.dart';

class QuizQuestion {
  final String question;
  final List<String> options;
  final int correctAnswerIndex;

  QuizQuestion({
    required this.question,
    required this.options,
    required this.correctAnswerIndex,
  });
}

class QuizDetailScreen extends StatefulWidget {
  final int quizId;

  const QuizDetailScreen({super.key, required this.quizId});

  @override
  State<QuizDetailScreen> createState() => _QuizDetailScreenState();
}

class _QuizDetailScreenState extends State<QuizDetailScreen> {
  final PageController _pageController = PageController();

  int _currentPage = 0;
  bool _isInitialLoading = true;
  bool _isSubmitting = false;

  late List<int?> _userAnswers;

  @override
  void initState() {
    super.initState();

    _fetchData();
  }

  Future<void> _fetchData() async {
    await Future.delayed(const Duration(milliseconds: 600));

    if (!mounted) return;

    final provider = context.read<QuizProvider>();

    await provider.loadQuizDetail(widget.quizId);

    if (!mounted) return;

    final questions = provider.questions;

    _userAnswers = List<int?>.filled(questions.length, null);

    setState(() {
      _isInitialLoading = false;
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  double get _progressValue {
    final questions = context.read<QuizProvider>().questions;

    if (questions.isEmpty) {
      return 0;
    }

    return (_currentPage + 1) / questions.length;
  }

  bool get _isNextEnabled {
    if (_userAnswers.isEmpty) {
      return false;
    }

    return _userAnswers[_currentPage] != null;
  }

  void _onOptionSelected(int index) {
    setState(() {
      _userAnswers[_currentPage] = index;
    });
  }

  void _nextPage() {
    final questions = context.read<QuizProvider>().questions;

    if (questions.isEmpty) {
      return;
    }

    if (_currentPage < questions.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _submitQuiz();
    }
  }

  Future<bool> _showExitDialog() async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => const CustomDialogQuitQuiz(),
    );

    if (result == true) {
      if (!mounted) return false;

      Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
    }

    return false;
  }

  Future<void> _submitQuiz() async {
    final provider = context.read<QuizProvider>();

    final questions = provider.questions;

    if (questions.isEmpty) {
      return;
    }

    final answers = <Map<String, dynamic>>[];

    for (int i = 0; i < questions.length; i++) {
      final selectedIndex = _userAnswers[i];

      if (selectedIndex == null) {
        continue;
      }

      final answerLetters = ['A', 'B', 'C', 'D'];

      answers.add({
        'question_id': questions[i].id,
        'answer': answerLetters[selectedIndex],
      });
    }

    setState(() {
      _isSubmitting = true;
    });

    await Future.delayed(const Duration(seconds: 2));

    final success = await provider.submitQuiz(
      quizId: widget.quizId,
      answers: answers,
    );

    if (!mounted) return;

    if (!success) {
      setState(() {
        _isSubmitting = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(provider.errorMessage ?? 'Gagal mengirim kuis.'),
        ),
      );

      return;
    }

    final result = provider.result;

    if (result == null) {
      setState(() {
        _isSubmitting = false;
      });

      return;
    }

    final quizzes = provider.quizzes;

    final currentIndex = quizzes.indexWhere((quiz) => quiz.id == widget.quizId);

    if (currentIndex == -1) {
      setState(() {
        _isSubmitting = false;
      });

      return;
    }

    final currentQuiz = quizzes[currentIndex];

    final bool isLastQuiz = currentIndex == quizzes.length - 1;

    final nextQuiz = !isLastQuiz ? quizzes[currentIndex + 1] : null;

    Navigator.pushNamedAndRemoveUntil(
      context,
      '/quiz-result',
      (route) => false,
      arguments: {
        'quizId': currentQuiz.id,
        'currentLevel': currentQuiz.level,
        'currentDescription': currentQuiz.description,
        'score': result.correctAnswers,
        'totalQuestions': result.totalQuestions,
        'isLastQuiz': isLastQuiz,
        'nextQuizId': nextQuiz?.id,
        'nextLevel': nextQuiz?.level,
        'nextDescription': nextQuiz?.description,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<QuizProvider>();
    final questions = provider.questions;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        _showExitDialog();
      },
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.light,
        ),
        child: Scaffold(
          body: Stack(
            children: [
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 26),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 14),

                      _buildHeader(
                        context,
                        progressValue: _progressValue,
                        currentPage: _currentPage + 1,
                        totalQuestions: questions.length,
                        onBackTap: _showExitDialog,
                        isLoading: _isInitialLoading,
                        level: provider.selectedQuiz?.level ?? 1,
                      ),
                      const SizedBox(height: 24),
                      Expanded(
                        child: _isInitialLoading
                            ? _buildShimmerContent()
                            : PageView.builder(
                                controller: _pageController,
                                physics: const NeverScrollableScrollPhysics(),
                                onPageChanged: (page) {
                                  setState(() {
                                    _currentPage = page;
                                  });
                                },
                                itemCount: questions.length,
                                itemBuilder: (context, index) {
                                  final question = questions[index];

                                  return _buildContent(
                                    question: question.question,
                                    options: question.options,
                                    selectedIndex: _userAnswers[index],
                                    onSelectOption: _onOptionSelected,
                                  );
                                },
                              ),
                      ),
                      if (!_isInitialLoading) ...[
                        _buildActionButton(
                          _currentPage,
                          questions.length,
                          _isNextEnabled,
                          _nextPage,
                        ),
                        const SizedBox(height: 30),
                      ],
                    ],
                  ),
                ),
              ),
              if (_isSubmitting)
                Container(
                  color: AppColors.textPrimary.withValues(alpha: 0.4),
                  child: const Center(child: CustomLoading()),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildShimmerContent() {
    return Shimmer.fromColors(
      baseColor: AppColors.surfaceSecondary,
      highlightColor: AppColors.surfaceCool,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            height: 20,
            decoration: BoxDecoration(
              color: AppColors.surfacePrimary,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(height: 8),
          Container(
            width: 220,
            height: 20,
            decoration: BoxDecoration(
              color: AppColors.surfacePrimary,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(height: 10),
          Container(
            width: 180,
            height: 14,
            decoration: BoxDecoration(
              color: AppColors.surfacePrimary,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(height: 24),
          Expanded(
            child: ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 4,
              padding: EdgeInsets.zero,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Container(
                    width: double.infinity,
                    height: 66,
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
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            color: AppColors.surfacePrimary,
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Container(
                            height: 22,
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
          ),
          Container(
            width: double.infinity,
            height: 70,
            decoration: BoxDecoration(
              color: AppColors.surfacePrimary,
              borderRadius: BorderRadius.circular(50),
            ),
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }
}

Widget _buildHeader(
  BuildContext context, {
  required double progressValue,
  required int currentPage,
  required int totalQuestions,
  required VoidCallback onBackTap,
  required bool isLoading,
  required int level,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      if (isLoading)
        Shimmer.fromColors(
          baseColor: AppColors.surfaceSecondary,
          highlightColor: AppColors.surfaceCool,
          child: Container(
            width: 36,
            height: 36,
            decoration: const BoxDecoration(
              color: AppColors.surfacePrimary,
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
          onTap: onBackTap,
          child: Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: AppColors.surfaceAccent,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(
              Icons.close_rounded,
              size: 22,
              color: AppColors.primary,
            ),
          ),
        ),
      const SizedBox(height: 20),
      if (isLoading)
        Shimmer.fromColors(
          baseColor: AppColors.surfaceSecondary,
          highlightColor: AppColors.surfaceCool,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 60,
                    height: 22,
                    decoration: BoxDecoration(
                      color: AppColors.surfacePrimary,
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Container(
                    width: 100,
                    height: 16,
                    decoration: BoxDecoration(
                      color: AppColors.surfacePrimary,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Container(
                width: double.infinity,
                height: 6,
                decoration: BoxDecoration(
                  color: AppColors.surfacePrimary,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ],
          ),
        )
      else ...[
        Row(
          children: [
            Container(
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 2,
                ),
                child: Text(
                  'Level $level',
                  style: AppTextStyles.labelMedium.copyWith(
                    color: AppColors.textWhite,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Text(
              'Pertanyaan $currentPage/$totalQuestions',
              style: AppTextStyles.bodySmall,
            ),
          ],
        ),
        const SizedBox(height: 14),
        CustomProgressBar(value: progressValue, height: 6),
      ],
    ],
  );
}

Widget _buildContent({
  required String question,
  required List<String> options,
  required int? selectedIndex,
  required Function(int) onSelectOption,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        question,
        style: AppTextStyles.titleSmall.copyWith(fontWeight: FontWeight.bold),
      ),
      const SizedBox(height: 6),
      Text(
        'Pilih 1 jawaban yang paling tepat',
        style: AppTextStyles.bodyMedium.copyWith(
          color: AppColors.textSecondary,
        ),
      ),
      const SizedBox(height: 22),
      Expanded(
        child: ListView.builder(
          itemCount: options.length,
          padding: EdgeInsets.zero,
          itemBuilder: (context, index) {
            final optionLetters = ['A', 'B', 'C', 'D'];
            final isSelected = selectedIndex == index;

            return Column(
              children: [
                CustomOptionQuiz(
                  option: optionLetters[index],
                  text: options[index],
                  color: isSelected
                      ? AppColors.surfaceAccent
                      : AppColors.surfaceSecondary,
                  onTap: () => onSelectOption(index),
                ),
                const SizedBox(height: 10),
              ],
            );
          },
        ),
      ),
    ],
  );
}

Widget _buildActionButton(
  int currentPage,
  int totalQuestions,
  bool isNextEnabled,
  VoidCallback nextPage,
) {
  final String label = currentPage == totalQuestions - 1 ? 'Kirim' : 'Lanjut';

  return isNextEnabled
      ? CustomButton(onTap: nextPage, label: label)
      : CustomButtonOff(label: label);
}
