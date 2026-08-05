import 'package:flutter/material.dart';
import 'package:smart_antibiotic/screens/chatbot/chatbot_screen.dart';
import 'package:smart_antibiotic/screens/education/education_antibiotik_detail_screen.dart';
import 'package:smart_antibiotic/screens/education/education_antibiotik_screen.dart';
import 'package:smart_antibiotic/screens/education/education_category_screen.dart';
import 'package:smart_antibiotic/screens/education/education_definition_screen.dart';
import 'package:smart_antibiotic/screens/education/education_indications_screen.dart';
import 'package:smart_antibiotic/screens/education/education_resistance_screen.dart';
import 'package:smart_antibiotic/screens/education/education_screen.dart';
import 'package:smart_antibiotic/screens/education/education_types_screen.dart';
import 'package:smart_antibiotic/screens/education/education_usage_screen.dart';
import 'package:smart_antibiotic/screens/home/home_screen.dart';
import 'package:smart_antibiotic/screens/medicine/medicine_detail_screen.dart';
import 'package:smart_antibiotic/screens/medicine/medicine_edit_dosage_screen.dart';
import 'package:smart_antibiotic/screens/medicine/medicine_edit_name_screen.dart';
import 'package:smart_antibiotic/screens/medicine/medicine_edit_schedule_screen.dart';
import 'package:smart_antibiotic/screens/medicine/medicine_parent_screen.dart';
import 'package:smart_antibiotic/screens/medicine/medicine_screen.dart';
import 'package:smart_antibiotic/screens/onboarding/onboarding_intro_screen.dart';
import 'package:smart_antibiotic/screens/onboarding/onboarding_parent_screen.dart';
import 'package:smart_antibiotic/screens/quiz/quiz_result_screen.dart';
import 'package:smart_antibiotic/screens/quiz/quiz_screen.dart';
import 'package:smart_antibiotic/screens/settings/settings_alarm_optimization_screen.dart';
import 'package:smart_antibiotic/screens/settings/settings_comments_and_feedback.dart';
import 'package:smart_antibiotic/screens/settings/settings_detail_alarm_optimization_screen.dart';
import 'package:smart_antibiotic/screens/settings/settings_detail_alarm_permissions_screen.dart';
import 'package:smart_antibiotic/screens/settings/settings_detail_app_permissions_screen.dart';
import 'package:smart_antibiotic/screens/settings/settings_edit_profil_screen.dart';
import 'package:smart_antibiotic/screens/settings/settings_edit_preference_screen.dart';
import 'package:smart_antibiotic/screens/settings/settings_screen.dart';
import '../screens/medicine/medicine_edit_dose_amount_screen.dart';
import '../screens/medicine/medicine_edit_duration_screen.dart';
import '../screens/medicine/medicine_edit_instruction_screen.dart';
import '../screens/medicine/medicine_history_screen.dart';
import '../screens/onboarding/onboarding_permission_screen.dart';

import '../screens/main_screen.dart';
import '../screens/onboarding/onboarding_splash_screen.dart';
import '../screens/onboarding/onboarding_welcome_screen.dart';
import '../screens/quiz/quiz_detail_screen.dart';

class Routes {
  static const String main = '/';

  static const String onboardingSplash = '/onboarding-splash';
  static const String onboardingWelcome = '/onboarding-welcome';
  static const String onboardingIntro = '/onboarding-intro';
  static const String onboardingSteps = '/onboarding-steps';
  static const String onboardingPermission = '/onboarding-permission';

  static const String home = '/home';

  static const String medicine = '/medicine';
  static const String medicineDetail = '/medicine-detail';
  static const String medicineHistory = '/medicine-history';

  static const String medicineSteps = '/medicine-steps';

  static const String medicineEditName = '/medicine-edit-name';
  static const String medicineEditSchedule = '/medicine-edit-schedule';
  static const String medicineEditDosage = '/medicine-edit-dosage';
  static const String medicineEditDuration = '/medicine-edit-duration';
  static const String medicineEditDoseAmount = '/medicine-edit-dose-amount';
  static const String medicineEditInstruction = '/medicine-edit-instruction';

  static const String education = '/education';
  static const String educationDefinition = '/education-definition';
  static const String educationType = '/education-type';
  static const String educationIndications = '/education-indications';
  static const String educationUsage = '/education-usage';
  static const String educationResistance = '/education-resistance';
  static const String educationCategory = '/education-category';
  static const String educationAntibiotik = '/education-antibiotik';
  static const String educationDetail = '/education-detail';

  static const String quiz = '/quiz';
  static const String quizDetail = '/quiz-detail';
  static const String quizResult = '/quiz-result';

