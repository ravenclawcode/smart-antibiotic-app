import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shimmer/shimmer.dart';
import 'package:smart_antibiotic/utils/app_assets.dart';
import 'package:smart_antibiotic/utils/custom_button_reminder.dart';
import 'package:smart_antibiotic/utils/custom_button_schedule.dart';
import 'package:smart_antibiotic/utils/custom_reschedule_reminder_sheet.dart';

import '../../utils/app_colors.dart';
import '../../utils/app_text.dart';

class CustomReminder extends StatefulWidget {
  const CustomReminder({super.key});

  @override
  State<CustomReminder> createState() => _CustomReminderState();
}

class _CustomReminderState extends State<CustomReminder> {
  bool _isLoading = true;
  bool _isReminder = true;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    await Future.delayed(const Duration(milliseconds: 600));
    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _toggleReminder() {
    setState(() {
      _isReminder = !_isReminder;
    });
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

Widget _buildContent(BuildContext context) {
  return SingleChildScrollView(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          '16:00 Jadwal Obat',
          style: AppTextStyles.bodyLarge.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Amoxicillin',
          style: AppTextStyles.titleLarge.copyWith(fontSize: 28),
        ),
        const SizedBox(height: 6),
        Text(
          '1 Tablet',
          style: AppTextStyles.titleMedium.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 24),
        Image.asset(imgTablet, height: 44),
        const SizedBox(height: 40),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            border: Border.all(color: const Color(0xFFE9E9E9)),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            'Petunjuk akan ditampilkan disini jika Anda menambahkannya',
            style: AppTextStyles.bodyMedium.copyWith(
              fontSize: 17,
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: 24),
        CustomButtonReminder(
          onTap: () {},
          label: 'Minum sekarang',
          colorBg: AppColors.primary,
          colorText: AppColors.textWhite,
        ),
        const SizedBox(height: 14),
        CustomButtonReminder(
          onTap: () {},
          label: 'Lewati',
          colorBg: AppColors.surfaceSecondary,
          colorText: AppColors.textSecondary,
        ),
        const SizedBox(height: 30),
        CustomButtonSchedule(
          onTap: () {
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
              builder: (context) => CustomRescheduleReminderSheet(
                initialValue: 5,
                initialUnit: SnoozeUnit.minute,
                onSave: (value, unit) {},
              ),
            );
          },
          label: 'Jadwal Ulang',
        ),
      ],
    ),
  );
}
