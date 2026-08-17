import '../core/constants/api_constants.dart';
import '../core/error/api_exception.dart';
import '../core/network/api_client.dart';
import '../models/medicine_catalog_model.dart';

class MedicineCatalogService {
  final ApiClient apiClient;

  MedicineCatalogService({required this.apiClient});

  Future<List<MedicineCatalogModel>> searchCatalogs({String? search}) async {
    final keyword = search?.trim() ?? '';

    final response = await apiClient.get(
      ApiConstants.medicineCatalogs,
      queryParameters: keyword.isEmpty ? null : {'search': keyword},
    );

    if (response is! Map) {
      throw const ApiException(message: 'Response katalog obat tidak valid.');
    }

    if (response['success'] != true) {
      throw ApiException(
        message:
            response['message']?.toString() ?? 'Gagal mengambil katalog obat.',
      );
    }

    final data = response['data'];

    if (data is! List) {
      throw const ApiException(message: 'Data katalog obat tidak valid.');
    }

    return data
        .map(
          (item) =>
              MedicineCatalogModel.fromJson(Map<String, dynamic>.from(item)),
        )
        .where((item) => item.id > 0 && item.name.trim().isNotEmpty)
        .toList();
  }
}
