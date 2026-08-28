import 'package:flutter/material.dart';
import 'package:smart_antibiotic/utils/app_assets.dart';
import 'package:smart_antibiotic/utils/app_colors.dart';
import 'package:smart_antibiotic/utils/app_text.dart';
import 'package:smart_antibiotic/utils/custom_medicine_sheet.dart';
import 'package:smart_antibiotic/utils/custom_reschedule_sheet.dart';

import '../models/medicine_model.dart';

class CustomDialogMedicine extends StatelessWidget {
  final String time;
  final Widget image;
  final String name;
  final String dosage;
  final String notes;

  final int medicineId;
  final int scheduleTimeId;
  final String scheduledDate;

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

  final Future<void> Function(String actionTime)? onTaken;
  final Future<void> Function(String actionTime, String notes)? onSkipped;
  final Future<void> Function(String time)? onReschedule;
  final Future<void> Function()? onCancel;
  final Future<void> Function()? onEditFutureDoses;

  final bool isRescheduled;
  final String? rescheduledTime;
  final String? skippedAt;
  final String? takenAt;

  final MedicineModel medicine;

  final Future<void> Function(
    int medicineId,
    int scheduleTimeId,
    String scheduledDate,
  )?
  onDeleteSingleDose;

  final Future<void> Function(
    int medicineId,
    int scheduleTimeId,
    String scheduledDate,
  )?
  onDeleteFutureDoses;

  const CustomDialogMedicine({
    super.key,
    required this.time,
    required this.image,
    required this.name,
    required this.dosage,
    required this.notes,
    required this.medicineId,
    required this.scheduleTimeId,
    required this.scheduledDate,
    required this.isTaken,
    required this.isSkipped,
    required this.isMissed,
    required this.imgStatus,
    required this.isRescheduled,
    required this.medicine,
    this.onEditFutureDoses,
    this.onDeleteSingleDose,
    this.onDeleteFutureDoses,
    this.statusText,
    this.notesText,
    this.missedDateText,
    this.onLeftAction,
    this.onCenterAction,
    this.onRightAction,
    this.onTaken,
    this.onSkipped,
    this.onReschedule,
    this.onCancel,
    this.rescheduledTime,
    this.skippedAt,
    this.takenAt,
  });

  String get _scheduleText {
    if (isTaken || isSkipped || isRescheduled) {
      return 'Dijadwalkan pukul $time, besok';
    }

    if (isMissed) {
      final dateStr = missedDateText ?? '20 Agu';
      return 'Dijadwalkan pukul $time, $dateStr';
    }

    return 'Dijadwalkan pukul $time, hari ini';
  }

  String _formatTime(String value) {
    if (value.length >= 5) {
      return value.substring(0, 5);
    }

    return value;
  }

  String _formatDateTime(String value) {
    try {
      final dateTime = DateTime.parse(value);

      const months = [
        'Jan',
        'Feb',
        'Mar',
        'Apr',
        'Mei',
        'Jun',
        'Jul',
        'Agu',
        'Sep',
        'Okt',
        'Nov',
        'Des',
      ];

      final hour = dateTime.hour.toString().padLeft(2, '0');
      final minute = dateTime.minute.toString().padLeft(2, '0');

      final today = DateTime.now();

      final isToday =
          dateTime.year == today.year &&
          dateTime.month == today.month &&
          dateTime.day == today.day;

      if (isToday) {
        return '$hour.$minute hari ini, '
            '${dateTime.day} ${months[dateTime.month - 1]}';
      }

      return '$hour.$minute, '
          '${dateTime.day} ${months[dateTime.month - 1]}';
    } catch (_) {
      return '';
    }
  }

  String _todayDateText() {
    final now = DateTime.now();

    return '${now.day} ${_monthShort(now.month)}';
  }

  String? get _displayStatusText {
    if (isTaken) {
      if (takenAt != null && takenAt!.isNotEmpty) {
        final formatted = _formatDateTime(takenAt!);

        if (formatted.isNotEmpty) {
          return 'Diminum pukul $formatted';
        }
      }

      return 'Diminum pukul $time hari ini, ${_todayDateText()}';
    }

    if (isSkipped) {
      if (skippedAt != null && skippedAt!.isNotEmpty) {
        final formatted = _formatDateTime(skippedAt!);

        if (formatted.isNotEmpty) {
          return 'Dilewati pukul $formatted';
        }
      }

      return 'Dilewati pukul $time hari ini, ${_todayDateText()}';
    }

    if (isMissed) {
      return 'Terlewat';
    }

    if (isRescheduled) {
      if (rescheduledTime != null && rescheduledTime!.isNotEmpty) {
        return 'Dijadwalkan ulang pukul '
            '${_formatTime(rescheduledTime!)} hari ini, ${_todayDateText()}';
      }

      return 'Dijadwalkan ulang';
    }

    if (statusText != null && statusText!.trim().isNotEmpty) {
      return statusText;
    }

    return null;
  }

