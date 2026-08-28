import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import 'package:smart_antibiotic/utils/app_assets.dart';
import 'package:smart_antibiotic/utils/app_colors.dart';
import 'package:smart_antibiotic/utils/app_text.dart';
import 'package:smart_antibiotic/utils/custom_button_reminder.dart';
import 'package:smart_antibiotic/utils/custom_button_schedule.dart';
import 'package:smart_antibiotic/utils/custom_reschedule_reminder_sheet.dart';

import '../providers/medicine_history_provider.dart';
import '../services/notification_service.dart';
import '../services/reminder_audio_player.dart';

class CustomReminder extends StatefulWidget {
  final int? medicineId;
  final String? medicineName;
  final String? dosage;
  final String? dosageUnit;
  final String? instruction;
  final String? scheduledTime;
  final int? scheduleTimeId;
  final String? scheduledDate;

  const CustomReminder({
    super.key,
    this.medicineId,
    this.medicineName,
    this.dosage,
    this.dosageUnit,
    this.instruction,
    this.scheduledTime,
    this.scheduleTimeId,
    this.scheduledDate,
  });

  @override
  State<CustomReminder> createState() => _CustomReminderState();
}

class _CustomReminderState extends State<CustomReminder> {
  bool _isLoading = true;
  bool _isReminder = true;
  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();

