class QuizQuestionModel {
  final int id;
  final String question;
  final String optionA;
  final String optionB;
  final String optionC;
  final String optionD;

  QuizQuestionModel({
    required this.id,
    required this.question,
    required this.optionA,
    required this.optionB,
    required this.optionC,
    required this.optionD,
  });

  factory QuizQuestionModel.fromJson(Map<String, dynamic> json) {
    return QuizQuestionModel(
      id: json['id'] as int,
      question: json['question'] as String,
      optionA: json['option_a'] as String,
      optionB: json['option_b'] as String,
      optionC: json['option_c'] as String,
      optionD: json['option_d'] as String,
    );
  }

  List<String> get options {
    return [optionA, optionB, optionC, optionD];
  }
}
