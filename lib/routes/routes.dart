import 'package:flutter/material.dart';

import '../screens/main_screen.dart';
import '../screens/onboarding/splash_screen.dart';
import '../screens/onboarding/welcome_screen.dart';

class Routes {
  static const String main = '/';
  static const String splash = '/splash';
  static const String welcome = '/welcome';
}

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case Routes.main:
      return MaterialPageRoute(builder: (_) => const MainScreen());
    case Routes.splash:
      return MaterialPageRoute(builder: (_) => const SplashScreen());
    case Routes.welcome:
      return MaterialPageRoute(builder: (_) => const WelcomeScreen());
    default:
      return MaterialPageRoute(
        builder: (_) => Scaffold(
          body: Center(child: Text('No route defined for ${settings.name}')),
        ),
      );
  }
}
