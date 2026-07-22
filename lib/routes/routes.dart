import 'package:flutter/material.dart';
import 'package:smart_antibiotic/screens/onboarding/onboarding_input_name_screen.dart';
import 'package:smart_antibiotic/screens/onboarding/onboarding_intro_screen.dart';
import 'package:smart_antibiotic/screens/onboarding/onboarding_permission_screen.dart';
import 'package:smart_antibiotic/screens/onboarding/onboarding_reminder_sound_screen.dart';
import 'package:smart_antibiotic/screens/onboarding/onboarding_reminder_type_screen.dart';

import '../screens/main_screen.dart';
import '../screens/onboarding/splash_screen.dart';
import '../screens/onboarding/onboarding_welcome_screen.dart';

class Routes {
  static const String main = '/';
  static const String splash = '/splash';
  static const String welcome = '/welcome';
  static const String intro = '/intro';
  static const String inputName = '/input-name';
  static const String reminderType = '/reminder-type';
  static const String reminderSound = '/reminder-sound';
  static const String permission = '/permission';
}

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case Routes.main:
      return MaterialPageRoute(builder: (_) => const MainScreen());
    case Routes.splash:
      return MaterialPageRoute(builder: (_) => const SplashScreen());
    case Routes.welcome:
      return MaterialPageRoute(builder: (_) => const OnboardingWelcomeScreen());
    case Routes.intro:
      return MaterialPageRoute(builder: (_) => const OnboardingIntroScreen());
    case Routes.inputName:
      return MaterialPageRoute(
        builder: (_) => const OnboardingInputNameScreen(),
        settings: settings,
      );
    case Routes.reminderType:
      return MaterialPageRoute(
        builder: (_) => const OnboardingReminderTypeScreen(),
        settings: settings,
      );
    case Routes.reminderSound:
      return MaterialPageRoute(
        builder: (_) => const OnboardingReminderSoundScreen(),
        settings: settings,
      );
    case Routes.permission:
      return MaterialPageRoute(
        builder: (_) => const OnboardingPermissionScreen(),
      );
    default:
      return MaterialPageRoute(
        builder: (_) => Scaffold(
          body: Center(child: Text('No route defined for ${settings.name}')),
        ),
      );
  }
}
