import 'chat_message_model.dart';

class ChatSessionModel {
  final int id;
  final int userId;
  final String? title;
  final List<ChatMessageModel> messages;

  const ChatSessionModel({
    required this.id,
    required this.userId,
    required this.title,
    required this.messages,
  });

  factory ChatSessionModel.fromJson(Map<String, dynamic> json) {
    final messagesJson = json['messages'];

    return ChatSessionModel(
      id: json['id'] is int
          ? json['id']
          : int.tryParse(json['id']?.toString() ?? '') ?? 0,
      userId: json['user_id'] is int
          ? json['user_id']
          : int.tryParse(json['user_id']?.toString() ?? '') ?? 0,
      title: json['title']?.toString(),
      messages: messagesJson is List
          ? messagesJson
                .whereType<Map>()
                .map(
                  (item) => ChatMessageModel.fromJson(
                    Map<String, dynamic>.from(item),
                  ),
                )
                .toList()
          : [],
    );
  }
}
