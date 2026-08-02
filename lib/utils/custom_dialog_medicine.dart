import 'package:flutter/material.dart';
import 'package:smart_antibiotic/utils/app_assets.dart';
import 'package:smart_antibiotic/utils/app_colors.dart';
import 'package:smart_antibiotic/utils/app_text.dart';
import 'package:smart_antibiotic/utils/custom_dialog_delete_medicine.dart';
import 'package:smart_antibiotic/utils/custom_medicine_sheet.dart';
import 'package:smart_antibiotic/utils/custom_reschedule_sheet.dart';

class CustomDialogMedicine extends StatelessWidget {
  final String time;
  final Widget image;
  final String name;
  final String dosage;
  final String notes;
  final bool isTaken;
  final bool isSkipped;
  final bool isMissed;
  final Widget imgStatus;
  final String? statusText;
  final String? notesText;
  final String? missedDateText;
  final VoidCallback? onLeftAction;
  final VoidCallback? onCenterAction;
  final VoidCallback? onRightAction;

  const CustomDialogMedicine({
    super.key,
    required this.time,
    required this.image,
    required this.name,
    required this.dosage,
    required this.notes,
    required this.isTaken,
    required this.isSkipped,
    required this.isMissed,
    required this.imgStatus,
    this.statusText,
    this.notesText,
    this.missedDateText,
    this.onLeftAction,
    this.onCenterAction,
    this.onRightAction,
  });

