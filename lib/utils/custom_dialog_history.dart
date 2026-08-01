import 'package:flutter/material.dart';
import 'package:smart_antibiotic/utils/app_colors.dart';
import 'package:smart_antibiotic/utils/app_text.dart';
import 'package:smart_antibiotic/utils/custom_input_frequency_form.dart';
import 'package:smart_antibiotic/utils/custom_input_medicine_form.dart';

class CustomDialogHistory extends StatefulWidget {
  final String? initialMedicine;
  final String? initialFormat;

  const CustomDialogHistory({
    super.key,
    this.initialMedicine,
    this.initialFormat,
  });

  @override
  State<CustomDialogHistory> createState() => _CustomDialogHistoryState();
}

class _CustomDialogHistoryState extends State<CustomDialogHistory> {
  late TextEditingController _medicineController;
  late TextEditingController _frequencyController;

  @override
  void initState() {
    super.initState();
    _medicineController = TextEditingController(
      text: widget.initialMedicine ?? '',
    );
    _frequencyController = TextEditingController(
      text: widget.initialFormat ?? '',
    );
  }

  @override
  void dispose() {
    _medicineController.dispose();
    _frequencyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Material(
          borderRadius: BorderRadius.circular(16),
          clipBehavior: Clip.antiAlias,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
            decoration: BoxDecoration(color: AppColors.surfacePrimary),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Obat', style: AppTextStyles.bodyLarge),
                const SizedBox(height: 10),
                CustomInputMedicineForm(controller: _medicineController),
                const SizedBox(height: 24),
                Text('Format Laporan', style: AppTextStyles.bodyLarge),
                const SizedBox(height: 10),
                CustomInputFrequencyForm(controller: _frequencyController),
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
                        Navigator.of(context).pop({
                          'medicine': _medicineController.text,
                          'format': _frequencyController.text,
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
