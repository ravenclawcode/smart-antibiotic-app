import 'package:flutter/material.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_text.dart';

class MedicineChooseDayScreen extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final ValueChanged<String> onNameChanged;
  final List<int>? initialSelectedDays;

  const MedicineChooseDayScreen({
    super.key,
    required this.formKey,
    required this.onNameChanged,
    this.initialSelectedDays,
  });

  @override
  State<MedicineChooseDayScreen> createState() =>
      _MedicineChooseDayScreenState();
}

class _MedicineChooseDayScreenState extends State<MedicineChooseDayScreen> {
  final List<Map<String, dynamic>> days = [
    {'id': 7, 'initial': 'M', 'short': 'Min', 'full': 'Minggu'},
    {'id': 1, 'initial': 'S', 'short': 'Sen', 'full': 'Senin'},
    {'id': 2, 'initial': 'S', 'short': 'Sel', 'full': 'Selasa'},
    {'id': 3, 'initial': 'R', 'short': 'Rab', 'full': 'Rabu'},
    {'id': 4, 'initial': 'K', 'short': 'Kam', 'full': 'Kamis'},
    {'id': 5, 'initial': 'J', 'short': 'Jum', 'full': 'Jumat'},
    {'id': 6, 'initial': 'S', 'short': 'Sab', 'full': 'Sabtu'},
  ];

  late Set<int> selectedDayIds;

  @override
  void initState() {
    super.initState();
    _initSelectedDays();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _notifyParent();
      }
    });
  }

  void _initSelectedDays() {
    if (widget.initialSelectedDays != null &&
        widget.initialSelectedDays!.isNotEmpty) {
      selectedDayIds = widget.initialSelectedDays!.toSet();
    } else {
      selectedDayIds = {};
    }
  }

  @override
  void didUpdateWidget(covariant MedicineChooseDayScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialSelectedDays != oldWidget.initialSelectedDays) {
      setState(() {
        _initSelectedDays();
      });
    }
  }

  void _toggleDay(int dayId) {
    setState(() {
      if (selectedDayIds.contains(dayId)) {
        if (selectedDayIds.length > 1) {
          selectedDayIds.remove(dayId);
        }
      } else {
        selectedDayIds.add(dayId);
      }
    });
    _notifyParent();
  }

  List<int> _getOrderedSelectedIds() {
    final orderedDays = days.map((d) => d['id'] as int).toList();
    final selectedList = selectedDayIds.toList();
    selectedList.sort(
      (a, b) => orderedDays.indexOf(a).compareTo(orderedDays.indexOf(b)),
    );
    return selectedList;
  }

  String _getFormattedSelectionText() {
    if (selectedDayIds.length == 7) {
      return 'Setiap Hari';
    }
    if (selectedDayIds.isEmpty) {
      return 'Pilih minimal 1 hari';
    }

    final sortedIds = _getOrderedSelectedIds();
    final selectedNames = sortedIds
        .map((id) {
          final dayItem = days.firstWhere((d) => d['id'] == id);
          return dayItem['short'] as String;
        })
        .join(', ');

    return 'Setiap $selectedNames';
  }

  void _notifyParent() {
    final sortedIds = _getOrderedSelectedIds();
    widget.onNameChanged(sortedIds.join(','));
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),
          Text(
            'Pilih Hari',
            style: AppTextStyles.titleLarge,
            textAlign: TextAlign.start,
          ),
          const SizedBox(height: 6),
          Text(
            'Hari Tertentu dalam Seminggu',
            style: AppTextStyles.bodyMedium.copyWith(
              fontSize: 18,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 28),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: days.map((dayItem) {
                final int dayId = dayItem['id'] as int;
                final bool isSelected = selectedDayIds.contains(dayId);

                return GestureDetector(
                  onTap: () => _toggleDay(dayId),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.primary
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Text(
                        dayItem['initial'] as String,
                        style: AppTextStyles.titleSmall.copyWith(
                          fontWeight: FontWeight.bold,
                          color: isSelected
                              ? Colors.white
                              : AppColors.textPrimary,
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            _getFormattedSelectionText(),
            style: AppTextStyles.bodyMedium.copyWith(
              fontSize: 17,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
