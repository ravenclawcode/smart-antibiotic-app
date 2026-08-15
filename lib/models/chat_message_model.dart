class ChatMessageModel {
  final int id;
  final int sessionId;
  final String sender;
  final String message;
  final DateTime createdAt;

  const ChatMessageModel({
    required this.id,
    required this.sessionId,
    required this.sender,
    required this.message,
    required this.createdAt,
  });

  bool get isUser => sender == 'user';

  factory ChatMessageModel.fromJson(Map<String, dynamic> json) {
    final rawCreatedAt = json['created_at']?.toString();

    DateTime createdAt;

    if (rawCreatedAt != null && rawCreatedAt.isNotEmpty) {
      createdAt = DateTime.tryParse(rawCreatedAt)?.toLocal() ?? DateTime.now();
    } else {
      createdAt = DateTime.now();
    }

    return ChatMessageModel(
      id: json['id'] is int
          ? json['id']
          : int.tryParse(json['id']?.toString() ?? '') ?? 0,

      sessionId: json['session_id'] is int
          ? json['session_id']
          : int.tryParse(json['session_id']?.toString() ?? '') ?? 0,

      sender: json['sender']?.toString() ?? 'assistant',

      message: json['message']?.toString() ?? '',

      createdAt: createdAt,
    );
  }
}
