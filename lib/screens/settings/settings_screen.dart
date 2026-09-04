import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shimmer/shimmer.dart';

import '../../utils/app_colors.dart';
import '../../utils/app_text.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _isLoading = true;
  int _grantedPermissionsCount = 0;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    final results = await Future.wait([
      Permission.notification.status.isGranted,
      Permission.systemAlertWindow.status.isGranted,
      Permission.ignoreBatteryOptimizations.status.isGranted,
      Future.delayed(const Duration(milliseconds: 600)),
    ]);

    final notification = results[0] as bool;
    final overlay = results[1] as bool;
    final battery = results[2] as bool;

    int count = 0;
    if (notification) count++;
    if (overlay) count++;
    if (battery) count++;

    if (mounted) {
      setState(() {
        _grantedPermissionsCount = count;
        _isLoading = false;
      });
    }
  }

  Future<void> _navigateToOptimization() async {
    final result = await Navigator.pushNamed(
      context,
      '/settings-alarm-optimization',
    );

    if (result != null && result is int) {
      setState(() {
        _grantedPermissionsCount = result;
      });
    } else {
      _fetchData();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
      child: Scaffold(
        body: Column(
          children: [
            _buildHeader(context, isLoading: _isLoading),
            const SizedBox(height: 26),
            Expanded(
              child: _isLoading
                  ? _buildShimmerContent()
                  : SingleChildScrollView(
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: const Color(0xFFE7ECF0),
                                ),
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 10,
                              ),
                              child: _buildOptionMenu(context),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Smart Antibiotik v1.0.2',
                            style: AppTextStyles.bodySmall.copyWith(
                              fontSize: 13,
                              color: AppColors.textMuted,
                            ),
                          ),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
            ),
          ],
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
        'subtitle': 'Solusi jika alarm tidak bunyi',
        'status': '$_grantedPermissionsCount / 3 selesai',
        'route': '/settings-alarm-optimization',
      },
      {
        'title': 'Komentar & Masukan',
        'subtitle': 'Tanya info obat atau beri masukan',
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
          onTap: () {
            if (menu['route'] == '/settings-alarm-optimization') {
              _navigateToOptimization();
            } else {
              Navigator.pushNamed(context, menu['route'] as String);
            }
          },
          child: Padding(
            padding: EdgeInsets.fromLTRB(0, 6, 0, isLastItem ? 8 : 0),
            child: Column(
              children: [
                Row(
                  children: [
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          RichText(
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            text: TextSpan(
                              style: AppTextStyles.bodyLarge.copyWith(
                                fontSize: 18,
                                color: AppColors.textPrimary,
                              ),
                              children: [
                                TextSpan(text: menu['title'] as String),
                                if (statusText.isNotEmpty) ...[
                                  TextSpan(
                                    text: '  •  ',
                                    style: AppTextStyles.bodySmall.copyWith(
                                      color: const Color(0xFFD9D9D9),
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
                          Text(
                            menu['subtitle'] as String,
                            style: AppTextStyles.bodyMedium.copyWith(
                              fontSize: 17,
                              color: AppColors.textSecondary,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 20),
                    const Padding(
                      padding: EdgeInsets.only(right: 10),
                      child: Icon(Icons.arrow_forward_ios_rounded, size: 14),
                    ),
                  ],
                ),
                if (!isLastItem) ...[
                  const SizedBox(height: 4),
                  const Divider(color: Color(0xFFE7ECF0)),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildShimmerContent() {
    return Shimmer.fromColors(
      baseColor: AppColors.surfaceSecondary,
      highlightColor: AppColors.surfaceCool,
      child: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: const Color(0xFFE7ECF0)),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
                child: Column(
                  children: List.generate(4, (index) {
                    final bool isLast = index == 3;
                    return Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 6),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: index == 2 ? 180 : 120,
                                      height: 18,
                                      decoration: BoxDecoration(
                                        color: AppColors.surfacePrimary,
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Container(
                                      width: double.infinity,
                                      height: 14,
                                      decoration: BoxDecoration(
                                        color: AppColors.surfacePrimary,
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 20),
                              Container(
                                width: 14,
                                height: 14,
                                decoration: BoxDecoration(
                                  color: AppColors.surfacePrimary,
                                  borderRadius: BorderRadius.circular(3),
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (!isLast) ...[
                          const SizedBox(height: 6),
                          const Divider(color: Color(0xFFE7ECF0)),
                        ],
                      ],
                    );
                  }),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Container(
              width: 140,
              height: 14,
              decoration: BoxDecoration(
                color: AppColors.surfacePrimary,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget _buildHeader(BuildContext context, {required bool isLoading}) {
  return Container(
    height: 115,
    width: double.infinity,
    color: AppColors.primary,
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: SafeArea(
        bottom: false,
        child: Row(
          children: [
            if (isLoading)
              Shimmer.fromColors(
                baseColor: AppColors.accent,
                highlightColor: AppColors.primary,
                child: Container(
                  width: 36,
                  height: 36,
                  decoration: const BoxDecoration(
                    color: AppColors.accent,
                    shape: BoxShape.circle,
                  ),
                ),
              )
            else
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
            const SizedBox(width: 14),
            if (isLoading)
              Shimmer.fromColors(
                baseColor: AppColors.accent,
                highlightColor: AppColors.primary,
                child: Container(
                  width: 140,
                  height: 22,
                  decoration: BoxDecoration(
                    color: AppColors.accent,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              )
            else
              Text(
                'Pengaturan',
                style: AppTextStyles.titleLarge.copyWith(
                  color: AppColors.textWhite,
                ),
              ),
            const Spacer(),
          ],
        ),
      ),
    ),
  );
}
