class AntibioticDetailModel {
  final int id;
  final String name;
  final String? image;

  final String summary;
  final String indication;
  final String mechanism;
  final String dosage;

  final String? videoUrl;
  final String? videoTitle;
  final String? videoDuration;
  final String? videoThumbnail;

  AntibioticDetailModel({
    required this.id,
    required this.name,
    this.image,
    required this.summary,
    required this.indication,
    required this.mechanism,
    required this.dosage,
    this.videoUrl,
    this.videoTitle,
    this.videoDuration,
    this.videoThumbnail,
  });

  factory AntibioticDetailModel.fromJson(Map<String, dynamic> json) {
    return AntibioticDetailModel(
      id: json['id'],
      name: json['name'] ?? '',
      image: json['image'],

      summary: json['summary'] ?? '',
      indication: json['indication'] ?? '',
      mechanism: json['mechanism'] ?? '',
      dosage: json['dosage'] ?? '',

      videoUrl: json['video_url'],
      videoTitle: json['video_title'],
      videoDuration: json['video_duration'],
      videoThumbnail: json['video_thumbnail'],
    );
  }
}
