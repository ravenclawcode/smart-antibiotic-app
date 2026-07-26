import 'package:flutter/material.dart';
import 'package:smart_antibiotic/utils/app_assets.dart';

import '../../utils/app_colors.dart';
import '../../utils/app_text.dart';

class SettingsAlarmOptimizationScreen extends StatelessWidget {
  const SettingsAlarmOptimizationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          _buildHeader(context),
          SizedBox(height: 26),
          _buildContent(context),
        ],
      ),
    );
  }
}

Widget _buildHeader(BuildContext context) {
  return Container(
    height: 115,
    width: double.infinity,
    color: AppColors.primary,
    child: Padding(
      padding: EdgeInsets.symmetric(horizontal: 26),
      child: SafeArea(
        bottom: false,
        child: Row(
          children: [
            InkWell(
              focusColor: Colors.transparent,
              hoverColor: Colors.transparent,
              highlightColor: Colors.transparent,
              splashColor: Colors.transparent,
              onTap: () => Navigator.pop(context),
              child: Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: AppColors.accent,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Icon(
                  Icons.arrow_back_ios_new_rounded,
                  size: 20,
                  color: AppColors.surfacePrimary,
                ),
              ),
            ),
            SizedBox(width: 18),
            Text(
              'Pengoptimalan Alarm',
              style: AppTextStyles.titleLarge.copyWith(
                color: AppColors.textWhite,
              ),
            ),
            Spacer(),
          ],
        ),
      ),
    ),
  );
}

Widget _buildContent(BuildContext context) {
  return Padding(
    padding: EdgeInsets.symmetric(horizontal: 20),
    child: Column(
      children: [
        Text(
          'Harap berikan semua izin agar pengingat dapat bekerja dengan optimal',
          style: AppTextStyles.bodyMedium,
        ),
        SizedBox(height: 16),
        _buildOptionMenu(context),
      ],
    ),
  );
}

Widget _buildOptionMenu(BuildContext context) {
  final item = [
    {
      'title': 'Izinkan "Notifikasi Push"',
      'icon': Image.asset(imgTaken, height: 16),
      'route': '/settings-detail-alarm-optimization',
      'essential': '',
    },
    {
      'title': 'Izinkan "Tampil di atas aplikasi lain"',
      'icon': Image.asset(imgTaken, height: 16),
      'route': '/settings-detail-alarm-permissions',
      'essential': '',
    },
    {
      'title': 'Kecualikan Smart Antibiotik dari optimasi baterai',
      'icon': Image.asset(imgMissed, height: 16),
      'route': '/settings-detail-app-permissions',
      'essential': '',
    },
  ];

  return ListView.builder(
    shrinkWrap: true,
    physics: const NeverScrollableScrollPhysics(),
    itemCount: item.length,
    padding: EdgeInsets.zero,
    itemBuilder: (context, index) {
      final menu = item[index];

      return InkWell(
        focusColor: Colors.transparent,
        hoverColor: Colors.transparent,
        highlightColor: Colors.transparent,
        splashColor: Colors.transparent,
        overlayColor: WidgetStateProperty.all(Colors.transparent),
        onTap: () {},
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Container(
                padding: EdgeInsets.all(20),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppColors.surfaceSecondary,
                  borderRadius: BorderRadius.circular(13),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            menu['title'] as String,
                            style: AppTextStyles.bodyMedium.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          InkWell(
                            focusColor: Colors.transparent,
                            hoverColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            splashColor: Colors.transparent,
                            overlayColor: WidgetStateProperty.all(
                              Colors.transparent,
                            ),
                            onTap: () => Navigator.pushNamed(
                              context,
                              menu['essential'] as String,
                            ),
                            child: InkWell(
                              focusColor: Colors.transparent,
                              hoverColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              splashColor: Colors.transparent,
                              overlayColor: WidgetStateProperty.all(
                                Colors.transparent,
                              ),
                              onTap: () => Navigator.pushNamed(
                                context,
                                menu['route'] as String,
                              ),
                              child: Text(
                                'Mengapa ini penting?',
                                style: AppTextStyles.bodySmall.copyWith(
                                  fontSize: 15,
                                  color: AppColors.textSecondary,
                                  fontStyle: FontStyle.italic,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 20),
                    menu['icon'] as Image,
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    },
  );
}
