import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../utils/app_assets.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_text.dart';

class SettingsDetailAlarmPermissionsScreen extends StatelessWidget {
  const SettingsDetailAlarmPermissionsScreen({super.key});

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
          'Mengapa Smart Antibiotik memerlukan izin "Tampilkan di atas aplikasi lain"?',
          style: AppTextStyles.titleMedium,
        ),
        SizedBox(height: 14),
        Text(
          'Agar pengingat minum obat dapat muncul di layar tepat saat dibutuhkan, Smart Antibiotik memerlukan izin "Tampilkan di atas aplikasi lain". Dengan izin ini, pengingat akan tetap terlihat meskipun Anda sedang menggunakan aplikasi lain, sehingga Anda tidak melewatkan jadwal minum obat.',
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.textSecondary,
            height: 1.6,
          ),
        ),
        SizedBox(height: 40),
        Text(
          'Apa yang terjadi jika Anda tidak mengizinkan "Tampilkan di atas aplikasi lain"?',
          style: AppTextStyles.titleMedium,
        ),
        SizedBox(height: 14),
        Text(
          'Jika izin ini tidak diaktifkan, Anda mungkin hanya akan mendengar suara alarm pengingat tanpa melihat notifikasinya di layar. Untuk membantu Anda mengelola pengingat dengan lebih mudah dan mengurangi risiko melewatkan jadwal minum obat, aktifkan izin "Tampilkan di atas aplikasi lain" agar pengingat selalu muncul saat diperlukan.',
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.textSecondary,
            height: 1.6,
          ),
        ),
        SizedBox(height: 14),
        Image.asset(imgReminderBanner),
        SizedBox(height: 26),
      ],
    ),
  );
}