  String get _scheduleText {
    if (isTaken || isSkipped) {
      return 'Dijadwalkan pukul $time, besok';
    } else if (isMissed) {
      final dateStr = missedDateText ?? '30 Jul';
      return 'Dijadwalkan pukul $time, $dateStr';
    } else {
      return 'Dijadwalkan pukul $time, hari ini';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Material(
          borderRadius: BorderRadius.circular(12),
          clipBehavior: Clip.antiAlias,
          child: Container(
            color: AppColors.surfacePrimary,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  height: 44,
                  width: double.infinity,
                  color: AppColors.primary,
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      Spacer(),
                      InkWell(
                        focusColor: Colors.transparent,
                        hoverColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        splashColor: Colors.transparent,
                        onTap: () {
                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            backgroundColor: Colors.transparent,
                            builder: (bottomSheetContext) =>
                                CustomMedicineSheet(
                                  title: 'Hapus Amoxicillin',
                                  list: const [
                                    'Hanya dosis ini',
                                    'Semua dosis berikutnya',
                                  ],
                                  onItemTap: (index) {
                                    Navigator.pop(bottomSheetContext);
                                    if (index == 1) {
                                      showDialog(
                                        context: context,
                                        builder: (dialogContext) =>
                                            const CustomDialogDeleteMedicine(),
                                      );
                                    } else {
                                      Navigator.pop(context);
                                    }
                                  },
                                ),
                          );
                        },
                        child: Image.asset(
                          icDelete,
                          height: 18,
                          color: AppColors.surfacePrimary,
                        ),
                      ),
                      SizedBox(width: 24),
                      InkWell(
                        focusColor: Colors.transparent,
                        hoverColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        splashColor: Colors.transparent,
                        onTap: () {
                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            backgroundColor: Colors.transparent,
                            builder: (bottomSheetContext) =>
                                CustomMedicineSheet(
                                  title: 'Edit Amoxicillin',
                                  list: [
                                    'Hanya dosis ini',
                                    'Semua dosis berikutnya',
                                  ],
                                  onItemTap: (index) {
                                    Navigator.pop(bottomSheetContext);
                                    if (index == 1) {
                                      Navigator.pushNamed(
                                        context,
                                        '/medicine-detail',
                                      );
                                    } else {
                                      Navigator.pushNamed(
                                        context,
                                        '/medicine-edit-dosage',
                                      );
                                    }
                                  },
                                ),
                          );
                        },
                        child: Image.asset(
                          icEdit,
                          height: 18,
                          color: AppColors.surfacePrimary,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Stack(
                        alignment: Alignment.topRight,
                        children: [
                          Padding(padding: EdgeInsets.all(8), child: image),
                          imgStatus,
                        ],
                      ),
                      SizedBox(height: 8),
                      Text(name, style: AppTextStyles.titleMedium),
                      if (statusText != null) ...[
                        SizedBox(height: 4),
                        Text(
                          statusText!,
                          textAlign: TextAlign.center,
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: isTaken
                                ? AppColors.success
                                : isMissed
                                ? AppColors.error
                                : AppColors.textSecondary,
                          ),
                        ),
                      ],
                      SizedBox(height: 20),
                      Row(
                        children: [
                          Image.asset(
                            icCalendar,
                            height: 18,
                            color: AppColors.textSecondary,
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              _scheduleText,
                              style: AppTextStyles.bodyMedium.copyWith(
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          Image.asset(
                            icDosage,
                            height: 18,
                            color: AppColors.textSecondary,
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              dosage,
                              style: AppTextStyles.bodyMedium.copyWith(
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ),
                        ],
                      ),
                      if (notesText != null) ...[
                        SizedBox(height: 10),
                        Row(
                          children: [
                            Image.asset(
                              icNotes,
                              height: 18,
                              color: AppColors.textSecondary,
                            ),
                            SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                notesText!,
                                style: AppTextStyles.bodyMedium.copyWith(
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
                Container(
                  height: 84,
                  width: double.infinity,
                  color: AppColors.surfaceSecondary,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: [
                        Expanded(
                          child: _buildActionButton(
                            icon: isSkipped
                                ? Icons.refresh_rounded
                                : Icons.close_rounded,
                            label: isSkipped ? 'BATALKAN' : 'LEWATI',
                            colorBg: isSkipped
                                ? Colors.transparent
                                : AppColors.surfaceAccent,
                            colorIc: AppColors.primary,
                            colorBorder: isSkipped
                                ? AppColors.primary
                                : Colors.transparent,
                            onTap: isSkipped
                                ? () {
                                    Navigator.pop(context);
                                  }
                                : () {
                                    showModalBottomSheet(
                                      context: context,
                                      isScrollControlled: true,
                                      backgroundColor: Colors.transparent,
                                      builder: (bottomSheetContext) => CustomMedicineSheet(
                                        title:
                                            'Apa alasan Anda tidak mengonsumsi dosis ini?',
                                        list: [
                                          'Lupa / Sibuk / Tertidur',
                                          'Obat sudah habis',
                                          'Efek samping atau keluhan kesehatan',
                                          'Merasa tidak perlu mengonsumsi dosis ini',
                                          'Lainnya',
                                        ],
                                        onItemTap: (index) {
                                          Navigator.pop(bottomSheetContext);
                                          Navigator.pop(bottomSheetContext);
                                        },
                                      ),
                                    );
                                  },
                          ),
                        ),
                        Expanded(
                          child: _buildActionButton(
                            icon: isTaken
                                ? Icons.refresh_rounded
                                : Icons.check_rounded,
                            label: isTaken ? 'BATALKAN' : 'MINUM',
                            colorBg: isTaken
                                ? Colors.transparent
                                : AppColors.primary,
                            colorIc: isTaken
                                ? AppColors.primary
                                : AppColors.textWhite,
                            colorBorder: isTaken
                                ? AppColors.primary
                                : Colors.transparent,
                            onTap: isTaken
                                ? () {
                                    Navigator.pop(context);
                                  }
                                : () {
                                    showModalBottomSheet(
                                      context: context,
                                      isScrollControlled: true,
                                      backgroundColor: Colors.transparent,
                                      builder: (bottomSheetContext) =>
                                          CustomMedicineSheet(
                                            title:
                                                'Kapan Anda meminum obat ini?',
                                            list: [
                                              'Sesuai jadwal (08.00)',
                                              'Sekarang (10.25)',
                                            ],
                                            onItemTap: (index) {
                                              Navigator.pop(bottomSheetContext);
                                              Navigator.pop(bottomSheetContext);
                                            },
                                          ),
                                    );
                                  },
                          ),
                        ),
                        Expanded(
                          child: _buildActionButton(
                            imageAsset: icClock,
                            label: 'JADWAL ULANG',
                            colorBg: AppColors.surfaceAccent,
                            colorIc: AppColors.primary,
                            colorBorder: Colors.transparent,
                            onTap: () {
                              showModalBottomSheet(
                                context: context,
                                isScrollControlled: true,
                                backgroundColor: Colors.transparent,
                                builder: (context) => CustomRescheduleSheet(
                                  initialTime: const TimeOfDay(
                                    hour: 10,
                                    minute: 25,
                                  ),
                                  onSave: (newTime) {
                                    // Logika simpan waktu baru
                                  },
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton({
    IconData? icon,
    String? imageAsset,
    Color? colorBg,
    Color? colorIc,
    required Color colorBorder,
    required String label,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 36,
            width: 36,
            decoration: BoxDecoration(
              color: colorBg,
              shape: BoxShape.circle,
              border: Border.all(color: colorBorder),
            ),
            child: imageAsset != null
                ? Padding(
                    padding: EdgeInsets.all(8),
                    child: Image.asset(imageAsset, color: colorIc),
                  )
                : Icon(icon, color: colorIc, size: 22),
          ),
          SizedBox(height: 6),
          Text(
            label,
            textAlign: TextAlign.center,
            style: AppTextStyles.labelMedium.copyWith(color: AppColors.primary),
          ),
        ],
      ),
    );
  }
}
