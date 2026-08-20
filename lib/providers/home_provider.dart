import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../models/medicine_model.dart';
import '../models/home_medicine_item.dart';
import '../services/medicine_service.dart';
import '../services/medicine_history_service.dart';

class HomeProvider extends ChangeNotifier {
  final MedicineService medicineService;
  final MedicineHistoryService historyService;

  HomeProvider({required this.medicineService, required this.historyService});

  bool isLoading = false;
  bool isActionLoading = false;

  List<HomeMedicineItem> medicines = [];

  String? errorMessage;

  Future<void> load(DateTime date) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final results = await Future.wait([
        _fetchHomeData(date),
        Future.delayed(const Duration(milliseconds: 600)),
      ]);

      final data = results[0] as Map<String, dynamic>;

      final medicineList = data['medicineList'] as List<MedicineModel>;

      final historyItems = data['historyItems'] as List<Map<String, dynamic>>;

      medicines = _buildHomeItems(medicineList, historyItems, date);
    } catch (e) {
      errorMessage = e.toString();
      medicines = [];
    }

    isLoading = false;
    notifyListeners();
  }

  Future<Map<String, dynamic>> _fetchHomeData(DateTime date) async {
    final medicineList = await medicineService.getMedicines();

    final dateString = _formatDate(date);

    final historyResponse = await historyService.getHistory(
      format: 'daily',
      date: dateString,
    );

    final historyItems = _extractHistory(historyResponse);

    return {'medicineList': medicineList, 'historyItems': historyItems};
  }

  List<Map<String, dynamic>> _extractHistory(Map<String, dynamic> response) {
    final data = response['data'];

    if (data is! Map) {
      return [];
    }

    final days = data['data'];

    if (days is! List) {
      return [];
    }

    final result = <Map<String, dynamic>>[];

    for (final day in days) {
      if (day is! Map) {
        continue;
      }

      final items = day['items'];

      if (items is! List) {
        continue;
      }

      for (final item in items) {
        if (item is Map) {
          result.add(Map<String, dynamic>.from(item));
        }
      }
    }

    return result;
  }

  List<HomeMedicineItem> _buildHomeItems(
    List<MedicineModel> medicineList,
    List<Map<String, dynamic>> histories,
    DateTime selectedDate,
  ) {
    final result = <HomeMedicineItem>[];

    for (final medicine in medicineList) {
      if (!_isMedicineActiveOnDate(medicine, selectedDate)) {
        continue;
      }

      for (final scheduleTime in medicine.scheduleTimes) {
        final history = histories.cast<Map<String, dynamic>?>().firstWhere(
          (item) =>
              item?['medicine_id']?.toString() == medicine.id?.toString() &&
              item?['time']?.toString() == _formatTime(scheduleTime.time),
          orElse: () => null,
        );

        String status = 'pending';

        if (history != null) {
          status = history['status']?.toString() ?? 'pending';
        } else if (_isPastToday(selectedDate, scheduleTime.time)) {
          status = 'missed';
        }

        result.add(
          HomeMedicineItem(
            medicineId: medicine.id ?? 0,
            scheduleTimeId: scheduleTime.id,
            name: medicine.name,
            dosage: _buildDosage(medicine),
            time: _formatTime(scheduleTime.time),
            instruction: medicine.instruction,
            status: status,
            takenAt: history?['taken_at']?.toString(),
            skippedAt: history?['skipped_at']?.toString(),
            notes: history?['notes']?.toString(),
            rescheduledTime: _formatRescheduledTime(
              history?['rescheduled_time'],
            ),
          ),
        );
      }
    }

    result.sort((a, b) => a.time.compareTo(b.time));

    return result;
  }

  bool _isMedicineActiveOnDate(MedicineModel medicine, DateTime date) {
    if (medicine.startDate != null) {
      final start = DateTime.tryParse(medicine.startDate!);

      if (start != null &&
          date.isBefore(DateTime(start.year, start.month, start.day))) {
        return false;
      }
    }

    if (medicine.endDate != null) {
      final end = DateTime.tryParse(medicine.endDate!);

      if (end != null && date.isAfter(DateTime(end.year, end.month, end.day))) {
        return false;
      }
    }

    switch (medicine.frequencyType) {
      case 'certain_days':
        return medicine.days.contains(date.weekday % 7);

      case 'interval_weeks':
        if (medicine.days.isEmpty) {
          return false;
        }

        return medicine.days.contains(date.weekday % 7);

      default:
        return true;
    }
  }

  bool _isPastToday(DateTime date, String time) {
    final now = DateTime.now();

    if (date.year != now.year ||
        date.month != now.month ||
        date.day != now.day) {
      return false;
    }

    final parts = time.split(':');

    if (parts.length < 2) {
      return false;
    }

    final hour = int.tryParse(parts[0]) ?? 0;

    final minute = int.tryParse(parts[1]) ?? 0;

    final scheduled = DateTime(now.year, now.month, now.day, hour, minute);

    return scheduled.isBefore(now);
  }

  String _buildDosage(MedicineModel medicine) {
    final dosage = medicine.dosage ?? '';

    final unit = medicine.dosageUnit ?? '';

    if (dosage.isEmpty && unit.isEmpty) {
      return '';
    }

    return 'Minum $dosage $unit'.trim();
  }

  String _formatTime(String time) {
    if (time.length >= 5) {
      return time.substring(0, 5);
    }

    return time;
  }

  String _formatDate(DateTime date) {
    final month = date.month.toString().padLeft(2, '0');

    final day = date.day.toString().padLeft(2, '0');

    return '${date.year}-$month-$day';
  }

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

  Future<void> reschedule({
    required HomeMedicineItem item,
    required DateTime date,
    required String newTime,
  }) async {
    await _runAction(() async {
      final rescheduledDateTime = '${_formatDate(date)} $newTime:00';

      await historyService.reschedule(
        scheduleTimeId: item.scheduleTimeId,
        scheduledDate: _formatDate(date),
        rescheduledTime: rescheduledDateTime,
      );

      await load(date);
    });
  }

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

  String? _formatRescheduledTime(dynamic value) {
    if (value == null) {
      return null;
    }

    final text = value.toString().trim();

    if (text.isEmpty) {
      return null;
    }

    if (text.contains('T') || text.contains(' ')) {
      final separator = text.contains('T') ? 'T' : ' ';

      final timePart = text.split(separator).last;

      if (timePart.length >= 5) {
        return timePart.substring(0, 5);
      }
    }

    if (text.length >= 5 && RegExp(r'^\d{2}:\d{2}').hasMatch(text)) {
      return text.substring(0, 5);
    }

    return text;
  }
}
