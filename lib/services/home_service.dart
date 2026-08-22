import '../core/constants/api_constants.dart';
import '../core/error/api_exception.dart';
import '../core/network/api_client.dart';
import 'local_storage_service.dart';

class HomeService {
  final ApiClient apiClient;
  final LocalStorageService localStorage;

  HomeService({required this.apiClient, required this.localStorage});

  Future<Map<String, dynamic>> getHome({String? date}) async {
    final uuid = localStorage.getUserUuid();

    if (uuid == null || uuid.trim().isEmpty) {
      throw const ApiException(message: 'UUID pengguna tidak ditemukan.');
    }

    final queryParameters = <String, String>{};

    if (date != null && date.isNotEmpty) {
      queryParameters['date'] = date;
    }

    final response = await apiClient.get(
      ApiConstants.home,
      queryParameters: queryParameters.isEmpty ? null : queryParameters,
      headers: {'X-User-UUID': uuid},
    );

    if (response is! Map) {
      throw const ApiException(message: 'Response data Home tidak valid.');
    }

    if (response['success'] != true) {
      throw ApiException(
        message:
            response['message']?.toString() ?? 'Gagal mengambil data Home.',
      );
    }

    final data = response['data'];

    if (data is! Map) {
      throw const ApiException(message: 'Data Home tidak valid.');
    }

    return Map<String, dynamic>.from(data);
  }
}
