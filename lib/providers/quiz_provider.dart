import 'package:flutter/foundation.dart';

import '../models/quiz_model.dart';
import '../models/quiz_question_model.dart';
import '../models/quiz_result_model.dart';
import '../services/quiz_service.dart';

class QuizProvider extends ChangeNotifier {
  final QuizService service;

  QuizProvider({required this.service});

  List<QuizModel> _quizzes = [];

  QuizModel? _selectedQuiz;

  List<QuizQuestionModel> _questions = [];

  QuizResultModel? _result;

  bool _isLoading = false;
  bool _isSubmitting = false;

  String? _errorMessage;

  List<QuizModel> get quizzes => _quizzes;

  QuizModel? get selectedQuiz => _selectedQuiz;

  List<QuizQuestionModel> get questions => _questions;

  QuizResultModel? get result => _result;

  bool get isLoading => _isLoading;

  bool get isSubmitting => _isSubmitting;

  String? get errorMessage => _errorMessage;

  Future<void> loadQuizzes() async {
    _isLoading = true;
    _errorMessage = null;

    notifyListeners();

    try {
      _quizzes = await service.getQuizzes();
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadQuizDetail(int quizId) async {
    _isLoading = true;
    _errorMessage = null;

    notifyListeners();

    try {
      final detail = await service.getQuizDetail(quizId);

      _selectedQuiz = detail.quiz;
      _questions = detail.questions;
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> submitQuiz({
    required int quizId,
    required List<Map<String, dynamic>> answers,
  }) async {
    _isSubmitting = true;
    _errorMessage = null;

    notifyListeners();

    try {
      _result = await service.submitQuiz(quizId: quizId, answers: answers);

      return true;
    } catch (e) {
      _errorMessage = e.toString();

      return false;
    } finally {
      _isSubmitting = false;
      notifyListeners();
    }
  }

  void clearQuizDetail() {
    _selectedQuiz = null;
    _questions = [];
    _result = null;
    _errorMessage = null;

    notifyListeners();
  }

  void clearResult() {
    _result = null;
    _errorMessage = null;

    notifyListeners();
  }
}
