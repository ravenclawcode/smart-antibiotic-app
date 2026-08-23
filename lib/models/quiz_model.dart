class QuizModel {
  final int id;
  final int level;
  final String? description;

  QuizModel({required this.id, required this.level, this.description});

  factory QuizModel.fromJson(Map<String, dynamic> json) {
    return QuizModel(
      id: json['id'] as int,
      level: json['level'] as int,
      description: json['description'] as String?,
    );
  }
}
