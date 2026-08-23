class QuizResultModel {
  final int score;
  final int correctAnswers;
  final int wrongAnswers;

  QuizResultModel({
    required this.score,
    required this.correctAnswers,
    required this.wrongAnswers,
  });

  factory QuizResultModel.fromJson(Map<String, dynamic> json) {
    return QuizResultModel(
      score: json['score'] as int,
      correctAnswers: json['correct_answers'] as int,
      wrongAnswers: json['wrong_answers'] as int,
    );
  }

  int get totalQuestions {
    return correctAnswers + wrongAnswers;
  }
}
