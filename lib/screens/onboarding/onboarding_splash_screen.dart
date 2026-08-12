import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

import '../../providers/onboarding_provider.dart';
import '../../utils/app_assets.dart';
import '../../utils/app_text.dart';

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

    final provider = context.read<OnboardingProvider>();

    final isRegistered = await provider.checkRegistration();

    if (!mounted) return;

    if (isRegistered) {
      Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
    } else {
      Navigator.pushNamedAndRemoveUntil(
        context,
        '/onboarding-welcome',
        (route) => false,
      );
    }
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
