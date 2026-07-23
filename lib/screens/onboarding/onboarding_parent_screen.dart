import 'package:flutter/material.dart';
import 'package:smart_antibiotic/utils/app_colors.dart';
import 'package:smart_antibiotic/utils/custom_button.dart';
import 'package:smart_antibiotic/utils/custom_button_off.dart';
import 'package:smart_antibiotic/utils/custom_loading.dart';
import 'package:smart_antibiotic/utils/custom_progress_bar_onboarding.dart';

import 'onboarding_input_name_screen.dart';
import 'onboarding_reminder_sound_screen.dart';
import 'onboarding_reminder_type_screen.dart';

class OnboardingParentScreen extends StatefulWidget {
  const OnboardingParentScreen({super.key});

  @override
  State<OnboardingParentScreen> createState() => _OnboardingParentScreenState();
}

class _OnboardingParentScreenState extends State<OnboardingParentScreen> {
  final PageController _pageController = PageController();
  final GlobalKey<FormState> _formKeyName = GlobalKey<FormState>();

  int _currentPage = 0;
  String _nameInputted = '';
  String _selectedType = '';
  String _selectedSound = '';
  bool _isLoading = false;

  double get _progressValue => (_currentPage + 1) / 3;

  bool get _isNextEnabled {
    if (_currentPage == 0) return _nameInputted.trim().isNotEmpty;
    if (_currentPage == 1) return _selectedType.isNotEmpty;
    if (_currentPage == 2) return _selectedSound.isNotEmpty;
    return false;
  }

  void _nextPage() {
    if (_currentPage == 0) {
      if (!(_formKeyName.currentState?.validate() ?? false)) return;
    }

    if (_currentPage < 2) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _submitData();
    }
  }

  void _previousPage() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      Navigator.pop(context);
    }
  }

  Future<void> _submitData() async {
    setState(() => _isLoading = true);

    try {
      await Future.delayed(const Duration(seconds: 2));

      if (!mounted) return;
      Navigator.pushNamed(context, '/onboarding-permission');
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Gagal menyimpan data: $e')));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 26),
              child: Column(
                children: [
                  const SizedBox(height: 14),
                  _buildHeader(),
                  const SizedBox(height: 20),
                  Expanded(
                    child: PageView(
                      controller: _pageController,
                      physics: const NeverScrollableScrollPhysics(),
                      onPageChanged: (index) {
                        setState(() => _currentPage = index);
                      },
                      children: [
                        OnboardingInputNameContent(
                          formKey: _formKeyName,
                          initialValue: _nameInputted,
                          onNameChanged: (val) {
                            setState(() => _nameInputted = val);
                          },
                        ),
                        OnboardingReminderTypeContent(
                          selectedType: _selectedType,
                          onSelectType: (type) {
                            setState(() => _selectedType = type);
                          },
                        ),
                        OnboardingReminderSoundContent(
                          selectedSound: _selectedSound,
                          onSelectSound: (sound) {
                            setState(() => _selectedSound = sound);
                          },
                        ),
                      ],
                    ),
                  ),
                  _buildActionButton(),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
          if (_isLoading)
            Container(
              color: AppColors.textPrimary.withValues(alpha: 0.4),
              child: const Center(child: CustomLoading()),
            ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        InkWell(
          focusColor: Colors.transparent,
          hoverColor: Colors.transparent,
          highlightColor: Colors.transparent,
          splashColor: Colors.transparent,
          onTap: _previousPage,
          child: Padding(
            padding: const EdgeInsets.only(right: 6),
            child: Icon(
              Icons.arrow_back_ios_new_rounded,
              size: 26,
              color: AppColors.primary,
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(child: CustomProgressBarOnboarding(value: _progressValue)),
      ],
    );
  }

  Widget _buildActionButton() {
    final String label = _currentPage == 2 ? 'Simpan' : 'Lanjut';

    return _isNextEnabled
        ? CustomButton(onTap: _nextPage, label: label)
        : CustomButtonOff(label: label);
  }
}
