import '../core/constants/api_constants.dart';
import '../core/network/api_client.dart';
import '../models/chat_message_model.dart';
import '../models/chat_session_model.dart';

class ChatbotService {
  final ApiClient apiClient;

  ChatbotService({required this.apiClient});

  Future<ChatSessionModel> getSession(String userUuid) async {
    if (userUuid.isEmpty) {
      throw Exception('User UUID tidak ditemukan.');
    }

    final response = await apiClient.get(
      ApiConstants.chatbotSession,
      headers: {'X-User-UUID': userUuid},
    );

    final data = response['data'];

    if (data is! Map) {
      throw Exception('Data session chatbot tidak valid.');
    }

    return ChatSessionModel.fromJson(Map<String, dynamic>.from(data));
  }

  Future<ChatMessageModel> sendMessage({
    required String userUuid,
    required String message,
  }) async {
    if (userUuid.isEmpty) {
      throw Exception('User UUID tidak ditemukan.');
    }

    final response = await apiClient.post(
      ApiConstants.chatbotSend,
      headers: {'X-User-UUID': userUuid},
      body: {'message': message},
    );

    final data = response['data'];

    if (data is! Map) {
      throw Exception('Response chatbot tidak valid.');
    }

    return ChatMessageModel.fromJson(Map<String, dynamic>.from(data));
  }

  Future<void> deleteSession(String userUuid) async {
    if (userUuid.isEmpty) {
      throw Exception('User UUID tidak ditemukan.');
    }

    await apiClient.delete(
      ApiConstants.chatbotSession,
      headers: {'X-User-UUID': userUuid},
    );
  }
}
