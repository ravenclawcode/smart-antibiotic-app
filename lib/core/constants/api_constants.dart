class ApiConstants {
  ApiConstants._();

  // static const String baseUrl = 'http://10.0.2.2:8000/api';
  static const String baseUrl = 'http://10.30.73.109:8000/api';

  // Public
  static const String onboarding = '/onboarding';
  static const String splash = '/splash';

  // User
  static const String profile = '/profile';
  static const String preferences = '/preferences';
  static const String home = '/home';

  // Feedback
  static const String feedbacks = '/feedbacks';

  // Antibiotics
  static const String antibioticCategories = '/categories';
  static const String antibioticSearch = '/categories/search';

  // Quiz
  static const String quizzes = '/quizzes';

  // Chatbot
  static const String chatbotSession = '/chatbot/session';
  static const String chatbotSend = '/chatbot/send';

  // Medicine
  static const String medicines = '/medicines';
  static const String medicineCatalogs = '/medicine-catalogs';

  // Medicine History
  static const String medicineHistories = '/medicine-histories';
  static const String medicineHistoryFilterMedicines =
      '/medicine-histories/filter-medicines';
  static const String medicineHistoryExportPdf =
      '/medicine-histories/export-pdf';
  static const String medicineHistoryTaken = '/medicine-histories/taken';
  static const String medicineHistorySkipped = '/medicine-histories/skipped';
  static const String medicineHistoryReschedule =
      '/medicine-histories/reschedule';
  static const String medicineHistoryMissed = '/medicine-histories/missed';
  static const String medicineHistoryCancel = '/medicine-histories/cancel';
}
