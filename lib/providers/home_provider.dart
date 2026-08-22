import 'package:flutter/foundation.dart';

import '../models/home_medicine_item.dart';
import '../services/home_service.dart';
import '../services/medicine_history_service.dart';

class HomeProvider extends ChangeNotifier {
  final HomeService homeService;
  final MedicineHistoryService historyService;

  HomeProvider({required this.homeService, required this.historyService});

  bool isLoading = false;
  bool isActionLoading = false;

  List<HomeMedicineItem> medicines = [];

  String? errorMessage;

  // =========================================================
  // LOAD HOME
  // =========================================================

  Future<void> load(DateTime date) async {
    isLoading = true;
    errorMessage = null;

    notifyListeners();

    try {
      final dateString = _formatDate(date);

      final response = await homeService.getHome(date: dateString);

      debugPrint('HOME RESPONSE: $response');

      dynamic schedules;

      if (response['today_schedules'] is List) {
        schedules = response['today_schedules'];
      } else if (response['schedules'] is List) {
        schedules = response['schedules'];
      } else if (response['medicines'] is List) {
        schedules = response['medicines'];
      }

      medicines = _parseHomeSchedules(schedules, dateString);

      debugPrint('HOME MEDICINES: ${medicines.length}');
    } catch (e) {
      errorMessage = e.toString();
      medicines = [];

      debugPrint('HOME ERROR: $e');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // =========================================================
  // PARSE HOME SCHEDULES
  // =========================================================

  List<HomeMedicineItem> _parseHomeSchedules(
    dynamic value,
    String scheduledDate,
  ) {
    if (value is! List) {
      debugPrint('HOME PARSER: schedules bukan List: $value');

      return [];
    }

    final result = <HomeMedicineItem>[];

    for (final item in value) {
      if (item is! Map) {
        continue;
      }

      final data = Map<String, dynamic>.from(item);

      debugPrint('HOME ITEM: $data');

      final medicine = data['medicine'];

      if (medicine is! Map) {
        debugPrint('HOME ITEM: medicine tidak ditemukan');

        continue;
      }

      final medicineData = Map<String, dynamic>.from(medicine);

      final medicineId =
          int.tryParse(medicineData['id']?.toString() ?? '') ?? 0;

      final scheduleTimeId =
          int.tryParse(data['schedule_time_id']?.toString() ?? '') ?? 0;

      if (medicineId == 0) {
        debugPrint('HOME ITEM: medicineId = 0');
      }

      final name = medicineData['name']?.toString() ?? '';

      final dosage = medicineData['dosage']?.toString() ?? '';

      final dosageUnit = medicineData['dosage_unit']?.toString() ?? '';

      final instruction = medicineData['instruction']?.toString();

      final time =
          data['reminder_time']?.toString() ?? data['time']?.toString() ?? '';

      final status = data['status']?.toString() ?? 'pending';

      result.add(
        HomeMedicineItem(
          medicineId: medicineId,
          scheduleTimeId: scheduleTimeId,
          scheduledDate: scheduledDate,
          name: name,
          dosage: _buildDosage(dosage, dosageUnit),
          time: _formatTime(time),
          instruction: instruction,
          status: status,
          takenAt: data['taken_at']?.toString(),
          skippedAt: data['skipped_at']?.toString(),
          notes: data['notes']?.toString(),
          rescheduledTime: _formatRescheduledTime(data['rescheduled_time']),
        ),
      );
    }

    result.sort((a, b) => a.time.compareTo(b.time));

    return result;
  }

  // =========================================================
  // DOSAGE
  // =========================================================

  String _buildDosage(String dosage, String dosageUnit) {
    dosage = dosage.trim();
    dosageUnit = dosageUnit.trim();

    if (dosage.isEmpty && dosageUnit.isEmpty) {
      return '';
    }

    if (dosageUnit.isEmpty) {
      return 'Minum $dosage';
    }

    if (dosage.isEmpty) {
      return 'Minum $dosageUnit';
    }

    return 'Minum $dosage $dosageUnit';
  }

  // =========================================================
  // FORMAT TIME
  // =========================================================

  String _formatTime(String value) {
    final text = value.trim();

    if (text.length >= 5) {
      return text.substring(0, 5);
    }

    return text;
  }

  // =========================================================
  // FORMAT DATE
  // =========================================================

  String _formatDate(DateTime date) {
    final month = date.month.toString().padLeft(2, '0');

    final day = date.day.toString().padLeft(2, '0');

    return '${date.year}-$month-$day';
  }

  // =========================================================
  // TAKEN
  // =========================================================

  Future<void> taken({
    required HomeMedicineItem item,
    required DateTime date,
    required String actionTime,
  }) async {
    await _runAction(() async {
      await historyService.taken(
        scheduleTimeId: item.scheduleTimeId,
        scheduledDate: _formatDate(date),
        actionTime: actionTime,
      );

      await load(date);
    });
  }

  // =========================================================
  // SKIPPED
  // =========================================================

  Future<void> skipped({
    required HomeMedicineItem item,
    required DateTime date,
    required String actionTime,
    required String notes,
  }) async {
    await _runAction(() async {
      await historyService.skipped(
        scheduleTimeId: item.scheduleTimeId,
        scheduledDate: _formatDate(date),
        actionTime: actionTime,
        notes: notes,
      );

      await load(date);
    });
  }

  // =========================================================
  // RESCHEDULE
  // =========================================================

  Future<void> reschedule({
    required HomeMedicineItem item,
    required DateTime date,
    required String newTime,
  }) async {
    await _runAction(() async {
      final cleanTime = newTime.length >= 5 ? newTime.substring(0, 5) : newTime;

      final rescheduledDateTime = '${_formatDate(date)} $cleanTime:00';

      await historyService.reschedule(
        scheduleTimeId: item.scheduleTimeId,
        scheduledDate: _formatDate(date),
        rescheduledTime: rescheduledDateTime,
      );

      await load(date);
    });
  }

  // =========================================================
  // MISSED
  // =========================================================

  Future<void> missed({
    required HomeMedicineItem item,
    required DateTime date,
  }) async {
    await _runAction(() async {
      await historyService.missed(
        scheduleTimeId: item.scheduleTimeId,
        scheduledDate: _formatDate(date),
      );

      await load(date);
    });
  }

  // =========================================================
  // CANCEL
  // =========================================================

  Future<void> cancel({
    required HomeMedicineItem item,
    required DateTime date,
  }) async {
    await _runAction(() async {
      await historyService.cancel(
        scheduleTimeId: item.scheduleTimeId,
        scheduledDate: _formatDate(date),
      );

      await load(date);
    });
  }

  // =========================================================
  // ACTION LOADING
  // =========================================================

  Future<void> _runAction(Future<void> Function() action) async {
    isActionLoading = true;
    errorMessage = null;

    notifyListeners();

    try {
      await action();
    } catch (e) {
      errorMessage = e.toString();
      rethrow;
    } finally {
      isActionLoading = false;
      notifyListeners();
    }
  }

  // =========================================================
  // RESCHEDULED TIME
  // =========================================================

  String? _formatRescheduledTime(dynamic value) {
    if (value == null) {
      return null;
    }

    final text = value.toString().trim();

    if (text.isEmpty) {
      return null;
    }

    // Laravel datetime:
    // 2026-08-22 14:30:00
    // 2026-08-22T14:30:00
    if (text.contains('T') || text.contains(' ')) {
      final separator = text.contains('T') ? 'T' : ' ';

      final parts = text.split(separator);

      if (parts.length >= 2) {
        final timePart = parts.last;

        if (timePart.length >= 5) {
          return timePart.substring(0, 5);
        }
      }
    }

    // HH:mm:ss / HH:mm
    if (text.length >= 5 && RegExp(r'^\d{2}:\d{2}').hasMatch(text)) {
      return text.substring(0, 5);
    }

    return text;
  }
}
