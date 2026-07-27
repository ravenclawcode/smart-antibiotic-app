import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../utils/app_colors.dart';
import '../../utils/app_text.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
      child: Scaffold(
        body: Column(
          children: [
            _buildHeader(context),
            SizedBox(height: 26),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Color(0xFFE7ECF0)),
                ),
                padding: EdgeInsets.symmetric(horizontal: 6, vertical: 10),
                child: _buildOptionMenu(context),
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Smart Antibiotik v1.0.0',
              style: AppTextStyles.bodySmall.copyWith(
                fontSize: 13,
                color: AppColors.textMuted,
              ),
            ),
          ],
        ),
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
              'Pengaturan',
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

Widget _buildOptionMenu(BuildContext context) {
  final item = [
    {
      'title': 'Edit Profil',
      'subtitle': 'Nama, umur, jenis kelamin',
      'status': '',
      'route': '/settings-edit-profile',
    },
    {
      'title': 'Preferensi',
      'subtitle': 'Atur pengingat dan pemberitahuan',
      'status': '',
      'route': '/settings-preference',
    },
    {
      'title': 'Pengoptimalan Alarm',
      'subtitle': 'Alarm tidak bunyi? periksa pengaturan',
      'status': '2 / 3 selesai',
      'route': '/settings-alarm-optimization',
    },
    {
      'title': 'Komentar & Masukan',
      'subtitle': 'Tanyakan seputar obat atau beri masukan',
      'status': '',
      'route': '/settings-comments-and-feedback',
    },
  ];

  return ListView.builder(
    shrinkWrap: true,
    physics: const NeverScrollableScrollPhysics(),
    itemCount: item.length,
    padding: EdgeInsets.zero,
    itemBuilder: (context, index) {
      final menu = item[index];
      final bool isLastItem = index == item.length - 1;
      final String statusText = menu['status'] as String;

      return InkWell(
        focusColor: Colors.transparent,
        hoverColor: Colors.transparent,
        highlightColor: Colors.transparent,
        splashColor: Colors.transparent,
        overlayColor: WidgetStateProperty.all(Colors.transparent),
        onTap: () => Navigator.pushNamed(context, menu['route'] as String),
        child: Padding(
          padding: EdgeInsets.fromLTRB(5, 8, 5, isLastItem ? 7 : 0),
          child: Column(
            children: [
              Row(
                children: [
                  SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RichText(
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          text: TextSpan(
                            style: AppTextStyles.bodyMedium.copyWith(
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                            children: [
                              TextSpan(text: menu['title'] as String),
                              if (statusText.isNotEmpty) ...[
                                TextSpan(
                                  text: '  •  ',
                                  style: AppTextStyles.bodySmall.copyWith(
                                    color: Color(0xFFD9D9D9),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                TextSpan(
                                  text: statusText,
                                  style: AppTextStyles.bodySmall.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.primary,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          menu['subtitle'] as String,
                          style: AppTextStyles.bodyMedium.copyWith(
                            fontSize: 15,
                            color: AppColors.textSecondary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 20),
                  Padding(
                    padding: EdgeInsets.only(right: 10),
                    child: Icon(Icons.arrow_forward_ios_rounded, size: 14),
                  ),
                ],
              ),
              if (!isLastItem) ...[
                SizedBox(height: 4),
                Divider(color: Color(0xFFE7ECF0)),
              ],
            ],
          ),
        ),
      );
    },
  );
}
