import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shimmer/shimmer.dart';
import 'package:smart_antibiotic/utils/app_assets.dart';

import '../../utils/app_colors.dart';
import '../../utils/app_text.dart';

class SettingsAlarmOptimizationScreen extends StatefulWidget {
  const SettingsAlarmOptimizationScreen({super.key});

  @override
  State<SettingsAlarmOptimizationScreen> createState() =>
      _SettingsAlarmOptimizationScreenState();
}

class _SettingsAlarmOptimizationScreenState
    extends State<SettingsAlarmOptimizationScreen>
    with WidgetsBindingObserver {
  bool _isLoading = true;

  bool _isNotificationGranted = false;
  bool _isOverlayGranted = false;
  bool _isBatteryOptGranted = false;

  int get _grantedCount {
    int count = 0;
    if (_isNotificationGranted) count++;
    if (_isOverlayGranted) count++;
    if (_isBatteryOptGranted) count++;
    return count;
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _checkPermissions();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _checkPermissions();
    }
  }

  Future<void> _checkPermissions() async {
    final notification = await Permission.notification.status.isGranted;
    final overlay = await Permission.systemAlertWindow.status.isGranted;
    final battery =
        await Permission.ignoreBatteryOptimizations.status.isGranted;

    if (mounted) {
      setState(() {
        _isNotificationGranted = notification;
        _isOverlayGranted = overlay;
        _isBatteryOptGranted = battery;
        _isLoading = false;
      });
    }
  }

  Future<void> _requestOrOpenSettings(Permission permission) async {
    final status = await permission.status;
    if (status.isPermanentlyDenied || status.isDenied) {
      final result = await permission.request();
      if (result.isPermanentlyDenied) {
        await openAppSettings();
      }
    } else if (!status.isGranted) {
      await permission.request();
    } else {
      await openAppSettings();
    }
    _checkPermissions();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        Navigator.pop(context, _grantedCount);
      },
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light,
          statusBarBrightness: Brightness.dark,
        ),
        child: Scaffold(
          body: Column(
            children: [
              _buildHeader(
                context,
                isLoading: _isLoading,
                grantedCount: _grantedCount,
              ),
              const SizedBox(height: 26),
              Expanded(
                child: _isLoading
                    ? _buildShimmerContent()
                    : SingleChildScrollView(
                        child: Column(
                          children: [
                            _buildContent(context),
                            const SizedBox(height: 20),
                          ],
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(
    BuildContext context, {
    required bool isLoading,
    required int grantedCount,
  }) {
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
                  onTap: () => Navigator.pop(context, grantedCount),
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
                    width: 240,
                    height: 22,
                    decoration: BoxDecoration(
                      color: AppColors.accent,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                )
              else
                Text(
                  'Pengoptimalan Alarm',
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

  Widget _buildContent(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Harap berikan semua izin agar pengingat dapat bekerja dengan optimal',
            style: AppTextStyles.bodyMedium.copyWith(fontSize: 18),
          ),
          const SizedBox(height: 16),
          _buildOptionMenu(context),
        ],
      ),
    );
  }

  Widget _buildOptionMenu(BuildContext context) {
    final item = [
      {
        'title': '1. Izinkan "Notifikasi Push"',
        'icon': Image.asset(
          imgTaken,
          height: 20,
          key: const ValueKey('icon_noti'),
        ),
        'status': 'Izinkan',
        'route': '/settings-detail-alarm-optimization',
        'permission': Permission.notification,
        'granted': _isNotificationGranted,
      },
      {
        'title': '2. Izinkan "Tampil di atas aplikasi lain"',
        'icon': Image.asset(
          imgTaken,
          height: 20,
          key: const ValueKey('icon_overlay'),
        ),
        'status': 'Izinkan',
        'route': '/settings-detail-alarm-permissions',
        'permission': Permission.systemAlertWindow,
        'granted': _isOverlayGranted,
      },
      {
        'title': '3. Kecualikan Smart Antibiotik dari optimasi baterai',
        'icon': Image.asset(
          imgTaken,
          height: 20,
          key: const ValueKey('icon_battery'),
        ),
        'status': 'Atur',
        'route': '/settings-detail-app-permissions',
        'permission': Permission.ignoreBatteryOptimizations,
        'granted': _isBatteryOptGranted,
      },
    ];

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: item.length,
      padding: EdgeInsets.zero,
      itemBuilder: (context, index) {
        final menu = item[index];
        final bool isGranted = menu['granted'] as bool;
        final Permission permission = menu['permission'] as Permission;

        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            decoration: BoxDecoration(
              color: AppColors.surfaceSecondary,
              borderRadius: BorderRadius.circular(14),
            ),
            child: InkWell(
              borderRadius: BorderRadius.circular(14),
              focusColor: Colors.transparent,
              hoverColor: Colors.transparent,
              highlightColor: Colors.transparent,
              splashColor: Colors.transparent,
              overlayColor: WidgetStateProperty.all(Colors.transparent),
              onTap: isGranted
                  ? null
                  : () => _requestOrOpenSettings(permission),
              child: AnimatedSize(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                alignment: Alignment.topCenter,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              menu['title'] as String,
                              style: AppTextStyles.bodyLarge.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
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
                                menu['route'] as String,
                              ),
                              child: Text(
                                'Mengapa ini penting?',
                                style: AppTextStyles.bodyMedium.copyWith(
                                  fontSize: 18,
                                  fontStyle: FontStyle.italic,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 10),
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 300),
                        switchInCurve: Curves.easeOutBack,
                        switchOutCurve: Curves.easeIn,
                        transitionBuilder: (child, animation) {
                          return FadeTransition(
                            opacity: animation,
                            child: ScaleTransition(
                              scale: animation,
                              child: child,
                            ),
                          );
                        },
                        child: isGranted
                            ? SizedBox(
                                key: ValueKey('icon_wrap_${index}_true'),
                                width: 40,
                                height: 36,
                                child: Center(child: menu['icon'] as Widget),
                              )
                            : Container(
                                key: ValueKey('btn_${menu['status']}'),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 14,
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.surfaceAccent,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  menu['status'] as String,
                                  style: AppTextStyles.bodySmall.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.primary,
                                  ),
                                ),
                              ),
                      ),
                    ],
                  ),
                ),
              ),
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
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
                width: 200,
                height: 18,
                decoration: BoxDecoration(
                  color: AppColors.surfacePrimary,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              const SizedBox(height: 22),
              Column(
                children: List.generate(3, (index) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: AppColors.surfacePrimary,
                        borderRadius: BorderRadius.circular(13),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: index == 2 ? 220 : 180,
                                  height: 18,
                                  decoration: BoxDecoration(
                                    color: AppColors.surfacePrimary,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Container(
                                  width: 130,
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
                            width: 20,
                            height: 20,
                            decoration: const BoxDecoration(
                              color: AppColors.surfacePrimary,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
