import '../core/constants/api_constants.dart';
import '../core/network/api_client.dart';
import '../models/feedback_model.dart';
import 'local_storage_service.dart';

class FeedbackService {
  final ApiClient apiClient;
  final LocalStorageService localStorage;

  FeedbackService({required this.apiClient, required this.localStorage});

  Future<List<FeedbackModel>> getFeedbacks() async {
    final uuid = localStorage.getUserUuid();

    if (uuid == null || uuid.trim().isEmpty) {
      throw Exception('User UUID tidak ditemukan.');
    }

    final response = await apiClient.get(
      ApiConstants.feedbacks,
      headers: {'X-User-UUID': uuid},
    );

    if (response is! Map) {
      throw Exception('Response feedback tidak valid.');
    }

    if (response['success'] != true) {
      throw Exception(response['message'] ?? 'Gagal mengambil feedback.');
    }

    final data = response['data'];

    if (data is! List) {
      throw Exception('Data feedback tidak valid.');
    }

    return data
        .map((item) => FeedbackModel.fromJson(Map<String, dynamic>.from(item)))
        .toList();
  }

  Future<void> createFeedback(String message) async {
    final uuid = localStorage.getUserUuid();

    if (uuid == null || uuid.trim().isEmpty) {
      throw Exception('User UUID tidak ditemukan.');
    }

    final response = await apiClient.post(
      ApiConstants.feedbacks,
      headers: {'X-User-UUID': uuid},
      body: {'message': message.trim()},
    );

    if (response is! Map) {
      throw Exception('Response feedback tidak valid.');
    }

    if (response['success'] != true) {
      throw Exception(response['message'] ?? 'Gagal mengirim feedback.');
    }
  }

  Future<void> deleteFeedback(int feedbackId) async {
    final uuid = localStorage.getUserUuid();

    if (uuid == null || uuid.trim().isEmpty) {
      throw Exception('User UUID tidak ditemukan.');
    }

    final response = await apiClient.delete(
      '${ApiConstants.feedbacks}/$feedbackId',
      headers: {'X-User-UUID': uuid},
    );

    if (response is! Map) {
      throw Exception('Response hapus feedback tidak valid.');
    }

    if (response['success'] != true) {
      throw Exception(response['message'] ?? 'Gagal menghapus feedback.');
    }
  }
}
