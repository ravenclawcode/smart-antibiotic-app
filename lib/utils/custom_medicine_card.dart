import 'package:flutter/material.dart';

import 'package:smart_antibiotic/utils/app_colors.dart';
import 'package:smart_antibiotic/utils/app_text.dart';

class CustomMedicineCard extends StatelessWidget {
  final String time;
  final Widget image;
  final String name;
  final String dosage;
  final String notes;

  final bool isTaken;
  final bool isSkipped;
  final bool isMissed;
  final bool isRescheduled;

  final Widget imgStatus;

  final String? statusText;
  final String? notesText;
  final String? rescheduledTime;

  final VoidCallback? onTap;
  final String? skippedAt;
  final String? takenAt;

  const CustomMedicineCard({
    super.key,
    required this.time,
    required this.image,
    required this.name,
    required this.dosage,
    required this.notes,
    required this.isTaken,
    required this.isSkipped,
    required this.isMissed,
    required this.isRescheduled,
    required this.imgStatus,
    this.statusText,
    this.notesText,
    this.rescheduledTime,
    this.onTap,
    this.skippedAt,
    this.takenAt,
  });

  Color _statusColor() {
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
      return const EdgeInsets.only(top: 12, right: 4);
    }

    return const EdgeInsets.only(left: 2, right: 2);
  }

  String _todayDateText() {
    final now = DateTime.now();

    return '${now.day} ${_monthShort(now.month)}';
  }

  String? _displayStatusText() {
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

  String _formatTime(String value) {
    if (value.length >= 5) {
      return value.substring(0, 5).replaceAll(':', '.');
    }

    return value.replaceAll(':', '.');
  }

  String _formatDateTime(String value) {
    try {
      DateTime dateTime;

      if (value.contains('T') || value.contains(' ')) {
        dateTime = DateTime.parse(value);
      } else {
        final parts = value.split(':');

        final hour = int.tryParse(parts[0]) ?? 0;
        final minute = parts.length > 1 ? int.tryParse(parts[1]) ?? 0 : 0;

        final now = DateTime.now();

        dateTime = DateTime(now.year, now.month, now.day, hour, minute);
      }

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

  @override
  Widget build(BuildContext context) {
    final displayStatusText = _displayStatusText();

    return InkWell(
      focusColor: Colors.transparent,
      hoverColor: Colors.transparent,
      highlightColor: Colors.transparent,
      splashColor: Colors.transparent,
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
        decoration: BoxDecoration(
          color: AppColors.surfacePrimary,
          borderRadius: BorderRadius.circular(16),
        ),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Text(
                  time,
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              const SizedBox(width: 10),

              VerticalDivider(width: 1, color: AppColors.border),

              const SizedBox(width: 10),

              Center(
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Padding(padding: _imagePadding(), child: image),
                    Positioned(top: 0, right: 0, child: imgStatus),
                  ],
                ),
              ),

              const SizedBox(width: 10),

              VerticalDivider(width: 1, color: AppColors.border),

              const SizedBox(width: 10),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      name,
                      style: AppTextStyles.bodyMedium.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    Text(
                      dosage,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),

                    if (isSkipped &&
                        notesText != null &&
                        notesText!.isNotEmpty) ...[
                      Text(
                        notesText!,
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],

                    if (displayStatusText != null) ...[
                      Text(
                        displayStatusText,
                        style: AppTextStyles.bodySmall.copyWith(
                          color: _statusColor(),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
