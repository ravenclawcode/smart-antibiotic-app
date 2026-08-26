import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:smart_antibiotic/core/network/api_client.dart';

import 'package:smart_antibiotic/providers/antibiotic_provider.dart';
import 'package:smart_antibiotic/providers/chatbot_provider.dart';
import 'package:smart_antibiotic/providers/feedback_provider.dart';
import 'package:smart_antibiotic/providers/home_provider.dart';
import 'package:smart_antibiotic/providers/medicine_catalog_provider.dart';
import 'package:smart_antibiotic/providers/medicine_history_provider.dart';
import 'package:smart_antibiotic/providers/medicine_provider.dart';
import 'package:smart_antibiotic/providers/onboarding_provider.dart';
import 'package:smart_antibiotic/providers/quiz_provider.dart';
import 'package:smart_antibiotic/providers/settings_provider.dart';

import 'package:smart_antibiotic/services/antibiotic_service.dart';
import 'package:smart_antibiotic/services/chatbot_service.dart';
import 'package:smart_antibiotic/services/feedback_service.dart';
import 'package:smart_antibiotic/services/home_service.dart';
import 'package:smart_antibiotic/services/local_storage_service.dart';
import 'package:smart_antibiotic/services/medicine_catalog_service.dart';
import 'package:smart_antibiotic/services/medicine_history_service.dart';
import 'package:smart_antibiotic/services/medicine_service.dart';
import 'package:smart_antibiotic/services/notification_service.dart';
import 'package:smart_antibiotic/services/quiz_service.dart';
import 'package:smart_antibiotic/services/user_service.dart';

import 'routes/routes.dart';
import 'utils/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final preferences = await SharedPreferences.getInstance();

  final localStorage = LocalStorageService(preferences);

  final notificationService = NotificationService.instance;

  notificationService.setLocalStorage(localStorage);

  await notificationService.initialize();

  if (await WebViewFeature.isFeatureSupported(
    WebViewFeature.CREATE_WEB_MESSAGE_CHANNEL,
  )) {}

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  final savedTimezone = localStorage.getUserTimezone();

  if (savedTimezone != null && savedTimezone.isNotEmpty) {
    notificationService.setTimezone(savedTimezone);
  }

  // ============================================================
  // API CLIENT
  // ============================================================

  final apiClient = ApiClient(
    client: http.Client(),
    localStorage: localStorage,
  );

  // ============================================================
  // SERVICES
  // ============================================================

  final userService = UserService(
    apiClient: apiClient,
    localStorage: localStorage,
  );

  final feedbackService = FeedbackService(
    apiClient: apiClient,
    localStorage: localStorage,
  );

  final antibioticService = AntibioticService(apiClient: apiClient);

  final chatbotService = ChatbotService(apiClient: apiClient);

  final quizService = QuizService(
    apiClient: apiClient,
    localStorage: localStorage,
  );

  final medicineService = MedicineService(
    apiClient: apiClient,
    localStorage: localStorage,
  );

  final medicineCatalogService = MedicineCatalogService(apiClient: apiClient);

  final medicineHistoryService = MedicineHistoryService(
    apiClient: apiClient,
    localStorage: localStorage,
  );

  final homeService = HomeService(
    apiClient: apiClient,
    localStorage: localStorage,
  );

  // ============================================================
  // RUN APP
  // ============================================================

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

        ChangeNotifierProvider(
          create: (_) => ChatbotProvider(
            service: chatbotService,
            localStorage: localStorage,
          ),
        ),

        ChangeNotifierProvider(
          create: (_) => QuizProvider(service: quizService),
        ),

        ChangeNotifierProvider(
          create: (_) => MedicineProvider(medicineService: medicineService),
        ),

        ChangeNotifierProvider(
          create: (_) => MedicineCatalogProvider(
            medicineCatalogService: medicineCatalogService,
          ),
        ),

        ChangeNotifierProvider(
          create: (_) =>
              MedicineHistoryProvider(service: medicineHistoryService),
        ),

        ChangeNotifierProvider(
          create: (_) => HomeProvider(
            homeService: homeService,
            historyService: medicineHistoryService,
          ),
        ),
      ],

      child: const MyApp(),
    ),
  );
}

// ================================================================
// MY APP
// ================================================================

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();

    // ------------------------------------------------------------
    // PENTING:
    // Jangan langsung navigate di main().
    //
    // Tunggu MaterialApp + navigator selesai dibuat.
    // ------------------------------------------------------------

    WidgetsBinding.instance.addPostFrameCallback((_) {
      NotificationService.instance.handlePendingNotification();
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Smart Antibiotik',
      navigatorKey: navigatorKey,
      initialRoute: '/onboarding-splash',
      onGenerateRoute: generateRoute,
      theme: AppTheme.lightTheme,
    );
  }
}
