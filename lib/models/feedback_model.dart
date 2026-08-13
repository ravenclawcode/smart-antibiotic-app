class FeedbackModel {
  final int id;
  final String name;
  final String message;
  final String status;
  final String? adminReply;
  final String createdAt;

  const FeedbackModel({
    required this.id,
    required this.name,
    required this.message,
    required this.status,
    required this.adminReply,
    required this.createdAt,
  });

  factory FeedbackModel.fromJson(Map<String, dynamic> json) {
    return FeedbackModel(
      id: json['id'] as int,
      name: json['name']?.toString() ?? '',
      message: json['message']?.toString() ?? '',
      status: json['status']?.toString() ?? 'pending',
      adminReply: json['admin_reply']?.toString(),
      createdAt: json['created_at']?.toString() ?? '',
    );
  }
}
