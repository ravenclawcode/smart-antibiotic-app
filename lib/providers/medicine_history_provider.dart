import 'package:flutter/foundation.dart';

import '../services/medicine_history_service.dart';

class MedicineHistoryProvider extends ChangeNotifier {
  final MedicineHistoryService service;

  MedicineHistoryProvider({required this.service});

  final bool _isLoading = false;

  List<Map<String, dynamic>> _historyItems = [];

  List<Map<String, dynamic>> _medicineOptions = [];

  Map<String, dynamic>? _period;

  List<Map<String, dynamic>> get historyItems => _historyItems;

  List<Map<String, dynamic>> get medicineOptions => _medicineOptions;

  Map<String, dynamic>? get period => _period;

  bool get isLoading => _isLoading;

  Future<void> fetchHistory({
    String? medicineId,
    required String format,
  }) async {
    final response = await service.getHistory(
      medicineId: medicineId,
      format: format,
    );

    _period = response['period'] != null
        ? Map<String, dynamic>.from(response['period'])
        : null;

    _historyItems = [];

    final data = response['data'];

    if (data is List) {
      for (final day in data) {
        final dayData = Map<String, dynamic>.from(day);

        final date = dayData['date']?.toString() ?? '';

        final items = dayData['items'];

        if (items is List) {
          for (final item in items) {
            final history = Map<String, dynamic>.from(item);

            _historyItems.add({...history, 'date': date});
          }
        }
      }
    }

    notifyListeners();
  }

  Future<void> fetchMedicineOptions() async {
    _medicineOptions = await service.getMedicineFilter();

    notifyListeners();
  }

  Future<Uint8List> exportPdf({String? medicineId, required String format}) {
    return service.exportPdf(medicineId: medicineId, format: format);
  }

  Future<void> taken({
    required int scheduleTimeId,
    required String scheduledDate,
    required String actionTime,
  }) async {
    await service.taken(
      scheduleTimeId: scheduleTimeId,
      scheduledDate: scheduledDate,
      actionTime: actionTime,
    );
  }

  Future<void> skipped({
    required int scheduleTimeId,
    required String scheduledDate,
    required String actionTime,
    required String notes,
  }) async {
    await service.skipped(
      scheduleTimeId: scheduleTimeId,
      scheduledDate: scheduledDate,
      actionTime: actionTime,
      notes: notes,
    );
  }

  Future<void> reschedule({
    required int scheduleTimeId,
    required String scheduledDate,
    required String rescheduledTime,
  }) async {
    await service.reschedule(
      scheduleTimeId: scheduleTimeId,
      scheduledDate: scheduledDate,
      rescheduledTime: rescheduledTime,
    );
  }

  Future<void> missed({
    required int scheduleTimeId,
    required String scheduledDate,
  }) async {
    await service.missed(
      scheduleTimeId: scheduleTimeId,
      scheduledDate: scheduledDate,
    );
  }
}
