import 'package:smart_antibiotic/core/network/api_client.dart';
import 'package:smart_antibiotic/models/antibiotic_category_model.dart';
import 'package:smart_antibiotic/models/antibiotic_detail_model.dart';
import 'package:smart_antibiotic/models/antibiotic_model.dart';

class AntibioticService {
  final ApiClient apiClient;

  AntibioticService({required this.apiClient});

  Future<List<AntibioticCategoryModel>> getCategories() async {
    final response = await apiClient.get('/categories');

    final data = response['data'] as List;

    return data.map((json) => AntibioticCategoryModel.fromJson(json)).toList();
  }

  Future<List<AntibioticModel>> getAntibioticsByCategory(int categoryId) async {
    final response = await apiClient.get('/categories/$categoryId/antibiotics');

    final data = response['data'] as List;

    return data.map((json) => AntibioticModel.fromJson(json)).toList();
  }

  Future<List<AntibioticCategoryModel>> searchCategories(String keyword) async {
    final response = await apiClient.get(
      '/categories/search',
      queryParameters: {'q': keyword},
    );

    final data = response['data'] as List;

    return data.map((json) => AntibioticCategoryModel.fromJson(json)).toList();
  }

  Future<AntibioticDetailModel> getAntibioticDetail({
    required int categoryId,
    required int antibioticId,
  }) async {
    final response = await apiClient.get(
      '/categories/$categoryId/antibiotics/$antibioticId',
    );

    return AntibioticDetailModel.fromJson(response['data']);
  }
}
