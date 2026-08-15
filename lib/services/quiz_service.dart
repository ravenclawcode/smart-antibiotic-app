import '../core/network/api_client.dart';
import '../core/constants/api_constants.dart';
import '../models/quiz.dart';
import '../models/quiz_question.dart';
import '../models/quiz_result.dart';
import 'local_storage_service.dart';

class QuizService {
  final ApiClient apiClient;
  final LocalStorageService localStorage;

  QuizService({required this.apiClient, required this.localStorage});

  Future<List<Quiz>> getQuizzes() async {
    final response = await apiClient.get(ApiConstants.quizzes);

    final List data = response['data'] as List;

    return data
        .map((json) => Quiz.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  Future<QuizDetail> getQuizDetail(int quizId) async {
    final response = await apiClient.get('${ApiConstants.quizzes}/$quizId');

    final data = response['data'] as Map<String, dynamic>;

    final quiz = Quiz(
      id: data['id'] as int,
      level: data['level'] as int,
      description: data['description'] as String?,
    );

    final questionsData = data['questions'] as List;

    final questions = questionsData
        .map((json) => QuizQuestion.fromJson(json as Map<String, dynamic>))
        .toList();

    return QuizDetail(quiz: quiz, questions: questions);
  }

  Future<QuizResult> submitQuiz({
    required int quizId,
    required List<Map<String, dynamic>> answers,
  }) async {
    final uuid = localStorage.getUserUuid();

    if (uuid == null || uuid.isEmpty) {
      throw Exception('User UUID tidak ditemukan.');
    }

    final response = await apiClient.post(
      '${ApiConstants.quizzes}/$quizId/submit',
      headers: {'X-User-UUID': uuid},
      body: {'answers': answers},
    );

    return QuizResult.fromJson(response['data'] as Map<String, dynamic>);
  }
}

class QuizDetail {
  final Quiz quiz;
  final List<QuizQuestion> questions;

  QuizDetail({required this.quiz, required this.questions});
}
