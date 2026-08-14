class AntibioticModel {
  final int id;
  final int categoryId;
  final String? categoryName;
  final String name;
  final String? image;

  AntibioticModel({
    required this.id,
    required this.categoryId,
    this.categoryName,
    required this.name,
    this.image,
  });

  factory AntibioticModel.fromJson(Map<String, dynamic> json) {
    return AntibioticModel(
      id: json['id'],
      categoryId: json['category_id'],
      categoryName: json['category_name'],
      name: json['name'] ?? '',
      image: json['image'],
    );
  }
}
