class MedicineCatalogModel {
  final int id;
  final String name;
  final String? image;

  const MedicineCatalogModel({
    required this.id,
    required this.name,
    this.image,
  });

  factory MedicineCatalogModel.fromJson(Map<String, dynamic> json) {
    return MedicineCatalogModel(
      id: int.tryParse(json['id'].toString()) ?? 0,
      name: json['name']?.toString() ?? '',
      image: json['image']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'image': image};
  }
}