    _startReminderAudio();
    _fetchData();
  }

  Future<void> _startReminderAudio() async {
    await ReminderAudioPlayer.instance.play();
  }

  Future<void> _fetchData() async {
    await Future.delayed(const Duration(milliseconds: 600));

    if (!mounted) {
      return;
    }

    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _toggleReminder() async {
    setState(() {
      _isReminder = !_isReminder;
    });

    if (_isReminder) {
      await ReminderAudioPlayer.instance.unmute();
    } else {
      await ReminderAudioPlayer.instance.mute();
    }
  }

  String get _formattedTime {
    final cleanTime = (widget.scheduledTime ?? '').trim();

    if (cleanTime.isEmpty) {
      return '--:--';
    }

    if (cleanTime.length >= 5) {
      return cleanTime.substring(0, 5);
    }

    return cleanTime;
  }

  String get _dosageText {
    final dosage = (widget.dosage ?? '').trim();
    final dosageUnit = (widget.dosageUnit ?? '').trim();

    if (dosage.isEmpty && dosageUnit.isEmpty) {
      return '-';
    }

    if (dosage.isEmpty) {
      return dosageUnit;
    }

    if (dosageUnit.isEmpty) {
      return dosage;
    }

    return '$dosage $dosageUnit';
  }

  String get _instructionText {
    final instruction = widget.instruction?.trim();

    if (instruction == null || instruction.isEmpty) {
      return 'Petunjuk akan ditampilkan di sini jika Anda menambahkannya';
    }

    return instruction;
  }

  Widget _medicineImage(String? dosageUnit) {
    switch (dosageUnit?.trim().toLowerCase()) {
      case 'kapsul':
        return Image.asset(imgKapsul, width: 44);

      case 'kaplet':
        return Image.asset(imgKaplet, width: 44);

      case 'tablet':
      default:
        return Image.asset(imgTablet, width: 44);
    }
  }

  Future<void> _stopReminderAudio() async {
    await ReminderAudioPlayer.instance.stop();
  }

  Future<void> _handleTaken() async {
    if (_isProcessing) {
      return;
    }

    if (widget.scheduleTimeId == null || widget.scheduledDate == null) {
      return;
    }

    setState(() {
      _isProcessing = true;
    });

    try {
      await _stopReminderAudio();

      await NotificationService.instance.stopActiveMedicineAlarm();

      if (!mounted) {
        return;
      }

      await context.read<MedicineHistoryProvider>().taken(
        scheduleTimeId: widget.scheduleTimeId!,
        scheduledDate: widget.scheduledDate!,
        actionTime: 'now',
      );

      if (!mounted) {
        return;
      }

      Navigator.of(context).pop();
    } catch (_) {
      if (!mounted) {
        return;
      }

      setState(() {
        _isProcessing = false;
      });
    }
  }

  Future<void> _handleSkipped() async {
    if (_isProcessing) {
      return;
    }

    if (widget.scheduleTimeId == null || widget.scheduledDate == null) {
      return;
    }

    setState(() {
      _isProcessing = true;
    });

    try {
      await _stopReminderAudio();

      await NotificationService.instance.stopActiveMedicineAlarm();

      if (!mounted) {
        return;
      }

      await context.read<MedicineHistoryProvider>().skipped(
        scheduleTimeId: widget.scheduleTimeId!,
        scheduledDate: widget.scheduledDate!,
        actionTime: 'now',
        notes: 'Lainnya',
      );

      if (!mounted) {
        return;
      }

      Navigator.of(context).pop();
    } catch (_) {
      if (!mounted) {
        return;
      }

      setState(() {
        _isProcessing = false;
      });
    }
  }

  void _openRescheduleSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) {
        return CustomRescheduleReminderSheet(
          medicineName: widget.medicineName ?? 'Obat',
          initialValue: 5,
          initialUnit: SnoozeUnit.minute,
          onSave: (value, unit) async {
            if (widget.scheduleTimeId == null || widget.scheduledDate == null) {
              return;
            }

            final minutes = switch (unit) {
              SnoozeUnit.minute => value,
              SnoozeUnit.hour => value * 60,
            };

            final rescheduledDateTime = DateTime.now().add(
              Duration(minutes: minutes),
            );

            final rescheduledTime = rescheduledDateTime.toIso8601String();

            try {
              await _stopReminderAudio();

              await NotificationService.instance.stopActiveMedicineAlarm();

              // ignore: use_build_context_synchronously
              await context.read<MedicineHistoryProvider>().reschedule(
                scheduleTimeId: widget.scheduleTimeId!,
                scheduledDate: widget.scheduledDate!,
                rescheduledTime: rescheduledTime,
              );

              if (widget.medicineId != null) {
                await NotificationService.instance.scheduleRescheduledReminder(
                  medicineId: widget.medicineId!,
                  scheduleTimeId: widget.scheduleTimeId!,
                  medicineName: widget.medicineName ?? 'Obat',
                  dosage: widget.dosage ?? '',
                  dosageUnit: widget.dosageUnit ?? '',
                  instruction: widget.instruction ?? '',
                  scheduledDateTime: rescheduledDateTime,
                );
              }

              if (sheetContext.mounted) {
                Navigator.of(sheetContext).pop();
              }

              if (mounted) {
                Navigator.of(context).pop();
              }
            } catch (_) {}
          },
        );
      },
    );
  }

  @override
  void dispose() {
    ReminderAudioPlayer.instance.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
      ),
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 26),
            child: Column(
              children: [
                const SizedBox(height: 24),

                _buildHeader(
                  context,
                  isLoading: _isLoading,
                  isReminder: _isReminder,
                  onToggleReminder: _toggleReminder,
                ),

                const SizedBox(height: 14),

                Expanded(child: _buildContent(context)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    if (_isLoading) {
      return _buildLoadingContent();
    }

    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 8),

          Text(
            '$_formattedTime Jadwal Obat',
            style: AppTextStyles.bodyLarge.copyWith(
              color: AppColors.textSecondary,
            ),
          ),

          const SizedBox(height: 4),

          Text(
            widget.medicineName ?? 'Obat',
            style: AppTextStyles.titleLarge.copyWith(fontSize: 28),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 6),

          Text(
            _dosageText,
            style: AppTextStyles.titleMedium.copyWith(
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 24),

          _medicineImage(widget.dosageUnit),

          const SizedBox(height: 40),

          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0xFFE9E9E9)),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              _instructionText,
              style: AppTextStyles.bodyMedium.copyWith(
                fontSize: 17,
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ),

          const SizedBox(height: 24),

          CustomButtonReminder(
            onTap: _isProcessing ? null : _handleTaken,
            label: 'Minum sekarang',
            colorBg: AppColors.primary,
            colorText: AppColors.textWhite,
          ),

          const SizedBox(height: 14),

          CustomButtonReminder(
            onTap: _isProcessing ? null : _handleSkipped,
            label: 'Lewati',
            colorBg: AppColors.surfaceSecondary,
            colorText: AppColors.textSecondary,
          ),

          const SizedBox(height: 30),

          CustomButtonSchedule(
            onTap: _isProcessing ? () {} : _openRescheduleSheet,
            label: 'Jadwal Ulang',
          ),

          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildLoadingContent() {
    return Shimmer.fromColors(
      baseColor: AppColors.surfaceSecondary,
      highlightColor: AppColors.surfaceCool,
      child: Column(
        children: [
          const SizedBox(height: 12),

          Container(
            width: 140,
            height: 20,
            decoration: BoxDecoration(
              color: AppColors.surfacePrimary,
              borderRadius: BorderRadius.circular(6),
            ),
          ),

          const SizedBox(height: 12),

          Container(
            width: 220,
            height: 34,
            decoration: BoxDecoration(
              color: AppColors.surfacePrimary,
              borderRadius: BorderRadius.circular(8),
            ),
          ),

          const SizedBox(height: 12),

          Container(
            width: 100,
            height: 22,
            decoration: BoxDecoration(
              color: AppColors.surfacePrimary,
              borderRadius: BorderRadius.circular(6),
            ),
          ),

          const SizedBox(height: 32),

          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppColors.surfacePrimary,
              borderRadius: BorderRadius.circular(8),
            ),
          ),

          const SizedBox(height: 40),

          Container(
            width: double.infinity,
            height: 90,
            decoration: BoxDecoration(
              color: AppColors.surfacePrimary,
              borderRadius: BorderRadius.circular(12),
            ),
          ),

          const SizedBox(height: 24),

          Container(
            width: double.infinity,
            height: 52,
            decoration: BoxDecoration(
              color: AppColors.surfacePrimary,
              borderRadius: BorderRadius.circular(12),
            ),
          ),

          const SizedBox(height: 14),

          Container(
            width: double.infinity,
            height: 52,
            decoration: BoxDecoration(
              color: AppColors.surfacePrimary,
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ],
      ),
    );
  }
}

