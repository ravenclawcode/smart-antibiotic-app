import 'package:flutter/material.dart';
import 'package:smart_antibiotic/utils/app_colors.dart';
import 'package:smart_antibiotic/utils/custom_button.dart';
import 'package:smart_antibiotic/utils/custom_button_off.dart';
import 'package:smart_antibiotic/utils/custom_medicine_choose_day_sheet.dart';
import 'package:smart_antibiotic/utils/custom_medicine_choose_frequency_sheet.dart';
import 'package:smart_antibiotic/utils/custom_medicine_information_schedule_sheet.dart';
import 'package:smart_antibiotic/utils/custom_medicine_many_times_day_sheet.dart';
import 'package:smart_antibiotic/utils/custom_medicine_many_times_month_sheet.dart';
import 'package:smart_antibiotic/utils/custom_medicine_set_interval_sheet.dart';
import 'package:smart_antibiotic/utils/custom_medicine_set_schedule_hour_sheet.dart';

enum StepType {
  frequency,
  interval,
  chooseDays,
  chooseMonthDates,
  timesPerDay,
  scheduleSummary,
  singleHourPicker,
}

class CustomEditMedicineParentSheet extends StatefulWidget {
  const CustomEditMedicineParentSheet({super.key});

  @override
  State<CustomEditMedicineParentSheet> createState() =>
      _CustomEditMedicineParentSheetState();
}

class _CustomEditMedicineParentSheetState
    extends State<CustomEditMedicineParentSheet> {
  final PageController _pageController = PageController();

  final GlobalKey<FormState> _formKeyFrequency = GlobalKey<FormState>();
  final GlobalKey<FormState> _formKeyInterval = GlobalKey<FormState>();
  final GlobalKey<FormState> _formKeyChooseDays = GlobalKey<FormState>();
  final GlobalKey<FormState> _formKeyChooseMonthDates = GlobalKey<FormState>();
  final GlobalKey<FormState> _formKeyTimesPerDay = GlobalKey<FormState>();
  final GlobalKey<FormState> _formKeyScheduleSummary = GlobalKey<FormState>();
  final GlobalKey<FormState> _formKeySingleHourPicker = GlobalKey<FormState>();

  int _currentPageIndex = 0;

  String _selectedFrequency = '';

  String _intervalValue = '1';
  List<int> _selectedDaysOfWeek = [];
  String _selectedMonthDates = '';

  int _timesPerDay = 1;
  List<TimeOfDay> _scheduleTimes = [const TimeOfDay(hour: 7, minute: 0)];

  List<StepType> get _flowSteps {
    final List<StepType> steps = [StepType.frequency];

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
    return steps;
  }

  bool get _isNextEnabled {
    if (_currentPageIndex >= _flowSteps.length) return false;
    final currentStep = _flowSteps[_currentPageIndex];

    switch (currentStep) {
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
    }
  }

  void _updateScheduleTime(int index, TimeOfDay newTime) {
    setState(() {
      _scheduleTimes[index] = newTime;
    });
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
      _currentPageIndex = 0;
    });

    if (_pageController.hasClients) {
      _pageController.jumpToPage(0);
    }
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
    try {
      if (!mounted) return;
      Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Gagal menyimpan data: $e')));
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Widget _buildStepWidget(StepType step) {
    switch (step) {
      case StepType.frequency:
        return CustomMedicineChooseFrequencySheet(
          formKey: _formKeyFrequency,
          initialValue: _selectedFrequency,
          onNameChanged: _onFrequencySelected,
        );

      case StepType.interval:
        return CustomMedicineSetIntervalSheet(
          formKey: _formKeyInterval,
          frequencyType: _selectedFrequency,
          initialValue: int.tryParse(_intervalValue) ?? 1,
          onNameChanged: (val) => setState(() => _intervalValue = val),
        );

      case StepType.chooseDays:
        return CustomMedicineChooseDaySheet(
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
        return CustomMedicineManyTimesMonthSheet(
          formKey: _formKeyChooseMonthDates,
          initialValue: _selectedMonthDates,
          onNameChanged: (val) => setState(() => _selectedMonthDates = val),
        );

      case StepType.timesPerDay:
        return CustomMedicineManyTimesDaySheet(
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
        return CustomMedicineInformationScheduleSheet(
          formKey: _formKeyScheduleSummary,
          selectedFrequency: _selectedFrequency,
          subtitle: _scheduleSubtitle,
          scheduleTimes: _scheduleTimes,
          onSlotTimeChanged: _updateScheduleTime,
        );

      case StepType.singleHourPicker:
        return CustomMedicineSetScheduleHourSheet(
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
    }
  }

  @override
  Widget build(BuildContext context) {
    final steps = _flowSteps;

    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: AppColors.surfacePrimary,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      child: Stack(
        children: [
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 26),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 12),
                  Center(
                    child: Container(
                      height: 4,
                      width: 50,
                      decoration: BoxDecoration(
                        color: AppColors.textPrimary,
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: PageView.builder(
                      key: ValueKey(_selectedFrequency),
                      controller: _pageController,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: steps.length,
                      onPageChanged: (index) {
                        setState(() => _currentPageIndex = index);
                      },
                      itemBuilder: (context, index) {
                        final bool isFirst = index == 0;
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (!isFirst) ...[
                              _buildHeader(),
                              const SizedBox(height: 6),
                            ],
                            Expanded(child: _buildStepWidget(steps[index])),
                          ],
                        );
                      },
                    ),
                  ),
                  _buildActionButton(),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return InkWell(
      focusColor: Colors.transparent,
      hoverColor: Colors.transparent,
      highlightColor: Colors.transparent,
      splashColor: Colors.transparent,
      onTap: _previousPage,
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: AppColors.surfaceAccent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Icon(
          Icons.arrow_back_ios_new_rounded,
          size: 20,
          color: AppColors.primary,
        ),
      ),
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
