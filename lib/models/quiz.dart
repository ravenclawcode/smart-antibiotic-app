class Quiz {
  final int id;
  final int level;
  final String? description;

  Quiz({required this.id, required this.level, this.description});

  factory Quiz.fromJson(Map<String, dynamic> json) {
    return Quiz(
      id: json['id'] as int,
      level: json['level'] as int,
      description: json['description'] as String?,
    );
  }
}
