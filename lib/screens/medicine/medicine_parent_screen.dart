import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shimmer/shimmer.dart';
import 'package:smart_antibiotic/screens/medicine/medicine_choose_day_screen.dart';
import 'package:smart_antibiotic/screens/medicine/medicine_choose_format_screen.dart';
import 'package:smart_antibiotic/screens/medicine/medicine_choose_frequency_screen.dart';
import 'package:smart_antibiotic/screens/medicine/medicine_information_schedule_screen.dart';
import 'package:smart_antibiotic/screens/medicine/medicine_input_dosage_screen.dart';
import 'package:smart_antibiotic/screens/medicine/medicine_input_instructions_screen.dart';
import 'package:smart_antibiotic/screens/medicine/medicine_input_name_screen.dart';
import 'package:smart_antibiotic/screens/medicine/medicine_many_times_day_screen.dart';
import 'package:smart_antibiotic/screens/medicine/medicine_many_times_month_screen.dart';
import 'package:smart_antibiotic/screens/medicine/medicine_set_interval_screen.dart';
import 'package:smart_antibiotic/screens/medicine/medicine_set_schedule_hour_screen.dart';
import 'package:smart_antibiotic/utils/app_colors.dart';
import 'package:smart_antibiotic/utils/custom_button.dart';
import 'package:smart_antibiotic/utils/custom_button_off.dart';
import 'package:smart_antibiotic/utils/custom_loading.dart';
import 'package:smart_antibiotic/utils/custom_progress_bar.dart';

import '../../utils/custom_change_hour_sheet.dart';

