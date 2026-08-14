class AntibioticCategoryModel {
  final int id;
  final String name;
  final String? image;
  final String? description;
  final int antibioticsCount;

  AntibioticCategoryModel({
    required this.id,
    required this.name,
    this.image,
    this.description,
    this.antibioticsCount = 0,
  });

  factory AntibioticCategoryModel.fromJson(Map<String, dynamic> json) {
    return AntibioticCategoryModel(
      id: json['id'],
      name: json['name'] ?? '',
      image: json['image'],
      description: json['description'],
      antibioticsCount: json['antibiotics_count'] ?? 0,
    );
  }
}
