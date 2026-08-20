import 'dart:typed_data';

import '../core/constants/api_constants.dart';
import '../core/error/api_exception.dart';
import '../core/network/api_client.dart';
import 'local_storage_service.dart';

class MedicineHistoryService {
  final ApiClient apiClient;
  final LocalStorageService localStorage;

  MedicineHistoryService({required this.apiClient, required this.localStorage});

  Future<String> _getUserUuid() async {
    final uuid = localStorage.getUserUuid();

    if (uuid == null || uuid.trim().isEmpty) {
      throw const ApiException(message: 'UUID pengguna tidak ditemukan.');
    }

    return uuid;
  }

  Future<Map<String, dynamic>> getHistory({
    String? medicineId,
    required String format,
    String? date,
  }) async {
    final uuid = await _getUserUuid();

    final queryParameters = <String, String>{'format': format};

    if (medicineId != null) {
      queryParameters['medicine_id'] = medicineId;
    }

    if (date != null) {
      queryParameters['date'] = date;
    }

    final response = await apiClient.get(
      ApiConstants.medicineHistories,
      queryParameters: queryParameters,
      headers: {'X-User-UUID': uuid},
    );

    if (response is! Map) {
      throw const ApiException(message: 'Response riwayat obat tidak valid.');
    }

    return Map<String, dynamic>.from(response);
  }

  Future<List<Map<String, dynamic>>> getMedicineFilter() async {
    final uuid = await _getUserUuid();

    final response = await apiClient.get(
      '${ApiConstants.medicineHistories}/filter-medicines',
      headers: {'X-User-UUID': uuid},
    );

    if (response is! Map) {
      throw const ApiException(message: 'Response filter obat tidak valid.');
    }

    final data = response['data'];

    if (data is! List) {
      throw const ApiException(message: 'Data filter obat tidak valid.');
    }

    return data.map((item) => Map<String, dynamic>.from(item)).toList();
  }

  Future<void> taken({
    required int scheduleTimeId,
    required String scheduledDate,
    required String actionTime,
  }) async {
    final uuid = await _getUserUuid();

    await apiClient.post(
      '${ApiConstants.medicineHistories}/taken',
      headers: {'X-User-UUID': uuid},
      body: {
        'schedule_time_id': scheduleTimeId,
        'scheduled_date': scheduledDate,
        'action_time': actionTime,
      },
    );
  }

  Future<void> skipped({
    required int scheduleTimeId,
    required String scheduledDate,
    required String actionTime,
    required String notes,
  }) async {
    final uuid = await _getUserUuid();

    await apiClient.post(
      '${ApiConstants.medicineHistories}/skipped',
      headers: {'X-User-UUID': uuid},
      body: {
        'schedule_time_id': scheduleTimeId,
        'scheduled_date': scheduledDate,
        'action_time': actionTime,
        'notes': notes,
      },
    );
  }

  Future<void> reschedule({
    required int scheduleTimeId,
    required String scheduledDate,
    required String rescheduledTime,
  }) async {
    final uuid = await _getUserUuid();

    await apiClient.post(
      '${ApiConstants.medicineHistories}/reschedule',
      headers: {'X-User-UUID': uuid},
      body: {
        'schedule_time_id': scheduleTimeId,
        'scheduled_date': scheduledDate,
        'rescheduled_time': rescheduledTime,
      },
    );
  }

  Future<void> missed({
    required int scheduleTimeId,
    required String scheduledDate,
  }) async {
    final uuid = await _getUserUuid();

    await apiClient.post(
      '${ApiConstants.medicineHistories}/missed',
      headers: {'X-User-UUID': uuid},
      body: {
        'schedule_time_id': scheduleTimeId,
        'scheduled_date': scheduledDate,
      },
    );
  }

  Future<void> cancel({
    required int scheduleTimeId,
    required String scheduledDate,
  }) async {
    final uuid = await _getUserUuid();

    await apiClient.post(
      '${ApiConstants.medicineHistories}/cancel',
      headers: {'X-User-UUID': uuid},
      body: {
        'schedule_time_id': scheduleTimeId,
        'scheduled_date': scheduledDate,
      },
    );
  }

  Future<Uint8List> exportPdf({
    String? medicineId,
    required String format,
  }) async {
    final uuid = await _getUserUuid();

    final queryParameters = <String, String>{'format': format};

    if (medicineId != null) {
      queryParameters['medicine_id'] = medicineId;
    }

    return apiClient.getBytes(
      '${ApiConstants.medicineHistories}/export-pdf',
      queryParameters: queryParameters,
      headers: {'X-User-UUID': uuid},
    );
  }
}