Widget _buildHeader(
  BuildContext context, {
  required bool isLoading,
  required bool isReminder,
  required VoidCallback onToggleReminder,
}) {
  if (isLoading) {
    return Shimmer.fromColors(
      baseColor: AppColors.surfaceSecondary,
      highlightColor: AppColors.surfaceCool,
      child: Align(
        alignment: Alignment.topRight,
        child: Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: AppColors.surfacePrimary,
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    );
  }

  return InkWell(
    focusColor: Colors.transparent,
    hoverColor: Colors.transparent,
    highlightColor: Colors.transparent,
    splashColor: Colors.transparent,
    onTap: onToggleReminder,
    child: Align(
      alignment: Alignment.topRight,
      child: Container(
        width: 42,
        height: 42,
        decoration: BoxDecoration(
          color: AppColors.surfaceAccent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 250),
            transitionBuilder: (Widget child, Animation<double> animation) {
              return ScaleTransition(
                scale: animation,
                child: FadeTransition(opacity: animation, child: child),
              );
            },
            child: isReminder
                ? Image.asset(
                    icUnmute,
                    key: const ValueKey('icUnmute'),
                    height: 16,
                    color: AppColors.primary,
                  )
                : Image.asset(
                    icMute,
                    key: const ValueKey('icMute'),
                    height: 16,
                    color: AppColors.primary,
                  ),
          ),
        ),
      ),
    ),
  );
}
