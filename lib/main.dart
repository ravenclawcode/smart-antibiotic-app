import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:smart_antibiotic/core/network/api_client.dart';

import 'package:smart_antibiotic/providers/antibiotic_provider.dart';
import 'package:smart_antibiotic/providers/feedback_provider.dart';
import 'package:smart_antibiotic/providers/onboarding_provider.dart';
import 'package:smart_antibiotic/providers/settings_provider.dart';
import 'package:smart_antibiotic/services/antibiotic_service.dart';

import 'package:smart_antibiotic/services/feedback_service.dart';
import 'package:smart_antibiotic/services/local_storage_service.dart';
import 'package:smart_antibiotic/services/user_service.dart';

import 'routes/routes.dart';
import 'utils/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (await WebViewFeature.isFeatureSupported(
    WebViewFeature.CREATE_WEB_MESSAGE_CHANNEL,
  )) {}

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  final preferences = await SharedPreferences.getInstance();

  final localStorage = LocalStorageService(preferences);

  final apiClient = ApiClient(client: http.Client());

  final userService = UserService(
    apiClient: apiClient,
    localStorage: localStorage,
  );

  final feedbackService = FeedbackService(
    apiClient: apiClient,
    localStorage: localStorage,
  );

  final antibioticService = AntibioticService(apiClient: apiClient);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => OnboardingProvider(userService: userService),
        ),

        ChangeNotifierProvider(
          create: (_) => SettingsProvider(userService: userService),
        ),

        ChangeNotifierProvider(
          create: (_) => FeedbackProvider(feedbackService: feedbackService),
        ),

        ChangeNotifierProvider(
          create: (_) => AntibioticProvider(service: antibioticService),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Smart Antibiotik',
      initialRoute: '/onboarding-splash',
      onGenerateRoute: generateRoute,
      theme: AppTheme.lightTheme,
    );
  }
}
