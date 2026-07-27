import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:smart_antibiotic/utils/app_assets.dart';

import '../../utils/app_colors.dart';
import '../../utils/app_text.dart';

class SettingsDetailAlarmOptimizationScreen extends StatelessWidget {
  const SettingsDetailAlarmOptimizationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
      ),
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 26),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 14),
                _buildHeader(context),
                SizedBox(height: 14),
                Expanded(child: _buildContent()),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Widget _buildHeader(BuildContext context) {
  return InkWell(
    focusColor: Colors.transparent,
    hoverColor: Colors.transparent,
    highlightColor: Colors.transparent,
    splashColor: Colors.transparent,
    onTap: () => Navigator.pop(context),
    child: Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: AppColors.surfaceAccent,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Icon(
        Icons.arrow_back_ios_new_rounded,
        size: 20,
        color: AppColors.primary,
      ),
    ),
  );
}

Widget _buildContent() {
  return SingleChildScrollView(
    child: Column(
      children: [
        Text(
          'Mengapa Smart Antibiotik memerlukan izin Notifikasi?',
          style: AppTextStyles.titleMedium,
        ),
        SizedBox(height: 14),
        Text(
          'Smart Antibiotik memerlukan izin notifikasi untuk mengirimkan pengingat minum obat tepat waktu. Dengan mengaktifkan notifikasi, Anda juga akan menerima pengingat obat.',
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.textSecondary,
            height: 1.6,
          ),
        ),
        SizedBox(height: 40),
        Text(
          'Apa yang terjadi jika Anda tidak mengizinkan Notifikasi?',
          style: AppTextStyles.titleMedium,
        ),
        SizedBox(height: 14),
        Text(
          'Jika notifikasi tidak diaktifkan, Anda mungkin akan melewatkan pengingat penting untuk minum obat.',
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.textSecondary,
            height: 1.6,
          ),
        ),
        SizedBox(height: 14),
        Image.asset(imgNotificationBanner),
        SizedBox(height: 26),
      ],
    ),
  );
}
