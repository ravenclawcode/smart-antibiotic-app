class QuizResult {
  final int score;
  final int correctAnswers;
  final int wrongAnswers;

  QuizResult({
    required this.score,
    required this.correctAnswers,
    required this.wrongAnswers,
  });

  factory QuizResult.fromJson(Map<String, dynamic> json) {
    return QuizResult(
      score: json['score'] as int,
      correctAnswers: json['correct_answers'] as int,
      wrongAnswers: json['wrong_answers'] as int,
    );
  }

  int get totalQuestions {
    return correctAnswers + wrongAnswers;
  }
}
