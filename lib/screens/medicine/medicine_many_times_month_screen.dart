import 'package:flutter/material.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_text.dart';

class MedicineManyTimesMonthScreen extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final String initialValue;
  final ValueChanged<String> onNameChanged;

  const MedicineManyTimesMonthScreen({
    super.key,
    required this.formKey,
    required this.initialValue,
    required this.onNameChanged,
  });

  @override
  State<MedicineManyTimesMonthScreen> createState() =>
      _MedicineManyTimesMonthScreenState();
}

class _MedicineManyTimesMonthScreenState
    extends State<MedicineManyTimesMonthScreen> {
  late Set<int> selectedDates;

  @override
  void initState() {
    super.initState();
    selectedDates = _parseInitialDates(widget.initialValue);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _notifyParent();
      }
    });
  }

  @override
  void didUpdateWidget(covariant MedicineManyTimesMonthScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialValue != oldWidget.initialValue) {
      final newDates = _parseInitialDates(widget.initialValue);
      if (newDates != selectedDates) {
        setState(() {
          selectedDates = newDates;
        });
      }
    }
  }

  Set<int> _parseInitialDates(String input) {
    if (input.isEmpty) {
      return {};
    }

    final parsed = <int>{};
    final parts = input.split(',');
    for (var p in parts) {
      final val = int.tryParse(p.trim());
      if (val != null && val >= 1 && val <= 31) {
        parsed.add(val);
      }
    }
    return parsed.isNotEmpty ? parsed : {};
  }

  void _toggleDate(int date) {
    setState(() {
      if (selectedDates.contains(date)) {
        if (selectedDates.length > 1) {
          selectedDates.remove(date);
        }
      } else {
        selectedDates.add(date);
      }
    });
    _notifyParent();
  }

  void _notifyParent() {
    final sortedDates = selectedDates.toList()..sort();
    widget.onNameChanged(sortedDates.join(', '));
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),
          Text(
            'Tanggal berapa dalam sebulan?',
            style: AppTextStyles.titleLarge,
            textAlign: TextAlign.start,
          ),
          const SizedBox(height: 30),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 31,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              crossAxisSpacing: 10,
              mainAxisSpacing: 12,
            ),
            itemBuilder: (context, index) {
              final dateNumber = index + 1;
              final isSelected = selectedDates.contains(dateNumber);

              return GestureDetector(
                onTap: () => _toggleDate(dateNumber),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isSelected
                        ? AppColors.primary
                        : const Color(0xFFF8FAFC),
                  ),
                  child: Center(
                    child: Text(
                      '$dateNumber',
                      style: AppTextStyles.bodyMedium.copyWith(
                        fontSize: 16,
                        fontWeight: isSelected
                            ? FontWeight.bold
                            : FontWeight.w500,
                        color: isSelected
                            ? Colors.white
                            : AppColors.textPrimary,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
