import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shimmer/shimmer.dart';

import '../../utils/app_assets.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_text.dart';

class SettingsDetailAppPermissionsScreen extends StatefulWidget {
  const SettingsDetailAppPermissionsScreen({super.key});

  @override
  State<SettingsDetailAppPermissionsScreen> createState() =>
      _SettingsDetailAppPermissionsScreenState();
}

class _SettingsDetailAppPermissionsScreenState
    extends State<SettingsDetailAppPermissionsScreen> {
  bool _isLoading = true;

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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 14),
                _buildHeader(context, isLoading: _isLoading),
                const SizedBox(height: 14),
                Expanded(
                  child: _isLoading ? _buildShimmerContent() : _buildContent(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildShimmerContent() {
    return Shimmer.fromColors(
      baseColor: AppColors.surfaceSecondary,
      highlightColor: AppColors.surfaceCool,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              height: 22,
              decoration: BoxDecoration(
                color: AppColors.surfacePrimary,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            const SizedBox(height: 6),
            Container(
              width: double.infinity,
              height: 22,
              decoration: BoxDecoration(
                color: AppColors.surfacePrimary,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            const SizedBox(height: 6),
            Container(
              width: 180,
              height: 22,
              decoration: BoxDecoration(
                color: AppColors.surfacePrimary,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            const SizedBox(height: 14),
            Container(
              width: double.infinity,
              height: 18,
              decoration: BoxDecoration(
                color: AppColors.surfacePrimary,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            const SizedBox(height: 6),
            Container(
              width: double.infinity,
              height: 18,
              decoration: BoxDecoration(
                color: AppColors.surfacePrimary,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            const SizedBox(height: 6),
            Container(
              width: double.infinity,
              height: 18,
              decoration: BoxDecoration(
                color: AppColors.surfacePrimary,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            const SizedBox(height: 6),
            Container(
              width: 220,
              height: 18,
              decoration: BoxDecoration(
                color: AppColors.surfacePrimary,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            const SizedBox(height: 40),
            Container(
              width: 280,
              height: 22,
              decoration: BoxDecoration(
                color: AppColors.surfacePrimary,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            const SizedBox(height: 14),
            Container(
              width: 160,
              height: 20,
              decoration: BoxDecoration(
                color: AppColors.surfacePrimary,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Container(
                  width: 34,
                  height: 34,
                  decoration: const BoxDecoration(
                    color: AppColors.surfacePrimary,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 10),
                Container(
                  width: 200,
                  height: 18,
                  decoration: BoxDecoration(
                    color: AppColors.surfacePrimary,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Container(
              width: double.infinity,
              height: 180,
              decoration: BoxDecoration(
                color: AppColors.surfacePrimary,
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            const SizedBox(height: 30),
            Row(
              children: [
                Container(
                  width: 34,
                  height: 34,
                  decoration: const BoxDecoration(
                    color: AppColors.surfacePrimary,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 10),
                Container(
                  width: 220,
                  height: 18,
                  decoration: BoxDecoration(
                    color: AppColors.surfacePrimary,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Container(
              width: double.infinity,
              height: 180,
              decoration: BoxDecoration(
                color: AppColors.surfacePrimary,
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            const SizedBox(height: 40),

            Container(
              width: 260,
              height: 20,
              decoration: BoxDecoration(
                color: AppColors.surfacePrimary,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Container(
                  width: 34,
                  height: 34,
                  decoration: const BoxDecoration(
                    color: AppColors.surfacePrimary,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 10),
                Container(
                  width: 200,
                  height: 18,
                  decoration: BoxDecoration(
                    color: AppColors.surfacePrimary,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                Container(
                  width: 34,
                  height: 34,
                  decoration: const BoxDecoration(
                    color: AppColors.surfacePrimary,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Container(
                    height: 18,
                    decoration: BoxDecoration(
                      color: AppColors.surfacePrimary,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Container(
              width: double.infinity,
              height: 180,
              decoration: BoxDecoration(
                color: AppColors.surfacePrimary,
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            const SizedBox(height: 30),
            Row(
              children: [
                Container(
                  width: 34,
                  height: 34,
                  decoration: const BoxDecoration(
                    color: AppColors.surfacePrimary,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Container(
                    height: 18,
                    decoration: BoxDecoration(
                      color: AppColors.surfacePrimary,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Container(
              width: double.infinity,
              height: 180,
              decoration: BoxDecoration(
                color: AppColors.surfacePrimary,
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            const SizedBox(height: 26),
          ],
        ),
      ),
    );
  }
}

Widget _buildHeader(BuildContext context, {required bool isLoading}) {
  if (isLoading) {
    return Shimmer.fromColors(
      baseColor: AppColors.surfaceSecondary,
      highlightColor: AppColors.surfaceCool,
      child: Container(
        width: 36,
        height: 36,
        decoration: const BoxDecoration(
          color: AppColors.surfacePrimary,
          shape: BoxShape.circle,
        ),
      ),
    );
  }

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
        const SizedBox(height: 14),
        Text(
          'Jika fitur hemat baterai atau optimasi baterai diaktifkan, sistem dapat menghentikan Smart Antibiotik berjalan di latar belakang sehingga alarm dan pengingat minum obat mungkin tidak berbunyi tepat waktu.',
          style: AppTextStyles.bodyMedium.copyWith(
            fontSize: 18,
            color: AppColors.textSecondary,
            height: 1.6,
          ),
        ),
        const SizedBox(height: 40),
        Text(
          'Bagaimana cara mengaturnya secara manual?',
          style: AppTextStyles.titleMedium,
        ),
        const SizedBox(height: 14),
        Text(
          'Android di Atas 12',
          style: AppTextStyles.bodyMedium.copyWith(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            height: 1.6,
          ),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0xFFE7ECF0)),
              ),
              alignment: Alignment.center,
              child: Text('1', style: AppTextStyles.bodyMedium),
            ),
            const SizedBox(width: 10),
            Text(
              'Buka Pengaturan > Baterai',
              style: AppTextStyles.bodyMedium.copyWith(fontSize: 18),
            ),
          ],
        ),
        const SizedBox(height: 14),
        Image.asset(imgPermissionStep1Banner),
        const SizedBox(height: 30),
        Row(
          children: [
            Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0xFFE7ECF0)),
              ),
              alignment: Alignment.center,
              child: Text('2', style: AppTextStyles.bodyMedium),
            ),
            const SizedBox(width: 10),
            Text(
              'Baterai > Pilih "Tidak dibatasi"',
              style: AppTextStyles.bodyMedium.copyWith(fontSize: 18),
            ),
          ],
        ),
        const SizedBox(height: 14),
        Image.asset(imgPermissionStep2Banner),
        const SizedBox(height: 40),
        Text(
          'Android di bawah 11 atau Perangkat lain',
          style: AppTextStyles.bodyMedium.copyWith(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            height: 1.6,
          ),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0xFFE7ECF0)),
              ),
              alignment: Alignment.center,
              child: Text('1', style: AppTextStyles.bodyMedium),
            ),
            const SizedBox(width: 10),
            Text(
              'Pengaturan > Ketuk Baterai',
              style: AppTextStyles.bodyMedium.copyWith(fontSize: 18),
            ),
          ],
        ),
        const SizedBox(height: 14),
        Row(
          children: [
            Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0xFFE7ECF0)),
              ),
              alignment: Alignment.center,
              child: Text('2', style: AppTextStyles.bodyMedium),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                'Optimalkan penggunaan baterai > Ketuk Semua',
                style: AppTextStyles.bodyMedium.copyWith(fontSize: 18),
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        Image.asset(imgPermissionStep3Banner),
        const SizedBox(height: 30),
        Row(
          children: [
            Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0xFFE7ECF0)),
              ),
              alignment: Alignment.center,
              child: Text('3', style: AppTextStyles.bodyMedium),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                'Cari aplikasi Anda > Nonaktifkan "Optimalkan penggunaan baterai"',
                style: AppTextStyles.bodyMedium.copyWith(fontSize: 18),
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        Image.asset(imgPermissionStep4Banner),
        const SizedBox(height: 26),
      ],
    ),
  );
}
