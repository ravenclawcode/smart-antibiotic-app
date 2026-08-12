class ProfileModel {
  final String uuid;
  final String name;
  final int? age;
  final String? gender;

  const ProfileModel({
    required this.uuid,
    required this.name,
    this.age,
    this.gender,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      uuid: json['uuid']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      age: json['age'] != null ? int.tryParse(json['age'].toString()) : null,
      gender: json['gender']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {'uuid': uuid, 'name': name, 'age': age, 'gender': gender};
  }
}
