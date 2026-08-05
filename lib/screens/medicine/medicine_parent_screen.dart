import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:smart_antibiotic/screens/medicine/medicine_choose_format_screen.dart';
import 'package:smart_antibiotic/screens/medicine/medicine_choose_frequency_screen.dart';
import 'package:smart_antibiotic/screens/medicine/medicine_input_dosage_screen.dart';
import 'package:smart_antibiotic/screens/medicine/medicine_input_instructions_screen.dart';
import 'package:smart_antibiotic/screens/medicine/medicine_input_name_screen.dart';
import 'package:smart_antibiotic/screens/medicine/medicine_set_schedule_hour_screen.dart';
import 'package:smart_antibiotic/utils/app_colors.dart';
import 'package:smart_antibiotic/utils/custom_button.dart';
import 'package:smart_antibiotic/utils/custom_button_off.dart';
import 'package:smart_antibiotic/utils/custom_loading.dart';
import 'package:smart_antibiotic/utils/custom_progress_bar.dart';

class MedicineParentScreen extends StatefulWidget {
  const MedicineParentScreen({super.key});

  @override
  State<MedicineParentScreen> createState() => _MedicineParentScreenState();
}

class _MedicineParentScreenState extends State<MedicineParentScreen> {
  final PageController _pageController = PageController();

  final GlobalKey<FormState> _formKeyName = GlobalKey<FormState>();
  final GlobalKey<FormState> _formKeyFormat = GlobalKey<FormState>();
  final GlobalKey<FormState> _formKeyFrequency = GlobalKey<FormState>();
  final GlobalKey<FormState> _formKeySchedule = GlobalKey<FormState>();
  final GlobalKey<FormState> _formKeyDosage = GlobalKey<FormState>();
  final GlobalKey<FormState> _formKeyInstruction = GlobalKey<FormState>();

  int _currentPage = 0;
  String _nameInputted = '';
  String _selectedFormat = '';
  String _selectedFrequency = '';
  String _setScheduleHour = '07:20';
  int? _dosageInputted;
  String _instructionInputted = '';

  bool _isInitialLoading = true;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchInitialData();
  }

  Future<void> _fetchInitialData() async {
    await Future.delayed(const Duration(milliseconds: 600));
    if (mounted) {
      setState(() {
        _isInitialLoading = false;
      });
    }
  }

  double get _progressValue => (_currentPage + 1) / 6;

  bool get _isNextEnabled {
    if (_currentPage == 0) return _nameInputted.trim().isNotEmpty;
    if (_currentPage == 1) return _selectedFormat.isNotEmpty;
    if (_currentPage == 2) return _selectedFrequency.isNotEmpty;
    if (_currentPage == 3) return _setScheduleHour.isNotEmpty;
    if (_currentPage == 4) {
      return _dosageInputted != null && _dosageInputted! > 0;
    }
    if (_currentPage == 5) return true;
    return false;
  }

  void _nextPage() {
    if (_currentPage == 0) {
      if (!(_formKeyName.currentState?.validate() ?? true)) return;
    }

    if (_currentPage < 5) {
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
      Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
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
              child: _isInitialLoading
                  ? _buildShimmerContent()
                  : Column(
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
                              MedicineInputNameScreen(
                                formKey: _formKeyName,
                                initialValue: _nameInputted,
                                onNameChanged: (val) {
                                  setState(() => _nameInputted = val);
                                },
                              ),
                              MedicineChooseFormatScreen(
                                formKey: _formKeyFormat,
                                initialValue: _selectedFormat,
                                medicineName: _nameInputted,
                                onNameChanged: (val) {
                                  setState(() => _selectedFormat = val);
                                },
                              ),
                              MedicineChooseFrequencyScreen(
                                formKey: _formKeyFrequency,
                                initialValue: _selectedFrequency,
                                onNameChanged: (val) {
                                  setState(() => _selectedFrequency = val);
                                },
                              ),
                              MedicineSetScheduleHourScreen(
                                formKey: _formKeySchedule,
                                initialValue: const TimeOfDay(
                                  hour: 7,
                                  minute: 20,
                                ),
                                selectedFrequency: _selectedFrequency,
                                onNameChanged: (val) {
                                  setState(() => _setScheduleHour = val);
                                },
                              ),
                              MedicineInputDosageScreen(
                                formKey: _formKeyDosage,
                                initialValue: _dosageInputted?.toString() ?? '',
                                onNameChanged: (val) {
                                  setState(() {
                                    _dosageInputted = int.tryParse(val);
                                  });
                                },
                              ),
                              MedicineInputInstructionsScreen(
                                formKey: _formKeyInstruction,
                                initialValue: _instructionInputted,
                                onNameChanged: (val) {
                                  setState(() => _instructionInputted = val);
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

  Widget _buildShimmerContent() {
    return Shimmer.fromColors(
      baseColor: AppColors.surfaceSecondary,
      highlightColor: AppColors.surfaceCool,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),
          Row(
            children: [
              Container(
                width: 26,
                height: 26,
                decoration: const BoxDecoration(
                  color: AppColors.surfacePrimary,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Container(
                  height: 18,
                  decoration: BoxDecoration(
                    color: AppColors.surfacePrimary,
                    borderRadius: BorderRadius.circular(9),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
          Container(
            width: 200,
            height: 28,
            decoration: BoxDecoration(
              color: AppColors.surfacePrimary,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(height: 14),
          Container(
            width: double.infinity,
            height: 60,
            decoration: BoxDecoration(
              color: AppColors.surfacePrimary,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          const Spacer(),
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
        Expanded(child: CustomProgressBar(value: _progressValue, height: 18)),
      ],
    );
  }

  Widget _buildActionButton() {
    final String label = _currentPage == 5 ? 'Simpan' : 'Lanjut';

    return _isNextEnabled
        ? CustomButton(onTap: _nextPage, label: label)
        : CustomButtonOff(label: label);
  }
}
