import 'package:flutter/cupertino.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_text.dart';

enum IntervalType { days, weeks, months }

class MedicineSetIntervalScreen extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final int initialValue;
  final String medicineName;
  final String frequencyType;
  final ValueChanged<String> onNameChanged;

  const MedicineSetIntervalScreen({
    super.key,
    required this.formKey,
    this.initialValue = 1,
    this.medicineName = '',
    this.frequencyType = 'Setiap X Hari',
    required this.onNameChanged,
  });

  @override
  State<MedicineSetIntervalScreen> createState() =>
      _MedicineSetIntervalScreenState();
}

class _MedicineSetIntervalScreenState extends State<MedicineSetIntervalScreen> {
  late int selectedValue;
  late List<int> valuesList;
  late final FixedExtentScrollController _scrollController;
  static const int _loopMultiplier = 1000;

  IntervalType get _intervalType {
    if (widget.frequencyType.toLowerCase().contains('minggu')) {
      return IntervalType.weeks;
    } else if (widget.frequencyType.toLowerCase().contains('bulan')) {
      return IntervalType.months;
    }
    return IntervalType.days;
  }

  String get _subtitle {
    switch (_intervalType) {
      case IntervalType.weeks:
        return 'Setiap X Minggu';
      case IntervalType.months:
        return 'Setiap X Bulan';
      case IntervalType.days:
        return 'Setiap X Hari';
    }
  }

  String get _unitLabel {
    switch (_intervalType) {
      case IntervalType.weeks:
        return 'minggu';
      case IntervalType.months:
        return 'bulan';
      case IntervalType.days:
        return 'hari';
    }
  }

  @override
  void initState() {
    super.initState();
    _initValues();

    final initialIndex = valuesList.indexOf(selectedValue);
    final initialScrollItem =
        (_loopMultiplier * valuesList.length) +
        (initialIndex >= 0 ? initialIndex : 0);
    _scrollController = FixedExtentScrollController(
      initialItem: initialScrollItem,
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _notifyParent();
      }
    });
  }

  void _initValues() {
    int maxCount;
    switch (_intervalType) {
      case IntervalType.weeks:
        maxCount = 36;
        break;
      case IntervalType.months:
        maxCount = 12;
        break;
      case IntervalType.days:
        maxCount = 31;
        break;
    }

    valuesList = List.generate(maxCount, (i) => i + 1);

    selectedValue = widget.initialValue;
    if (!valuesList.contains(selectedValue)) {
      selectedValue = valuesList.first;
    }
  }

  @override
  void didUpdateWidget(covariant MedicineSetIntervalScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.frequencyType != widget.frequencyType ||
        oldWidget.initialValue != widget.initialValue) {
      if (widget.initialValue != selectedValue ||
          oldWidget.frequencyType != widget.frequencyType) {
        _initValues();

        if (_scrollController.hasClients) {
          final targetIndex = valuesList.indexOf(selectedValue);
          final scrollItem =
              (_loopMultiplier * valuesList.length) +
              (targetIndex >= 0 ? targetIndex : 0);
          _scrollController.jumpToItem(scrollItem);
        }
      }
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _notifyParent() {
    widget.onNameChanged('$selectedValue');
  }

  Widget _buildSelectionOverlay() {
    return Container(
      decoration: const BoxDecoration(
        border: Border(
          top: BorderSide(color: Color(0xFFE7ECF0), width: 1),
          bottom: BorderSide(color: Color(0xFFE7ECF0), width: 1),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),
          Text(
            'Pilih Interval',
            style: AppTextStyles.titleLarge,
            textAlign: TextAlign.start,
          ),
          const SizedBox(height: 6),
          Text(
            _subtitle,
            style: AppTextStyles.bodyMedium.copyWith(
              fontSize: 18,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 40),
          SizedBox(
            height: 150,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'setiap',
                  style: AppTextStyles.titleLarge.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(width: 24),
                SizedBox(
                  width: 50,
                  child: CupertinoPicker.builder(
                    itemExtent: 50,
                    diameterRatio: 10000,
                    squeeze: 1.0,
                    magnification: 1.0,
                    useMagnifier: false,
                    selectionOverlay: _buildSelectionOverlay(),
                    scrollController: _scrollController,
                    onSelectedItemChanged: (index) {
                      final actualIndex =
                          (index % valuesList.length + valuesList.length) %
                          valuesList.length;
                      setState(() {
                        selectedValue = valuesList[actualIndex];
                      });
                      _notifyParent();
                    },
                    childCount: null,
                    itemBuilder: (context, index) {
                      final actualIndex =
                          (index % valuesList.length + valuesList.length) %
                          valuesList.length;
                      final number = valuesList[actualIndex];
                      final isSelected = selectedValue == number;

                      return Center(
                        child: AnimatedDefaultTextStyle(
                          duration: const Duration(milliseconds: 200),
                          curve: Curves.easeOut,
                          style: AppTextStyles.titleLarge.copyWith(
                            fontWeight: FontWeight.bold,
                            color: isSelected
                                ? AppColors.textPrimary
                                : const Color(0xFFCFD8E0),
                          ),
                          child: Text('$number'),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 24),
                Text(
                  _unitLabel,
                  style: AppTextStyles.titleLarge.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
