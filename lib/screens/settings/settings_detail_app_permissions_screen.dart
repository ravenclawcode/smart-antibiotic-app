import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../utils/app_assets.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_text.dart';

class SettingsDetailAppPermissionsScreen extends StatelessWidget {
  const SettingsDetailAppPermissionsScreen({super.key});

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
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Mengapa Smart Antibiotik perlu dikecualikan dari optimasi baterai?',
          style: AppTextStyles.titleMedium,
        ),
        SizedBox(height: 14),
        Text(
          'Jika fitur hemat baterai atau optimasi baterai diaktifkan, sistem dapat menghentikan Smart Antibiotik berjalan di latar belakang sehingga alarm dan pengingat minum obat mungkin tidak berbunyi tepat waktu.',
          style: AppTextStyles.bodyMedium.copyWith(
            fontSize: 18,
            color: AppColors.textSecondary,
            height: 1.6,
          ),
        ),
        SizedBox(height: 40),
        Text(
          'Bagaimana cara mengaturnya secara manual?',
          style: AppTextStyles.titleMedium,
        ),
        SizedBox(height: 14),
        Text(
          'Android di Atas 12',
          style: AppTextStyles.bodyMedium.copyWith(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            height: 1.6,
          ),
        ),
        SizedBox(height: 10),
        Row(
          children: [
            Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Color(0xFFE7ECF0)),
              ),
              alignment: Alignment.center,
              child: Text('1', style: AppTextStyles.bodyMedium),
            ),
            SizedBox(width: 10),
            Text(
              'Buka Pengaturan > Baterai',
              style: AppTextStyles.bodyMedium.copyWith(fontSize: 18),
            ),
          ],
        ),
        SizedBox(height: 14),
        Image.asset(imgPermissionStep1Banner),
        SizedBox(height: 30),
        Row(
          children: [
            Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Color(0xFFE7ECF0)),
              ),
              alignment: Alignment.center,
              child: Text('2', style: AppTextStyles.bodyMedium),
            ),
            SizedBox(width: 10),
            Text(
              'Baterai > Pilih "Tidak dibatasi"',
              style: AppTextStyles.bodyMedium.copyWith(fontSize: 18),
            ),
          ],
        ),
        SizedBox(height: 14),
        Image.asset(imgPermissionStep2Banner),
        SizedBox(height: 40),
        Text(
          'Android di bawah 11 atau Perangkat lain',
          style: AppTextStyles.bodyMedium.copyWith(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            height: 1.6,
          ),
        ),
        SizedBox(height: 10),
        Row(
          children: [
            Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Color(0xFFE7ECF0)),
              ),
              alignment: Alignment.center,
              child: Text('1', style: AppTextStyles.bodyMedium),
            ),
            SizedBox(width: 10),
            Text(
              'Pengaturan > Ketuk Baterai',
              style: AppTextStyles.bodyMedium.copyWith(fontSize: 18),
            ),
          ],
        ),
        SizedBox(height: 14),
        Row(
          children: [
            Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Color(0xFFE7ECF0)),
              ),
              alignment: Alignment.center,
              child: Text('2', style: AppTextStyles.bodyMedium),
            ),
            SizedBox(width: 10),
            Expanded(
              child: Text(
                'Optimalkan penggunaan baterai > Ketuk Semua',
                style: AppTextStyles.bodyMedium.copyWith(fontSize: 18),
              ),
            ),
          ],
        ),
        SizedBox(height: 14),
        Image.asset(imgPermissionStep3Banner),
        SizedBox(height: 30),
        Row(
          children: [
            Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Color(0xFFE7ECF0)),
              ),
              alignment: Alignment.center,
              child: Text('3', style: AppTextStyles.bodyMedium),
            ),
            SizedBox(width: 10),
            Expanded(
              child: Text(
                'Cari aplikasi Anda > Nonaktifkan "Optimalkan penggunaan baterai"',
                style: AppTextStyles.bodyMedium.copyWith(fontSize: 18),
              ),
            ),
          ],
        ),
        SizedBox(height: 14),
        Image.asset(imgPermissionStep4Banner),
        SizedBox(height: 26),
      ],
    ),
  );
}
