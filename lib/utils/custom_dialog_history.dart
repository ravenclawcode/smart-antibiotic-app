import 'package:flutter/material.dart';
import 'package:smart_antibiotic/utils/app_colors.dart';
import 'package:smart_antibiotic/utils/app_text.dart';
import 'package:smart_antibiotic/utils/custom_input_frequency_form.dart';
import 'package:smart_antibiotic/utils/custom_input_medicine_form.dart';

class CustomDialogHistory extends StatefulWidget {
  final String? initialMedicine;
  final String? initialFormat;
  final List<Map<String, dynamic>> medicines;

  const CustomDialogHistory({
    super.key,
    this.initialMedicine,
    this.initialFormat,
    required this.medicines,
  });

  @override
  State<CustomDialogHistory> createState() => _CustomDialogHistoryState();
}

class _CustomDialogHistoryState extends State<CustomDialogHistory> {
  String? _selectedMedicineId;
  String? _selectedMedicine;
  String? _selectedFormat;

  @override
  void initState() {
    super.initState();

    _selectedMedicine = widget.initialMedicine;
    _selectedFormat = widget.initialFormat;

    if (_selectedMedicine != null) {
      final medicine = widget.medicines.firstWhere(
        (item) => item['name']?.toString() == _selectedMedicine,
        orElse: () => <String, dynamic>{},
      );

      _selectedMedicineId = medicine['medicine_id']?.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 26),
        child: Material(
          borderRadius: BorderRadius.circular(16),
          clipBehavior: Clip.antiAlias,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 30),
            decoration: BoxDecoration(color: AppColors.surfacePrimary),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Obat', style: AppTextStyles.bodyLarge),
                const SizedBox(height: 10),
                CustomInputMedicineForm(
                  medicines: widget.medicines,
                  selectedMedicine: _selectedMedicine,
                  onChanged: (medicine) {
                    setState(() {
                      _selectedMedicineId = medicine?['medicine_id']
                          ?.toString();

                      _selectedMedicine = medicine?['name']?.toString();
                    });
                  },
                ),
                const SizedBox(height: 24),
                Text('Format Laporan', style: AppTextStyles.bodyLarge),
                const SizedBox(height: 10),
                CustomInputFrequencyForm(
                  selectedValue: _selectedFormat,
                  onChanged: (value) {
                    setState(() {
                      _selectedFormat = value;
                    });
                  },
                ),
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        'BATAL',
                        style: AppTextStyles.bodySmall.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                    const SizedBox(width: 18),
                    InkWell(
                      onTap: () {
                        if (_selectedMedicine == null ||
                            _selectedMedicine!.isEmpty ||
                            _selectedFormat == null ||
                            _selectedFormat!.isEmpty) {
                          return;
                        }

                        Navigator.of(context).pop({
                          'medicineId': _selectedMedicineId ?? '',
                          'medicine': _selectedMedicine!,
                          'format': _selectedFormat!,
                        });
                      },
                      child: Text(
                        'TERAPKAN',
                        style: AppTextStyles.bodySmall.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