  String _monthShort(int month) {
    const months = [
      '',
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'Mei',
      'Jun',
      'Jul',
      'Agu',
      'Sep',
      'Okt',
      'Nov',
      'Des',
    ];

    if (month < 1 || month > 12) {
      return '';
    }

    return months[month];
  }

  Color _statusTextColor() {
    if (isTaken) {
      return AppColors.success;
    }

    if (isMissed) {
      return AppColors.error;
    }

    if (isRescheduled) {
      return AppColors.primary;
    }

    if (isSkipped) {
      return AppColors.textSecondary;
    }

    return AppColors.textSecondary;
  }

  EdgeInsets _imagePadding() {
    if (isTaken || isSkipped || isMissed || isRescheduled) {
      return const EdgeInsets.only(top: 16, right: 4);
    }

    return const EdgeInsets.only(left: 2, right: 2);
  }

  @override
  Widget build(BuildContext context) {
    final bool leftIsCancel = isSkipped;

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 26),
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
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      const Spacer(),
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
                                  onItemTap: (index) async {
                                    Navigator.pop(bottomSheetContext);

                                    Navigator.pop(context);

                                    await Future.delayed(
                                      const Duration(milliseconds: 50),
                                    );

                                    if (index == 0) {
                                      if (onDeleteSingleDose != null) {
                                        await onDeleteSingleDose!(
                                          medicineId,
                                          scheduleTimeId,
                                          scheduledDate,
                                        );
                                      }

                                      return;
                                    }

                                    if (onDeleteFutureDoses != null) {
                                      await onDeleteFutureDoses!(
                                        medicineId,
                                        scheduleTimeId,
                                        scheduledDate,
                                      );
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

                      const SizedBox(width: 24),
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
                                  list: const [
                                    'Hanya dosis ini',
                                    'Semua dosis berikutnya',
                                  ],
                                  onItemTap: (index) async {
                                    if (index == 1) {
                                      final navigator = Navigator.of(context);

                                      Navigator.pop(bottomSheetContext);

                                      navigator.pop();

                                      WidgetsBinding.instance
                                          .addPostFrameCallback((_) async {
                                            if (!navigator.mounted) {
                                              return;
                                            }

                                            await navigator.pushNamed(
                                              '/medicine-detail',
                                              arguments: medicine,
                                            );

                                            if (navigator.mounted &&
                                                onEditFutureDoses != null) {
                                              await onEditFutureDoses!();
                                            }
                                          });

                                      return;
                                    }

                                    Navigator.pop(bottomSheetContext);

                                    final navigator = Navigator.of(context);

                                    navigator.pop();

                                    WidgetsBinding.instance
                                        .addPostFrameCallback((_) async {
                                          if (!navigator.mounted) {
                                            return;
                                          }

                                          final result = await navigator
                                              .pushNamed(
                                                '/medicine-edit-dosage',
                                                arguments: {
                                                  'medicine': medicine,
                                                  'medicineId': medicineId,
                                                  'scheduleTimeId':
                                                      scheduleTimeId,
                                                  'scheduledDate':
                                                      scheduledDate,
                                                  'instruction':
                                                      notesText ?? notes,
                                                  'editType': 'single',
                                                },
                                              );

                                          if (!navigator.mounted) {
                                            return;
                                          }

                                          if (result == true &&
                                              onEditFutureDoses != null) {
                                            await onEditFutureDoses!();
                                          }
                                        });
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
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Stack(
                        alignment: Alignment.topRight,
                        children: [
                          Padding(padding: _imagePadding(), child: image),
                          imgStatus,
                        ],
                      ),

                      const SizedBox(height: 8),

                      Text(name, style: AppTextStyles.titleMedium),

                      if (_displayStatusText != null) ...[
                        const SizedBox(height: 4),
                        Text(
                          _displayStatusText!,
                          textAlign: TextAlign.center,
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: _statusTextColor(),
                          ),
                        ),
                      ],

                      const SizedBox(height: 20),

                      Row(
                        children: [
                          Image.asset(
                            icCalendar,
                            height: 18,
                            color: AppColors.textSecondary,
                          ),
                          const SizedBox(width: 10),
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

                      const SizedBox(height: 10),

                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 1),
                            child: Image.asset(
                              icDosage,
                              height: 18,
                              color: AppColors.textSecondary,
                            ),
                          ),
                          const SizedBox(width: 10),
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

                      if (notesText != null &&
                          notesText!.trim().isNotEmpty) ...[
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 1,
                              ),
                              child: Image.asset(
                                icNotes,
                                height: 18,
                                color: AppColors.textSecondary,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 1,
                                ),
                                child: Text(
                                  notesText!,
                                  style: AppTextStyles.bodyMedium.copyWith(
                                    color: AppColors.textSecondary,
                                  ),
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
                  height: 94,
                  width: double.infinity,
                  color: AppColors.surfaceSecondary,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: [
                        Expanded(
                          child: _buildActionButton(
                            icon: leftIsCancel
                                ? Icons.refresh_rounded
                                : Icons.close_rounded,
                            label: leftIsCancel ? 'BATALKAN' : 'LEWATI',
                            colorBg: leftIsCancel
                                ? Colors.transparent
                                : AppColors.surfaceAccent,
                            colorIc: AppColors.primary,
                            colorBorder: leftIsCancel
                                ? AppColors.primary
                                : Colors.transparent,
                            onTap: leftIsCancel
                                ? () async {
                                    if (onCancel != null) {
                                      await onCancel!();
                                    }
                                  }
                                : () {
                                    showModalBottomSheet(
                                      context: context,
                                      isScrollControlled: true,
                                      backgroundColor: Colors.transparent,
                                      builder: (bottomSheetContext) => CustomMedicineSheet(
                                        title:
                                            'Apa alasan Anda tidak mengonsumsi dosis ini?',
                                        list: const [
                                          'Lupa / Sibuk / Tertidur',
                                          'Obat sudah habis',
                                          'Efek samping atau keluhan kesehatan',
                                          'Merasa tidak perlu mengonsumsi dosis ini',
                                          'Lainnya',
                                        ],
                                        onItemTap: (index) async {
                                          final notes = [
                                            'Lupa / Sibuk / Tertidur',
                                            'Obat sudah habis',
                                            'Efek samping atau keluhan kesehatan',
                                            'Merasa tidak perlu mengonsumsi dosis ini',
                                            'Lainnya',
                                          ][index];

                                          Navigator.pop(bottomSheetContext);

                                          if (onSkipped != null) {
                                            await onSkipped!('now', notes);
                                          }
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
                                ? () async {
                                    if (onCancel != null) {
                                      await onCancel!();
                                    }
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
                                              'Sesuai jadwal ($time)',
                                              'Sekarang',
                                            ],
                                            onItemTap: (index) async {
                                              Navigator.pop(bottomSheetContext);

                                              if (onTaken != null) {
                                                final actionTime = index == 0
                                                    ? 'scheduled'
                                                    : 'now';

                                                await onTaken!(actionTime);
                                              }
                                            },
                                          ),
                                    );
                                  },
                          ),
                        ),

                        Expanded(
                          child: _buildActionButton(
                            imageAsset: isRescheduled ? null : icClock,
                            icon: isRescheduled ? Icons.refresh_rounded : null,
                            label: isRescheduled ? 'BATALKAN' : 'JADWAL ULANG',
                            colorBg: isRescheduled
                                ? Colors.transparent
                                : AppColors.surfaceAccent,
                            colorIc: AppColors.primary,
                            colorBorder: isRescheduled
                                ? AppColors.primary
                                : Colors.transparent,
                            onTap: isRescheduled
                                ? () async {
                                    if (onCancel != null) {
                                      await onCancel!();
                                    }
                                  }
                                : () async {
                                    final newTime =
                                        await showModalBottomSheet<TimeOfDay>(
                                          context: context,
                                          isScrollControlled: true,
                                          backgroundColor: Colors.transparent,
                                          builder: (bottomSheetContext) {
                                            return CustomRescheduleSheet(
                                              initialTime: _parseTime(time),
                                            );
                                          },
                                        );

                                    if (newTime == null) {
                                      return;
                                    }

                                    if (onReschedule != null) {
                                      await onReschedule!(
                                        '${newTime.hour.toString().padLeft(2, '0')}:'
                                        '${newTime.minute.toString().padLeft(2, '0')}',
                                      );
                                    }
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
            height: 40,
            width: 40,
            decoration: BoxDecoration(
              color: colorBg,
              shape: BoxShape.circle,
              border: Border.all(color: colorBorder, width: 1.4),
            ),
            child: imageAsset != null
                ? Padding(
                    padding: const EdgeInsets.all(8),
                    child: Image.asset(imageAsset, color: colorIc),
                  )
                : Icon(icon, color: colorIc, size: 26),
          ),
          const SizedBox(height: 6),
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

TimeOfDay _parseTime(String value) {
  final parts = value.split(':');

  if (parts.length < 2) {
    return const TimeOfDay(hour: 0, minute: 0);
  }

  return TimeOfDay(
    hour: int.tryParse(parts[0]) ?? 0,
    minute: int.tryParse(parts[1]) ?? 0,
  );
}