  static const String settings = '/settings';
  static const String settingsEditProfile = '/settings-edit-profile';
  static const String settingsPreferences = '/settings-preference';
  static const String settingsAlarmOptimization =
      '/settings-alarm-optimization';
  static const String settingsCommentsAndFeedback =
      '/settings-comments-and-feedback';
  static const String settingsDetailAlarmOptimization =
      '/settings-detail-alarm-optimization';
  static const String settingsDetailAlarmPermissions =
      '/settings-detail-alarm-permissions';
  static const String settingsDetailAppPermissions =
      '/settings-detail-app-permissions';

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
    case Routes.medicineDetail:
      return MaterialPageRoute(
        builder: (_) => const MedicineDetailScreen(),
        settings: settings,
      );
    case Routes.medicineHistory:
      return MaterialPageRoute(builder: (_) => const MedicineHistoryScreen());

    case Routes.medicineSteps:
      return MaterialPageRoute(builder: (_) => const MedicineParentScreen());

    case Routes.medicineEditName:
      final args = settings.arguments as Map<String, dynamic>?;
      return MaterialPageRoute(
        builder: (_) => MedicineEditNameScreen(
          onNameChanged: args?['onNameChanged'] ?? (value) {},
        ),
        settings: settings,
      );
    case Routes.medicineEditSchedule:
      return MaterialPageRoute(
        builder: (_) => const MedicineEditScheduleScreen(),
        settings: settings,
      );
    case Routes.medicineEditDosage:
      return MaterialPageRoute(
        builder: (_) => const MedicineEditDosageScreen(),
        settings: settings,
      );
    case Routes.medicineEditDuration:
      return MaterialPageRoute(
        builder: (_) => const MedicineEditDurationScreen(),
        settings: settings,
      );
    case Routes.medicineEditDoseAmount:
      return MaterialPageRoute(
        builder: (_) => const MedicineEditDoseAmountScreen(),
        settings: settings,
      );
    case Routes.medicineEditInstruction:
      final args = settings.arguments as Map<String, dynamic>?;
      return MaterialPageRoute(
        builder: (_) => MedicineEditInstructionScreen(
          onNameChanged: args?['onNameChanged'] ?? (value) {},
        ),
        settings: settings,
      );

    case Routes.education:
      return MaterialPageRoute(builder: (_) => const EducationScreen());
    case Routes.educationDefinition:
      return MaterialPageRoute(
        builder: (_) => const EducationDefinitionScreen(),
      );
    case Routes.educationType:
      return MaterialPageRoute(builder: (_) => const EducationTypesScreen());
    case Routes.educationIndications:
      return MaterialPageRoute(
        builder: (_) => const EducationIndicationsScreen(),
      );
    case Routes.educationUsage:
      return MaterialPageRoute(builder: (_) => const EducationUsageScreen());
    case Routes.educationResistance:
      return MaterialPageRoute(
        builder: (_) => const EducationResistanceScreen(),
      );
    case Routes.educationCategory:
      return MaterialPageRoute(builder: (_) => const EducationCategoryScreen());
    case Routes.educationAntibiotik:
      return MaterialPageRoute(
        builder: (_) => const EducationAntibiotikScreen(),
      );
    case Routes.educationDetail:
      return MaterialPageRoute(
        builder: (_) => const EducationAntibiotikDetailScreen(),
      );

    case Routes.quiz:
      return MaterialPageRoute(builder: (_) => const QuizScreen());
    case Routes.quizDetail:
      return MaterialPageRoute(builder: (_) => const QuizDetailScreen());
    case Routes.quizResult:
      final args = settings.arguments as Map<String, dynamic>?;
      return MaterialPageRoute(
        builder: (_) => QuizResultScreen(
          score: args?['score'] as int? ?? 0,
          totalQuestions: args?['totalQuestions'] as int? ?? 0,
        ),
      );

    case Routes.settings:
      return MaterialPageRoute(builder: (_) => const SettingsScreen());
    case Routes.settingsEditProfile:
      final args = settings.arguments as Map<String, dynamic>?;
      return MaterialPageRoute(
        builder: (_) => SettingsEditProfilScreen(
          initialValue: args?['initialValue'] ?? 'Serra Gohv',
          onNameChanged: args?['onNameChanged'] ?? (value) {},
        ),
      );
    case Routes.settingsPreferences:
      final args = settings.arguments as Map<String, dynamic>?;
      return MaterialPageRoute(
        builder: (_) => SettingsEditPreferenceScreen(
          selectedType: args?['selectedType'] ?? 'Layar Penuh',
          onSelectType: args?['onSelectType'] ?? (value) {},
        ),
      );
    case Routes.settingsAlarmOptimization:
      return MaterialPageRoute(
        builder: (_) => const SettingsAlarmOptimizationScreen(),
      );
    case Routes.settingsCommentsAndFeedback:
      return MaterialPageRoute(
        builder: (_) => const SettingsCommentsAndFeedback(),
      );
    case Routes.settingsDetailAlarmOptimization:
      return MaterialPageRoute(
        builder: (_) => const SettingsDetailAlarmOptimizationScreen(),
      );
    case Routes.settingsDetailAlarmPermissions:
      return MaterialPageRoute(
        builder: (_) => const SettingsDetailAlarmPermissionsScreen(),
      );
    case Routes.settingsDetailAppPermissions:
      return MaterialPageRoute(
        builder: (_) => const SettingsDetailAppPermissionsScreen(),
      );

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
