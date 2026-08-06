import 'package:flutter/material.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_text.dart';

class MedicineChooseFrequencyScreen extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final String initialValue;
  final ValueChanged<String> onNameChanged;

  const MedicineChooseFrequencyScreen({
    super.key,
    required this.formKey,
    required this.initialValue,
    required this.onNameChanged,
  });

  @override
  State<MedicineChooseFrequencyScreen> createState() =>
      _MedicineChooseFrequencyScreenState();
}

class _MedicineChooseFrequencyScreenState
    extends State<MedicineChooseFrequencyScreen> {
  late String _selectedFrequency;

  final List<String> frequencyOptions = [
    '1 kali sehari',
    '2 kali sehari',
    '3 kali sehari',
    'Lebih dari 3 kali sehari',
    'Hari Tertentu',
    'Setiap X Hari',
    'Setiap X Minggu',
    'Setiap X Bulan',
  ];

  @override
  void initState() {
    super.initState();
    _selectedFrequency = widget.initialValue;
  }

  @override
  void didUpdateWidget(covariant MedicineChooseFrequencyScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialValue != oldWidget.initialValue) {
      setState(() {
        _selectedFrequency = widget.initialValue;
      });
    }
  }

  void _handleFrequencySelection(String frequencyName) {
    setState(() {
      _selectedFrequency = frequencyName;
    });
    widget.onNameChanged(frequencyName);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),
          Text('Atur Frekuensi', style: AppTextStyles.titleLarge),
          const SizedBox(height: 10),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(frequencyOptions.length, (index) {
              final frequencyName = frequencyOptions[index];
              final isItemChosen = _selectedFrequency == frequencyName;
              final bool isLastItem = index == frequencyOptions.length - 1;

              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  InkWell(
                    focusColor: Colors.transparent,
                    hoverColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    splashColor: Colors.transparent,
                    onTap: () => _handleFrequencySelection(frequencyName),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                      ),
                      title: Text(
                        frequencyName,
                        style: AppTextStyles.bodyMedium.copyWith(
                          fontSize: 18,
                          color: isItemChosen
                              ? AppColors.primary
                              : AppColors.textPrimary,
                          fontWeight: isItemChosen
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                      ),
                      trailing: isItemChosen
                          ? const Icon(
                              Icons.check_rounded,
                              color: AppColors.primary,
                            )
                          : null,
                    ),
                  ),
                  if (!isLastItem)
                    const Divider(color: Color(0xFFE7ECF0), height: 1),
                ],
              );
            }),
          ),
        ],
      ),
    );
  }
}