enum StepType {
  name,
  format,
  frequency,
  interval,
  chooseDays,
  chooseMonthDates,
  timesPerDay,
  scheduleSummary,
  singleHourPicker,
  dosage,
  instructions,
}

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
  final GlobalKey<FormState> _formKeyInterval = GlobalKey<FormState>();
  final GlobalKey<FormState> _formKeyChooseDays = GlobalKey<FormState>();
  final GlobalKey<FormState> _formKeyChooseMonthDates = GlobalKey<FormState>();
  final GlobalKey<FormState> _formKeyTimesPerDay = GlobalKey<FormState>();
  final GlobalKey<FormState> _formKeyScheduleSummary = GlobalKey<FormState>();
  final GlobalKey<FormState> _formKeySingleHourPicker = GlobalKey<FormState>();
  final GlobalKey<FormState> _formKeyDosage = GlobalKey<FormState>();
  final GlobalKey<FormState> _formKeyInstructions = GlobalKey<FormState>();

  int _currentPageIndex = 0;

  String _nameInputted = '';
  String _selectedFormat = '';
  String _selectedFrequency = '';

  String _intervalValue = '1';
  List<int> _selectedDaysOfWeek = [];
  String _selectedMonthDates = '';

  int _timesPerDay = 1;
  List<TimeOfDay> _scheduleTimes = [const TimeOfDay(hour: 7, minute: 0)];

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

  List<StepType> get _flowSteps {
    final List<StepType> steps = [
      StepType.name,
      StepType.format,
      StepType.frequency,
    ];

    switch (_selectedFrequency) {
      case '1 kali sehari':
        steps.add(StepType.singleHourPicker);
        break;

      case '2 kali sehari':
      case '3 kali sehari':
        steps.add(StepType.scheduleSummary);
        break;

      case 'Lebih dari 3 kali sehari':
        steps.add(StepType.timesPerDay);
        steps.add(StepType.scheduleSummary);
        break;

      case 'Hari Tertentu':
        steps.add(StepType.chooseDays);
        steps.add(StepType.timesPerDay);
        steps.add(StepType.scheduleSummary);
        break;

      case 'Setiap X Hari':
      case 'Setiap X Minggu':
        steps.add(StepType.interval);
        if (_selectedFrequency == 'Setiap X Minggu') {
          steps.add(StepType.chooseDays);
        }
        steps.add(StepType.timesPerDay);
        steps.add(StepType.scheduleSummary);
        break;

      case 'Setiap X Bulan':
        steps.add(StepType.interval);
        steps.add(StepType.chooseMonthDates);
        steps.add(StepType.timesPerDay);
        steps.add(StepType.scheduleSummary);
        break;

      default:
        steps.add(StepType.scheduleSummary);
        break;
    }

    steps.add(StepType.dosage);
    steps.add(StepType.instructions);

    return steps;
  }

  double get _progressValue {
    final steps = _flowSteps;
    if (steps.isEmpty) return 0.0;

    if (_currentPageIndex == 2) {
      return 3 / 8;
    }

    return (_currentPageIndex + 1) / steps.length;
  }

  bool get _isNextEnabled {
    if (_currentPageIndex >= _flowSteps.length) return false;
    final currentStep = _flowSteps[_currentPageIndex];

    switch (currentStep) {
      case StepType.name:
        return _nameInputted.trim().isNotEmpty;
      case StepType.format:
        return _selectedFormat.isNotEmpty;
      case StepType.frequency:
        return _selectedFrequency.isNotEmpty;
      case StepType.interval:
        return _intervalValue.isNotEmpty;
      case StepType.chooseDays:
        return _selectedDaysOfWeek.isNotEmpty;
      case StepType.chooseMonthDates:
        return _selectedMonthDates.isNotEmpty;
      case StepType.timesPerDay:
        return _timesPerDay > 0;
      case StepType.scheduleSummary:
      case StepType.singleHourPicker:
        return _scheduleTimes.length == _timesPerDay;
      case StepType.dosage:
        return _dosageInputted != null && _dosageInputted! > 0;
      case StepType.instructions:
        return true;
    }
  }

  void _openChangeHourSheet(int index) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return CustomChangeHourSheet(
          slotIndex: index,
          initialTime: _scheduleTimes[index],
          onSave: (newTime) {
            setState(() {
              _scheduleTimes[index] = newTime;
            });
          },
        );
      },
    );
  }

  void _onFrequencySelected(String frequency) {
    if (_selectedFrequency == frequency) return;

    setState(() {
      _selectedFrequency = frequency;

      _intervalValue = '1';
      _selectedDaysOfWeek = [];
      _selectedMonthDates = '';

      if (frequency == '1 kali sehari') {
        _timesPerDay = 1;
      } else if (frequency == '2 kali sehari') {
        _timesPerDay = 2;
      } else if (frequency == '3 kali sehari') {
        _timesPerDay = 3;
      } else if (frequency == 'Lebih dari 3 kali sehari') {
        _timesPerDay = 4;
      } else {
        _timesPerDay = 1;
      }

      _generateDefaultSchedules();
    });
  }

  void _generateDefaultSchedules() {
    final List<TimeOfDay> defaults = [];
    final defaultHours = [8, 13, 16, 20, 22, 23];
    for (int i = 0; i < _timesPerDay; i++) {
      final h = i < defaultHours.length ? defaultHours[i] : (8 + (i * 2)) % 24;
      defaults.add(TimeOfDay(hour: h, minute: 0));
    }
    _scheduleTimes = defaults;
  }

  String get _scheduleSubtitle {
    switch (_selectedFrequency) {
      case 'Lebih dari 3 kali sehari':
        return '$_timesPerDay kali sehari';
      case 'Hari Tertentu':
        final days = _getFormattedDays(_selectedDaysOfWeek);
        return days.isNotEmpty ? 'Setiap $days' : 'Hari Tertentu';
      case 'Setiap X Hari':
        return 'Setiap $_intervalValue Hari';
      case 'Setiap X Minggu':
        final days = _getFormattedDays(_selectedDaysOfWeek);
        return days.isNotEmpty
            ? 'Setiap $_intervalValue Minggu ($days)'
            : 'Setiap $_intervalValue Minggu';
      case 'Setiap X Bulan':
        return _selectedMonthDates.isNotEmpty
            ? 'Setiap $_intervalValue Bulan (Tanggal $_selectedMonthDates)'
            : 'Setiap $_intervalValue Bulan';
      default:
        return _selectedFrequency.isNotEmpty
            ? _selectedFrequency
            : '2 kali sehari';
    }
  }

  String _getFormattedDays(List<int> days) {
    const dayMap = {
      1: 'Sen',
      2: 'Sel',
      3: 'Rab',
      4: 'Kam',
      5: 'Jum',
      6: 'Sab',
      7: 'Min',
    };
    final sorted = List<int>.from(days)..sort();
    return sorted
        .map((d) => dayMap[d] ?? '')
        .where((s) => s.isNotEmpty)
        .join(', ');
  }

  void _nextPage() {
    if (_currentPageIndex < _flowSteps.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _submitData();
    }
  }

  void _previousPage() {
    if (_currentPageIndex > 0) {
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
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Widget _buildStepWidget(StepType step) {
    switch (step) {
      case StepType.name:
        return MedicineInputNameScreen(
          formKey: _formKeyName,
          initialValue: _nameInputted,
          onNameChanged: (val) => setState(() => _nameInputted = val),
        );

      case StepType.format:
        return MedicineChooseFormatScreen(
          formKey: _formKeyFormat,
          initialValue: _selectedFormat,
          medicineName: _nameInputted,
          onNameChanged: (val) => setState(() => _selectedFormat = val),
        );

      case StepType.frequency:
        return MedicineChooseFrequencyScreen(
          formKey: _formKeyFrequency,
          initialValue: _selectedFrequency,
          onNameChanged: _onFrequencySelected,
        );

      case StepType.interval:
        return MedicineSetIntervalScreen(
          formKey: _formKeyInterval,
          frequencyType: _selectedFrequency,
          initialValue: int.tryParse(_intervalValue) ?? 1,
          onNameChanged: (val) => setState(() => _intervalValue = val),
        );

      case StepType.chooseDays:
        return MedicineChooseDayScreen(
          formKey: _formKeyChooseDays,
          initialSelectedDays: _selectedDaysOfWeek,
          onNameChanged: (val) {
            final days = val
                .split(',')
                .map((e) => int.tryParse(e.trim()))
                .whereType<int>()
                .toList();
            setState(() => _selectedDaysOfWeek = days);
          },
        );

      case StepType.chooseMonthDates:
        return MedicineManyTimesMonthScreen(
          formKey: _formKeyChooseMonthDates,
          initialValue: _selectedMonthDates,
          onNameChanged: (val) => setState(() => _selectedMonthDates = val),
        );

      case StepType.timesPerDay:
        return MedicineManyTimesDayScreen(
          formKey: _formKeyTimesPerDay,
          initialValue: _timesPerDay,
          selectedFrequency: _selectedFrequency,
          onNameChanged: (val) {
            final parsed = int.tryParse(val) ?? 1;
            setState(() {
              _timesPerDay = parsed;
              _generateDefaultSchedules();
            });
          },
        );

      case StepType.scheduleSummary:
        return MedicineInformationScheduleScreen(
          formKey: _formKeyScheduleSummary,
          selectedFrequency: _selectedFrequency,
          subtitle: _scheduleSubtitle,
          scheduleTimes: _scheduleTimes,
          onSlotTapped: _openChangeHourSheet,
        );

      case StepType.singleHourPicker:
        return MedicineSetScheduleHourScreen(
          formKey: _formKeySingleHourPicker,
          initialValue: _scheduleTimes.isNotEmpty
              ? _scheduleTimes.first
              : const TimeOfDay(hour: 7, minute: 0),
          selectedFrequency: _selectedFrequency,
          onNameChanged: (val) {
            final parts = val.split(':');
            if (parts.length == 2) {
              final h = int.tryParse(parts[0]) ?? 7;
              final m = int.tryParse(parts[1]) ?? 0;
              setState(() {
                _scheduleTimes = [TimeOfDay(hour: h, minute: m)];
              });
            }
          },
        );

      case StepType.dosage:
        return MedicineInputDosageScreen(
          formKey: _formKeyDosage,
          initialValue: _dosageInputted?.toString() ?? '',
          onNameChanged: (val) {
            setState(() {
              _dosageInputted = int.tryParse(val);
            });
          },
        );

      case StepType.instructions:
        return MedicineInputInstructionsScreen(
          formKey: _formKeyInstructions,
          initialValue: _instructionInputted,
          onNameChanged: (val) {
            setState(() => _instructionInputted = val);
          },
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final steps = _flowSteps;

    return AnnotatedRegion<SystemUiOverlayStyle>(
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
                child: _isInitialLoading
                    ? _buildShimmerContent()
                    : Column(
                        children: [
                          const SizedBox(height: 14),
                          _buildHeader(),
                          const SizedBox(height: 20),
                          Expanded(
                            child: PageView.builder(
                              controller: _pageController,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: steps.length,
                              onPageChanged: (index) {
                                setState(() => _currentPageIndex = index);
                              },
                              itemBuilder: (context, index) {
                                return _buildStepWidget(steps[index]);
                              },
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
        Transform.translate(
          offset: Offset(-4, 0),
          child: InkWell(
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
        ),
        const SizedBox(width: 4),
        Expanded(child: CustomProgressBar(value: _progressValue, height: 18)),
      ],
    );
  }

  Widget _buildActionButton() {
    final bool isLastStep = _currentPageIndex == _flowSteps.length - 1;
    final String label = isLastStep ? 'Simpan' : 'Lanjut';

    return _isNextEnabled
        ? CustomButton(onTap: _nextPage, label: label)
        : CustomButtonOff(label: label);
  }
}
