import 'package:flutter/material.dart';
import 'package:smart_antibiotic/screens/chatbot/chatbot_screen.dart';
import 'package:smart_antibiotic/screens/home/home_screen.dart';
import 'package:smart_antibiotic/screens/medicine/medicine_screen.dart';
import 'package:smart_antibiotic/screens/onboarding/onboarding_intro_screen.dart';
import 'package:smart_antibiotic/screens/onboarding/onboarding_parent_screen.dart';
import 'package:smart_antibiotic/screens/settings/settings_screen.dart';
import '../screens/onboarding/onboarding_permission_screen.dart';

import '../screens/main_screen.dart';
import '../screens/onboarding/onboarding_splash_screen.dart';
import '../screens/onboarding/onboarding_welcome_screen.dart';

class Routes {
  static const String main = '/';

  static const String onboardingSplash = '/onboarding-splash';
  static const String onboardingWelcome = '/onboarding-welcome';
  static const String onboardingIntro = '/onboarding-intro';
  static const String onboardingSteps = '/onboarding-steps';
  static const String onboardingPermission = '/onboarding-permission';

  static const String home = '/home';
  static const String medicine = '/medicine';
  static const String settings = '/settings';
  static const String chatbot = '/chatbot';
}

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case Routes.main:
      return MaterialPageRoute(builder: (_) => const MainScreen());
    case Routes.onboardingSplash:
      return MaterialPageRoute(builder: (_) => const OnboardingSplashScreen());
    case Routes.onboardingWelcome:
      return MaterialPageRoute(builder: (_) => const OnboardingWelcomeScreen());
    case Routes.onboardingIntro:
      return MaterialPageRoute(builder: (_) => const OnboardingIntroScreen());
    case Routes.onboardingSteps:
      return MaterialPageRoute(builder: (_) => const OnboardingParentScreen());
    case Routes.onboardingPermission:
      return MaterialPageRoute(
        builder: (_) => const OnboardingPermissionScreen(),
      );
    case Routes.home:
      return MaterialPageRoute(builder: (_) => const HomeScreen());
    case Routes.medicine:
      return MaterialPageRoute(builder: (_) => const MedicineScreen());
    case Routes.settings:
      return MaterialPageRoute(builder: (_) => const SettingsScreen());
    case Routes.chatbot:
      return MaterialPageRoute(builder: (_) => const ChatbotScreen());
    default:
      return MaterialPageRoute(
        builder: (_) => Scaffold(
          body: Center(child: Text('No route defined for ${settings.name}')),
        ),
      );
  }
}
