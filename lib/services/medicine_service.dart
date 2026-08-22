import '../core/constants/api_constants.dart';
import '../core/error/api_exception.dart';
import '../core/network/api_client.dart';
import '../models/medicine_model.dart';
import 'local_storage_service.dart';

class MedicineService {
  final ApiClient apiClient;
  final LocalStorageService localStorage;

  MedicineService({required this.apiClient, required this.localStorage});

  Future<String> _getUserUuid() async {
    final uuid = localStorage.getUserUuid();

    if (uuid == null || uuid.trim().isEmpty) {
      throw const ApiException(message: 'UUID pengguna tidak ditemukan.');
    }

    return uuid;
  }

  Future<List<MedicineModel>> getMedicines() async {
    final uuid = await _getUserUuid();

    final response = await apiClient.get(
      ApiConstants.medicines,
      headers: {'X-User-UUID': uuid},
    );

    if (response is! Map) {
      throw const ApiException(message: 'Response obat tidak valid.');
    }

    final data = response['data'];

    if (data is! List) {
      throw const ApiException(message: 'Data obat tidak valid.');
    }

    return data
        .map((item) => MedicineModel.fromJson(Map<String, dynamic>.from(item)))
        .toList();
  }

  Future<MedicineModel> getMedicine(int id) async {
    final uuid = await _getUserUuid();

    final response = await apiClient.get(
      '${ApiConstants.medicines}/$id',
      headers: {'X-User-UUID': uuid},
    );

    if (response is! Map) {
      throw const ApiException(message: 'Response detail obat tidak valid.');
    }

    if (response['success'] != true) {
      throw ApiException(
        message:
            response['message']?.toString() ?? 'Gagal mengambil detail obat.',
      );
    }

    final data = response['data'];

    if (data is! Map) {
      throw const ApiException(message: 'Data detail obat tidak valid.');
    }

    return MedicineModel.fromJson(Map<String, dynamic>.from(data));
  }

  Future<MedicineModel> createMedicine(MedicineModel medicine) async {
    final uuid = await _getUserUuid();

    final response = await apiClient.post(
      ApiConstants.medicines,
      headers: {'X-User-UUID': uuid},
      body: medicine.toRequestJson(),
    );

    if (response is! Map) {
      throw const ApiException(
        message: 'Response penyimpanan obat tidak valid.',
      );
    }

    if (response['success'] != true) {
      throw ApiException(
        message: response['message']?.toString() ?? 'Gagal menyimpan obat.',
      );
    }

    final data = response['data'];

    if (data is! Map) {
      throw const ApiException(
        message: 'Data obat yang dikembalikan tidak valid.',
      );
    }

    return MedicineModel.fromJson(Map<String, dynamic>.from(data));
  }

  Future<MedicineModel> updateMedicine(int id, MedicineModel medicine) async {
    final uuid = await _getUserUuid();

    final response = await apiClient.put(
      '${ApiConstants.medicines}/$id',
      headers: {'X-User-UUID': uuid},
      body: medicine.toRequestJson(),
    );

    if (response is! Map) {
      throw const ApiException(message: 'Response update obat tidak valid.');
    }

    if (response['success'] != true) {
      throw ApiException(
        message: response['message']?.toString() ?? 'Gagal memperbarui obat.',
      );
    }

    final data = response['data'];

    if (data is! Map) {
      throw const ApiException(message: 'Data update obat tidak valid.');
    }

    return MedicineModel.fromJson(Map<String, dynamic>.from(data));
  }

  Future<void> deleteMedicine(int id) async {
    final uuid = await _getUserUuid();

    final response = await apiClient.delete(
      '${ApiConstants.medicines}/$id',
      headers: {'X-User-UUID': uuid},
    );

    if (response is! Map) {
      throw const ApiException(message: 'Response hapus obat tidak valid.');
    }

    if (response['success'] != true) {
      throw ApiException(
        message: response['message']?.toString() ?? 'Gagal menghapus obat.',
      );
    }
  }

  Future<void> deleteMedicinePermanent(int id) async {
    final uuid = await _getUserUuid();

    final response = await apiClient.delete(
      '${ApiConstants.medicines}/$id/permanent',
      headers: {'X-User-UUID': uuid},
    );

    if (response is! Map) {
      throw const ApiException(
        message: 'Response hapus permanen obat tidak valid.',
      );
    }

    if (response['success'] != true) {
      throw ApiException(
        message:
            response['message']?.toString() ??
            'Gagal menghapus obat secara permanen.',
      );
    }
  }

  Future<void> deleteDose({
    required int medicineId,
    required int scheduleTimeId,
    required String scheduledDate,
  }) async {
    final uuid = await _getUserUuid();

    final response = await apiClient.delete(
      '${ApiConstants.medicines}/medicines/$medicineId/single-dose',
      queryParameters: {
        'schedule_time_id': scheduleTimeId.toString(),
        'scheduled_date': scheduledDate,
      },
      headers: {'X-User-UUID': uuid},
    );

    if (response is! Map) {
      throw const ApiException(message: 'Response hapus dosis tidak valid.');
    }

    if (response['success'] != true) {
      throw ApiException(
        message: response['message']?.toString() ?? 'Gagal menghapus dosis.',
      );
    }
  }

  Future<void> deleteFutureDoses({
    required int medicineId,
    required int scheduleTimeId,
    required String scheduledDate,
  }) async {
    final uuid = await _getUserUuid();

    final response = await apiClient.delete(
      '${ApiConstants.medicines}/$medicineId/future-doses',
      queryParameters: {
        'schedule_time_id': scheduleTimeId.toString(),
        'scheduled_date': scheduledDate,
      },
      headers: {'X-User-UUID': uuid},
    );

    if (response is! Map) {
      throw const ApiException(
        message: 'Response penghentian dosis tidak valid.',
      );
    }

    if (response['success'] != true) {
      throw ApiException(
        message:
            response['message']?.toString() ??
            'Gagal menghentikan dosis berikutnya.',
      );
    }
  }
}
