import 'package:flutter/material.dart';
import 'package:smart_antibiotic/utils/app_colors.dart';
import 'package:smart_antibiotic/utils/app_text.dart';

class CustomDialogDeleteMedicine extends StatefulWidget {
  const CustomDialogDeleteMedicine({super.key});

  @override
  State<CustomDialogDeleteMedicine> createState() =>
      _CustomDialogDeleteMedicineState();
}

class _CustomDialogDeleteMedicineState
    extends State<CustomDialogDeleteMedicine> {
  bool isReminderOn = true;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 26),
        child: Material(
          borderRadius: BorderRadius.circular(16),
          clipBehavior: Clip.antiAlias,
          child: Container(
            padding: EdgeInsets.only(top: 26, bottom: 30, left: 26, right: 26),
            decoration: BoxDecoration(color: AppColors.surfacePrimary),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Hapus Amoxicillin', style: AppTextStyles.titleMedium),
                SizedBox(height: 14),
                Text(
                  'Menghapus obat ini akan menghentikan semua pengingat di masa mendatang',
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontSize: 18,
                    color: AppColors.textSecondary,
                  ),
                ),
                SizedBox(height: 14),
                Row(
                  children: [
                    Text(
                      'Pertahankan riwayat',
                      style: AppTextStyles.bodyMedium.copyWith(fontSize: 18),
                      textAlign: TextAlign.center,
                    ),
                    Spacer(),
                    InkWell(
                      focusColor: Colors.transparent,
                      hoverColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      splashColor: Colors.transparent,
                      onTap: () {
                        setState(() {
                          isReminderOn = !isReminderOn;
                        });
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        width: 46,
                        height: 24,
                        padding: const EdgeInsets.all(2.5),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: isReminderOn
                              ? AppColors.primary
                              : const Color(0xFFE2E2E2),
                        ),
                        child: AnimatedAlign(
                          duration: const Duration(milliseconds: 200),
                          alignment: isReminderOn
                              ? Alignment.centerRight
                              : Alignment.centerLeft,
                          child: Container(
                            width: 20,
                            height: 20,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.surfacePrimary,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.1),
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 40),
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
                        Navigator.pop(context);
                        Navigator.pop(context);
                      },
                      child: Text(
                        'HAPUS',
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
