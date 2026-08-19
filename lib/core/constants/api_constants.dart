class ApiConstants {
  ApiConstants._();

  static const String baseUrl = 'http://10.0.2.2:8000/api';
  // static const String baseUrl = 'http://10.125.192.109:8000/api';

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
}
