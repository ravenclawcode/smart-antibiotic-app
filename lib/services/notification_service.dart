import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import '../models/medicine_model.dart';

class NotificationService {
  NotificationService._();

  static final NotificationService instance = NotificationService._();

  final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();

  bool _initialized = false;

  static const String _channelId = 'medicine_reminder';
  static const String _channelName = 'Medicine Reminder';
  static const String _channelDescription = 'Notifikasi pengingat obat';

  static const int _defaultScheduleDays = 30;

  Future<void> initialize() async {
    if (_initialized) {
      return;
    }

    tz.initializeTimeZones();

    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );

    const initializationSettings = InitializationSettings(
      android: androidSettings,
    );

    await _notifications.initialize(
      settings: initializationSettings,
      onDidReceiveNotificationResponse: _onNotificationResponse,
    );

    _initialized = true;
  }

  void setTimezone(String timezoneName) {
    try {
      final location = tz.getLocation(timezoneName);
      tz.setLocalLocation(location);

      print('Notification timezone: ${tz.local.name}');
    } catch (e) {
      print('Gagal mengatur timezone "$timezoneName": $e');

      tz.setLocalLocation(tz.UTC);
    }
  }

  void _onNotificationResponse(NotificationResponse response) {}

  Future<void> requestPermission() async {
    final androidImplementation = _notifications
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();

    await androidImplementation?.requestNotificationsPermission();
  }

  AndroidNotificationDetails _androidDetails() {
    return const AndroidNotificationDetails(
      _channelId,
      _channelName,
      channelDescription: _channelDescription,
      importance: Importance.max,
      priority: Priority.high,
    );
  }

  NotificationDetails _notificationDetails() {
    return NotificationDetails(android: _androidDetails());
  }

  Future<void> showTestNotification() async {
    await _notifications.show(
      id: 999999,
      title: 'Pengingat Obat',
      body: 'Ini adalah test notification Smart Antibiotik.',
      notificationDetails: _notificationDetails(),
    );
  }

  Future<void> scheduleTestNotification() async {
    final scheduledDate = tz.TZDateTime.now(
      tz.local,
    ).add(const Duration(seconds: 10));

    await scheduleMedicineNotification(
      id: 999998,
      title: 'Pengingat Obat',
      body: 'Waktunya minum obat.',
      scheduledDate: scheduledDate,
    );
  }

  Future<void> scheduleMedicineNotification({
    required int id,
    required String title,
    required String body,
    required tz.TZDateTime scheduledDate,
  }) async {
    if (!scheduledDate.isAfter(tz.TZDateTime.now(tz.local))) {
      return;
    }

    await _notifications.zonedSchedule(
      id: id,
      title: title,
      body: body,
      scheduledDate: scheduledDate,
      notificationDetails: _notificationDetails(),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    );
  }

  Future<void> scheduleMedicineNotifications({
    required MedicineModel medicine,
    int preReminderMinutes = 30,
  }) async {
    if (medicine.id == null) {
      print(
        'scheduleMedicineNotifications dibatalkan: '
        'medicine.id null',
      );
      return;
    }

    if (!medicine.isActive) {
      print(
        'scheduleMedicineNotifications dibatalkan: '
        '${medicine.name} tidak aktif.',
      );
      return;
    }

    if (medicine.startDate == null || medicine.startDate!.trim().isEmpty) {
      print(
        'scheduleMedicineNotifications dibatalkan: '
        '${medicine.name} tidak memiliki startDate.',
      );
      return;
    }

    if (medicine.scheduleTimes.isEmpty) {
      print(
        'scheduleMedicineNotifications dibatalkan: '
        '${medicine.name} tidak memiliki scheduleTimes.',
      );
      return;
    }

    await cancelMedicineNotifications(medicine.id!);

    final startDate = _parseDate(medicine.startDate!);

    if (startDate == null) {
      print('Start date tidak valid: ${medicine.startDate}');
      return;
    }

    final parsedEndDate =
        medicine.endDate == null || medicine.endDate!.trim().isEmpty
        ? null
        : _parseDate(medicine.endDate!);

    final now = tz.TZDateTime.now(tz.local);

    final firstDate = _dateOnly(startDate.year, startDate.month, startDate.day);

    final lastDate = parsedEndDate != null
        ? _dateOnly(parsedEndDate.year, parsedEndDate.month, parsedEndDate.day)
        : firstDate.add(const Duration(days: _defaultScheduleDays));

    print('========================================');
    print('SCHEDULE MEDICINE');
    print('Medicine ID : ${medicine.id}');
    print('Medicine    : ${medicine.name}');
    print('Frequency   : ${medicine.frequencyType}');
    print('Start Date  : $firstDate');
    print('End Date    : ${parsedEndDate ?? 'NULL / 30 hari ke depan'}');
    print('Times       : ${medicine.scheduleTimes.length}');
    print('Timezone    : ${tz.local.name}');
    print('NOW         : $now');
    print('========================================');

    if (lastDate.isBefore(firstDate)) {
      print('End date lebih kecil dari start date.');
      return;
    }

    final dates = _generateDates(
      medicine: medicine,
      startDate: firstDate,
      endDate: lastDate,
    );

    int occurrenceIndex = 0;

    for (final date in dates) {
      for (final scheduleTime in medicine.scheduleTimes) {
        final parsedTime = _parseTime(scheduleTime.time);

        if (parsedTime == null) {
          print('Waktu schedule tidak valid: ${scheduleTime.time}');
          continue;
        }

        final medicineTime = tz.TZDateTime(
          tz.local,
          date.year,
          date.month,
          date.day,
          parsedTime.hour,
          parsedTime.minute,
        );

        final preReminderTime = medicineTime.subtract(
          Duration(minutes: preReminderMinutes),
        );

        final preNotificationId = _notificationId(
          medicineId: medicine.id!,
          occurrenceIndex: occurrenceIndex,
          scheduleTimeId: scheduleTime.id,
          type: 0,
        );

        final exactReminderId = _notificationId(
          medicineId: medicine.id!,
          occurrenceIndex: occurrenceIndex,
          scheduleTimeId: scheduleTime.id,
          type: 1,
        );

        print('----------------------------------------');
        print('Occurrence     : $occurrenceIndex');
        print('Date           : ${_formatDate(date)}');
        print('Schedule ID    : ${scheduleTime.id}');
        print('Medicine Time  : $medicineTime');
        print('Pre Reminder   : $preReminderTime');
        print('Pre ID         : $preNotificationId');
        print('Exact ID       : $exactReminderId');

        if (preReminderTime.isAfter(now)) {
          await scheduleMedicineNotification(
            id: preNotificationId,
            title: 'Pengingat Obat',
            body:
                '${medicine.name} akan diminum dalam '
                '$preReminderMinutes menit.',
            scheduledDate: preReminderTime,
          );
        }

        if (medicineTime.isAfter(now)) {
          await scheduleMedicineNotification(
            id: exactReminderId,
            title: 'Waktunya Minum Obat',
            body: 'Waktunya minum ${medicine.name}.',
            scheduledDate: medicineTime,
          );
        }

        occurrenceIndex++;
      }
    }

    print('========================================');
    print(
      'Selesai schedule ${medicine.name}. '
      'Occurrence: $occurrenceIndex',
    );
    print('========================================');
  }

  List<DateTime> _generateDates({
    required MedicineModel medicine,
    required DateTime startDate,
    required DateTime endDate,
  }) {
    final dates = <DateTime>[];

    var current = _dateOnly(startDate.year, startDate.month, startDate.day);

    final lastDate = _dateOnly(endDate.year, endDate.month, endDate.day);

    while (!current.isAfter(lastDate)) {
      bool shouldSchedule = false;

      switch (medicine.frequencyType) {
        case 'daily':
          shouldSchedule = true;
          break;

        case 'certain_days':
          shouldSchedule = medicine.days.contains(current.weekday);
          break;

        case 'interval_days':
          final difference = current.difference(startDate).inDays;

          final interval = medicine.intervalValue ?? 1;

          if (interval > 0) {
            shouldSchedule = difference % interval == 0;
          }

          break;

        case 'interval_weeks':
          final difference = current.difference(startDate).inDays;

          final interval = medicine.intervalValue ?? 1;

          if (interval > 0 && medicine.days.isNotEmpty) {
            final weekDifference = difference ~/ 7;

            shouldSchedule =
                weekDifference % interval == 0 &&
                medicine.days.contains(current.weekday);
          }

          break;

        case 'interval_months':
          final interval = medicine.intervalValue ?? 1;

          final monthDifference =
              (current.year - startDate.year) * 12 +
              current.month -
              startDate.month;

          if (interval > 0 && medicine.dates.isNotEmpty) {
            shouldSchedule =
                monthDifference % interval == 0 &&
                medicine.dates.contains(current.day);
          }

          break;

        default:
          print(
            'Frequency type tidak dikenal: '
            '${medicine.frequencyType}',
          );
      }

      if (shouldSchedule) {
        dates.add(current);
      }

      current = current.add(const Duration(days: 1));
    }

    return dates;
  }

  DateTime? _parseDate(String value) {
    try {
      final parsed = DateTime.tryParse(value);

      if (parsed == null) {
        return null;
      }

      return DateTime(parsed.year, parsed.month, parsed.day);
    } catch (_) {
      return null;
    }
  }

  DateTime? _parseTime(String value) {
    try {
      final cleanValue = value.trim();

      final parts = cleanValue.split(':');

      if (parts.length < 2) {
        return null;
      }

      final hour = int.tryParse(parts[0]);
      final minute = int.tryParse(parts[1]);

      if (hour == null || minute == null) {
        return null;
      }

      if (hour < 0 || hour > 23) {
        return null;
      }

      if (minute < 0 || minute > 59) {
        return null;
      }

      return DateTime(2000, 1, 1, hour, minute);
    } catch (_) {
      return null;
    }
  }

  DateTime _dateOnly(int year, int month, int day) {
    return DateTime(year, month, day);
  }

  String _formatDate(DateTime date) {
    return '${date.year.toString().padLeft(4, '0')}-'
        '${date.month.toString().padLeft(2, '0')}-'
        '${date.day.toString().padLeft(2, '0')}';
  }

  int _notificationId({
    required int medicineId,
    required int occurrenceIndex,
    required int scheduleTimeId,
    required int type,
  }) {
    return (medicineId * 1000000) +
        (scheduleTimeId * 1000) +
        (occurrenceIndex * 2) +
        type;
  }

  Future<void> cancelMedicineNotifications(int medicineId) async {
    final pending = await _notifications.pendingNotificationRequests();

    for (final notification in pending) {
      final notificationMedicineId = notification.id ~/ 1000000;

      if (notificationMedicineId == medicineId) {
        print(
          'CANCEL NOTIFICATION: '
          '${notification.id} '
          'medicine=$medicineId',
        );

        await _notifications.cancel(id: notification.id);
      }
    }
  }

  Future<void> cancel(int notificationId) async {
    await _notifications.cancel(id: notificationId);
  }

  Future<void> cancelMedicineDose({
    required int medicineId,
    required int scheduleTimeId,
    required int occurrenceIndex,
  }) async {
    final preNotificationId = _notificationId(
      medicineId: medicineId,
      scheduleTimeId: scheduleTimeId,
      occurrenceIndex: occurrenceIndex,
      type: 0,
    );

    final exactReminderId = _notificationId(
      medicineId: medicineId,
      scheduleTimeId: scheduleTimeId,
      occurrenceIndex: occurrenceIndex,
      type: 1,
    );

    await cancel(preNotificationId);
    await cancel(exactReminderId);

    print(
      'CANCEL SINGLE DOSE: '
      'medicine=$medicineId '
      'schedule=$scheduleTimeId '
      'occurrence=$occurrenceIndex',
    );
  }

  Future<void> cancelMedicineDoseByDate({
    required MedicineModel medicine,
    required int scheduleTimeId,
    required DateTime scheduledDate,
  }) async {
    if (medicine.id == null) {
      return;
    }

    final targetDate = _dateOnly(
      scheduledDate.year,
      scheduledDate.month,
      scheduledDate.day,
    );

    final occurrenceIndex = _getOccurrenceIndexByDate(
      medicine: medicine,
      targetDate: targetDate,
    );

    if (occurrenceIndex == null) {
      print(
        'CANCEL DOSE: occurrence tidak ditemukan. '
        'medicine=${medicine.id} '
        'date=$targetDate',
      );
      return;
    }

    await cancelMedicineDose(
      medicineId: medicine.id!,
      scheduleTimeId: scheduleTimeId,
      occurrenceIndex: occurrenceIndex,
    );

    print(
      'CANCEL DOSE BY DATE: '
      'medicine=${medicine.id} '
      'schedule=$scheduleTimeId '
      'date=$targetDate '
      'occurrence=$occurrenceIndex',
    );
  }

  Future<void> scheduleMedicineDose({
    required MedicineModel medicine,
    required int scheduleTimeId,
    required DateTime scheduledDate,
    required String time,
    int preReminderMinutes = 30,
  }) async {
    if (medicine.id == null) {
      return;
    }

    if (!medicine.isActive) {
      return;
    }

    final parsedTime = _parseTime(time);

    if (parsedTime == null) {
      print('Waktu reschedule tidak valid: $time');
      return;
    }

    final targetDate = _dateOnly(
      scheduledDate.year,
      scheduledDate.month,
      scheduledDate.day,
    );

    final occurrenceIndex = _getOccurrenceIndexByDate(
      medicine: medicine,
      targetDate: targetDate,
    );

    if (occurrenceIndex == null) {
      print(
        'Tidak menemukan occurrence untuk '
        '$targetDate',
      );
      return;
    }

    final medicineTime = tz.TZDateTime(
      tz.local,
      targetDate.year,
      targetDate.month,
      targetDate.day,
      parsedTime.hour,
      parsedTime.minute,
    );

    final preReminderTime = medicineTime.subtract(
      Duration(minutes: preReminderMinutes),
    );

    final preNotificationId = _notificationId(
      medicineId: medicine.id!,
      occurrenceIndex: occurrenceIndex,
      scheduleTimeId: scheduleTimeId,
      type: 0,
    );

    final exactReminderId = _notificationId(
      medicineId: medicine.id!,
      occurrenceIndex: occurrenceIndex,
      scheduleTimeId: scheduleTimeId,
      type: 1,
    );

    final now = tz.TZDateTime.now(tz.local);

    print('========================================');
    print('RESCHEDULE NOTIFICATION');
    print('Medicine ID : ${medicine.id}');
    print('Schedule ID : $scheduleTimeId');
    print('Date        : $targetDate');
    print('New Time    : $time');
    print('Occurrence  : $occurrenceIndex');
    print('Pre Time    : $preReminderTime');
    print('Exact Time  : $medicineTime');
    print('========================================');

    if (preReminderTime.isAfter(now)) {
      await scheduleMedicineNotification(
        id: preNotificationId,
        title: 'Pengingat Obat',
        body:
            '${medicine.name} akan diminum dalam '
            '$preReminderMinutes menit.',
        scheduledDate: preReminderTime,
      );
    }

    if (medicineTime.isAfter(now)) {
      await scheduleMedicineNotification(
        id: exactReminderId,
        title: 'Waktunya Minum Obat',
        body: 'Waktunya minum ${medicine.name}.',
        scheduledDate: medicineTime,
      );
    }

    print(
      'SCHEDULE SINGLE DOSE: '
      'medicine=${medicine.id} '
      'schedule=$scheduleTimeId '
      'date=$targetDate '
      'time=$time '
      'occurrence=$occurrenceIndex',
    );
  }

  Future<void> debugPendingNotifications() async {
    final pending = await _notifications.pendingNotificationRequests();

    print('');
    print('========================================');
    print('PENDING NOTIFICATIONS');
    print('Jumlah: ${pending.length}');
    print('========================================');

    for (final notification in pending) {
      print(
        'ID=${notification.id} | '
        'TITLE=${notification.title} | '
        'BODY=${notification.body}',
      );
    }

    print('========================================');
    print('');
  }

  Future<void> cancelAll() async {
    await _notifications.cancelAll();
  }

  int? _getOccurrenceIndexByDate({
    required MedicineModel medicine,
    required DateTime targetDate,
  }) {
    final startDate = _parseDate(medicine.startDate ?? '');

    if (startDate == null) {
      return null;
    }

    final firstDate = _dateOnly(startDate.year, startDate.month, startDate.day);

    final dates = _generateDates(
      medicine: medicine,
      startDate: firstDate,
      endDate: targetDate,
    );

    final index = dates.indexWhere(
      (date) =>
          date.year == targetDate.year &&
          date.month == targetDate.month &&
          date.day == targetDate.day,
    );

    if (index == -1) {
      return null;
    }

    return index;
  }
}
