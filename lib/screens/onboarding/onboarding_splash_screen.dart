import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../core/utils/app_assets.dart';
import '../../core/utils/app_text.dart';

class OnboardingSplashScreen extends StatefulWidget {
  const OnboardingSplashScreen({super.key});

  @override
  State<OnboardingSplashScreen> createState() => _OnboardingSplashScreenState();
}

class _OnboardingSplashScreenState extends State<OnboardingSplashScreen> {
  @override
  void initState() {
    super.initState();
    _initApp();
  }

  Future<void> _initApp() async {
    await Future.delayed(const Duration(seconds: 1));

    await _requestNotificationPermission();

    await Future.delayed(const Duration(milliseconds: 1500));

    if (!mounted) return;

    Navigator.pushReplacementNamed(context, '/onboarding-welcome');
  }

  Future<void> _requestNotificationPermission() async {
    var status = await Permission.notification.status;

    if (status.isDenied || status.isPermanentlyDenied) {
      await Permission.notification.request();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Center(child: Image.asset(icLogo, height: 102, width: 110)),
            Positioned(
              top: -100,
              left: -100,
              child: SizedBox(
                width: 1,
                height: 1,
                child: Opacity(
                  opacity: 0.0,
                  child: Text('Preload Font', style: AppTextStyles.titleLarge),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
