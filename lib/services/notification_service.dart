import 'dart:convert';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import '../models/medicine_model.dart';
import '../models/medicine_schedule_time_model.dart';
import '../routes/routes.dart';
import 'local_storage_service.dart';

class NotificationService {
  NotificationService._();

  static final NotificationService instance = NotificationService._();

  final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();

  bool _initialized = false;

  String? _pendingPayload;

  static const int _defaultScheduleDays = 30;

  static const String _reminderTypeFullScreen = 'Layar Penuh';
  static const String _reminderTypeCompact = 'Ringkas';

  static const String _channelName = 'Medicine Reminder';
  static const String _channelDescription = 'Notifikasi pengingat obat';

  static const Map<String, String> _soundResources = {
    'Nada Standar': 'y_que_fue',
    'Melodi Lembut': 'cartel',
    'Suara Alam': 'barudak_phonk',
  };

  static const String _defaultSoundResource = 'y_que_fue';

  LocalStorageService? _localStorage;

  void setLocalStorage(LocalStorageService localStorage) {
    _localStorage = localStorage;
  }

  // ============================================================
  // INITIALIZATION
  // ============================================================

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

    final androidImplementation = _notifications
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();

    await androidImplementation?.requestNotificationsPermission();

    await androidImplementation?.requestFullScreenIntentPermission();

    final launchDetails = await _notifications
        .getNotificationAppLaunchDetails();

    if (launchDetails?.didNotificationLaunchApp ?? false) {
      final response = launchDetails?.notificationResponse;
      final payload = response?.payload;

      print('===== APP LAUNCHED BY NOTIFICATION =====');
      print('didNotificationLaunchApp = true');
      print('payload = $payload');
      print('========================================');

      if (payload != null && payload.isNotEmpty) {
        _pendingPayload = payload;
      }
    }

    _initialized = true;
  }

  // ============================================================
  // TIMEZONE
  // ============================================================

  void setTimezone(String timezoneName) {
    try {
      final location = tz.getLocation(timezoneName);
      tz.setLocalLocation(location);

      print('Notification timezone: $timezoneName');
    } catch (e) {
      tz.setLocalLocation(tz.UTC);

      print('Invalid timezone: $timezoneName');
      print('Fallback timezone: UTC');
    }
  }

  // ============================================================
  // NOTIFICATION RESPONSE
  // ============================================================
  void _onNotificationResponse(NotificationResponse response) {
    final payload = response.payload;

    print('===== NOTIFICATION RESPONSE =====');
    print('payload = $payload');
    print('=================================');

    if (payload == null || payload.isEmpty) {
      return;
    }

    _pendingPayload = payload;

    _openReminderFromPayload(payload);
  }

  // ============================================================
  // OPEN REMINDER
  // ============================================================

  void _openReminderFromPayload(String payload) {
    try {
      final decoded = jsonDecode(payload);

      if (decoded is! Map<String, dynamic>) {
        print('Invalid notification payload.');
        return;
      }

      if (decoded['type'] != 'medicine_reminder') {
        print('Unknown notification type.');
        return;
      }

      final navigator = navigatorKey.currentState;

      if (navigator == null) {
        print('Navigator belum siap. Retry...');

        Future.delayed(const Duration(milliseconds: 500), () {
          _openReminderFromPayload(payload);
        });

        return;
      }

      print('===== OPEN CUSTOM REMINDER =====');
      print(decoded);
      print('================================');

      navigator.pushNamed(Routes.reminder, arguments: decoded);
    } catch (e) {
      print('Failed to open reminder: $e');
    }
  }

  // ============================================================
  // HANDLE PENDING NOTIFICATION
  // ============================================================

  void handlePendingNotification() {
    final payload = consumePendingPayload();

    if (payload == null || payload.isEmpty) {
      print('===== NO PENDING NOTIFICATION =====');
      return;
    }

    print('===== HANDLE PENDING REMINDER =====');
    print('payload = $payload');
    print('===================================');

    Future.delayed(const Duration(milliseconds: 800), () {
      _openReminderFromPayload(payload);
    });
  }

  String? consumePendingPayload() {
    final payload = _pendingPayload;
    _pendingPayload = null;
    return payload;
  }

  // ============================================================
  // PERMISSION
  // ============================================================

  Future<void> requestPermission() async {
    final androidImplementation = _notifications
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();

    await androidImplementation?.requestNotificationsPermission();
  }

  Future<void> checkFullScreenPermission() async {
    final androidImplementation = _notifications
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();

    final result = await androidImplementation
        ?.requestFullScreenIntentPermission();

    print('Full screen permission: $result');
  }

  // ============================================================
  // SOUND
  // ============================================================

  String _getSoundResourceName() {
    final savedSound = _localStorage?.getReminderSound();

    if (savedSound == null || savedSound.trim().isEmpty) {
      return _defaultSoundResource;
    }

    return _soundResources[savedSound] ?? _defaultSoundResource;
  }

  String _getChannelId(String soundResource) {
    return 'medicine_reminder_$soundResource';
  }

  String _getChannelName(String soundResource) {
    switch (soundResource) {
      case 'y_que_fue':
        return 'Medicine Reminder - Nada Standar';

      case 'cartel':
        return 'Medicine Reminder - Melodi Lembut';

      case 'barudak_phonk':
        return 'Medicine Reminder - Suara Alam';

      default:
        return _channelName;
    }
  }

  // ============================================================
  // TEST NOTIFICATION
  // ============================================================

  Future<void> showTestNotification() async {
    await _notifications.show(
      id: 999999,
      title: 'Pengingat Obat',
      body: 'Ini adalah test notification Smart Antibiotik.',
      notificationDetails: _compactNotificationDetails(),
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
      notificationDetails: _compactNotificationDetails(),
    );
  }

  // ============================================================
  // GENERIC SCHEDULE
  // ============================================================

  Future<void> scheduleMedicineNotification({
    required int id,
    required String title,
    required String body,
    required tz.TZDateTime scheduledDate,
    required NotificationDetails notificationDetails,
    String? payload,
  }) async {
    final now = tz.TZDateTime.now(tz.local);

    if (!scheduledDate.isAfter(now)) {
      print('NOTIFICATION SKIPPED: waktu sudah lewat');
      return;
    }

    print('===== ZONED SCHEDULE DEBUG =====');
    print('id = $id');
    print('title = $title');
    print('scheduledDate = $scheduledDate');
    print('now = $now');
    print('isAfter = ${scheduledDate.isAfter(now)}');
    print('================================');

    await _notifications.zonedSchedule(
      id: id,
      title: title,
      body: body,
      scheduledDate: scheduledDate,
      notificationDetails: notificationDetails,
      payload: payload,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    );

    print('NOTIFICATION SCHEDULED SUCCESS: $id');
  }

  // ============================================================
  // SCHEDULE MEDICINE
  // ============================================================

  Future<void> scheduleMedicineNotifications({
    required MedicineModel medicine,
    int preReminderMinutes = 30,
  }) async {
    print('===== SCHEDULE MEDICINE DEBUG =====');
    print('medicine.id = ${medicine.id}');
    print('medicine.name = ${medicine.name}');
    print('medicine.isActive = ${medicine.isActive}');
    print('medicine.startDate = ${medicine.startDate}');
    print('medicine.endDate = ${medicine.endDate}');
    print('medicine.frequencyType = ${medicine.frequencyType}');
    print('scheduleTimes = ${medicine.scheduleTimes.length}');
    print('===================================');

    if (medicine.id == null) {
      return;
    }

    if (!medicine.isActive) {
      return;
    }

    if (medicine.startDate == null || medicine.startDate!.trim().isEmpty) {
      return;
    }

    if (medicine.scheduleTimes.isEmpty) {
      return;
    }

    await cancelMedicineNotifications(medicine.id!);

    final startDate = _parseDate(medicine.startDate!);

    if (startDate == null) {
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

    if (lastDate.isBefore(firstDate)) {
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

        // --------------------------------------------------------
        // 30 MENIT SEBELUMNYA
        // --------------------------------------------------------

        if (preReminderTime.isAfter(now)) {
          await scheduleMedicineNotification(
            id: preNotificationId,
            title: 'Pengingat Obat',
            body:
                '${medicine.name} akan diminum dalam '
                '$preReminderMinutes menit.',
            scheduledDate: preReminderTime,
            notificationDetails: _preReminderDetails(),
          );
        }

        // --------------------------------------------------------
        // WAKTU MINUM OBAT
        // --------------------------------------------------------

        if (medicineTime.isAfter(now)) {
          final reminderType = _getReminderType();

          print('===== NOTIFICATION TYPE DEBUG =====');
          print('reminderType = $reminderType');
          print('medicineTime = $medicineTime');
          print('now = $now');
          print('===================================');

          final payload = _buildMedicinePayload(
            medicine: medicine,
            scheduleTime: scheduleTime,
            scheduledTime: scheduleTime.time,
            scheduledDate: medicineTime,
          );

          if (reminderType == _reminderTypeFullScreen) {
            print('MODE: FULL SCREEN');

            await scheduleMedicineNotification(
              id: exactReminderId,
              title: 'Waktunya Minum Obat',
              body: 'Waktunya minum ${medicine.name}.',
              scheduledDate: medicineTime,
              notificationDetails: _fullScreenNotificationDetails(),
              payload: payload,
            );
          } else {
            print('MODE: COMPACT');

            await scheduleMedicineNotification(
              id: exactReminderId,
              title: 'Waktunya Minum Obat',
              body: 'Waktunya minum ${medicine.name}.',
              scheduledDate: medicineTime,
              notificationDetails: _compactNotificationDetails(),
              payload: payload,
            );
          }
        }

        occurrenceIndex++;
      }
    }
  }

  // ============================================================
  // GENERATE DATES
  // ============================================================

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
      }

      if (shouldSchedule) {
        dates.add(current);
      }

      current = current.add(const Duration(days: 1));
    }

    return dates;
  }

  // ============================================================
  // DATE / TIME
  // ============================================================

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

  // ============================================================
  // NOTIFICATION ID
  // ============================================================

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

  // ============================================================
  // CANCEL
  // ============================================================

  Future<void> cancelMedicineNotifications(int medicineId) async {
    final pending = await _notifications.pendingNotificationRequests();

    for (final notification in pending) {
      final notificationMedicineId = notification.id ~/ 1000000;

      if (notificationMedicineId == medicineId) {
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
      return;
    }

    await cancelMedicineDose(
      medicineId: medicine.id!,
      scheduleTimeId: scheduleTimeId,
      occurrenceIndex: occurrenceIndex,
    );
  }

  // ============================================================
  // SINGLE DOSE
  // ============================================================

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

    if (preReminderTime.isAfter(now)) {
      await scheduleMedicineNotification(
        id: preNotificationId,
        title: 'Pengingat Obat',
        body:
            '${medicine.name} akan diminum dalam '
            '$preReminderMinutes menit.',
        scheduledDate: preReminderTime,
        notificationDetails: _preReminderDetails(),
      );
    }

    if (medicineTime.isAfter(now)) {
      final reminderType = _getReminderType();

      final scheduleTime = medicine.scheduleTimes.firstWhere(
        (item) => item.id == scheduleTimeId,
        orElse: () => MedicineScheduleTimeModel(id: scheduleTimeId, time: time),
      );

      final payload = _buildMedicinePayload(
        medicine: medicine,
        scheduleTime: scheduleTime,
        scheduledTime: time,
        scheduledDate: medicineTime,
      );

      if (reminderType == _reminderTypeFullScreen) {
        await scheduleMedicineNotification(
          id: exactReminderId,
          title: 'Waktunya Minum Obat',
          body: 'Waktunya minum ${medicine.name}.',
          scheduledDate: medicineTime,
          notificationDetails: _fullScreenNotificationDetails(),
          payload: payload,
        );
      } else {
        await scheduleMedicineNotification(
          id: exactReminderId,
          title: 'Waktunya Minum Obat',
          body: 'Waktunya minum ${medicine.name}.',
          scheduledDate: medicineTime,
          notificationDetails: _compactNotificationDetails(),
          payload: payload,
        );
      }
    }
  }

  // ============================================================
  // OCCURRENCE INDEX
  // ============================================================

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

  // ============================================================
  // REMINDER TYPE
  // ============================================================

  String _getReminderType() {
    final savedType = _localStorage?.getReminderType();

    print('===== REMINDER TYPE DEBUG =====');
    print('savedType = $savedType');
    print(
      'localStorage initialized = '
      '${_localStorage != null}',
    );
    print('================================');

    if (savedType == _reminderTypeFullScreen) {
      return _reminderTypeFullScreen;
    }

    return _reminderTypeCompact;
  }

  // ============================================================
  // PRE REMINDER
  // ============================================================

  AndroidNotificationDetails _preReminderAndroidDetails() {
    return const AndroidNotificationDetails(
      'medicine_pre_reminder',
      'Pengingat 30 Menit',
      channelDescription: 'Pengingat obat 30 menit sebelum jadwal',
      importance: Importance.high,
      priority: Priority.high,
      playSound: false,
    );
  }

  NotificationDetails _preReminderDetails() {
    return NotificationDetails(android: _preReminderAndroidDetails());
  }

  // ============================================================
  // COMPACT
  // ============================================================

  AndroidNotificationDetails _compactAndroidDetails() {
    final soundResource = _getSoundResourceName();

    return AndroidNotificationDetails(
      _getChannelId(soundResource),
      _getChannelName(soundResource),
      channelDescription: _channelDescription,
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
      sound: RawResourceAndroidNotificationSound(soundResource),
      category: AndroidNotificationCategory.alarm,
      actions: const [
        AndroidNotificationAction('TAKEN', 'Minum'),
        AndroidNotificationAction('SKIPPED', 'Lewati'),
      ],
    );
  }

  NotificationDetails _compactNotificationDetails() {
    return NotificationDetails(android: _compactAndroidDetails());
  }

  // ============================================================
  // FULL SCREEN
  // ============================================================

  AndroidNotificationDetails _fullScreenAndroidDetails() {
    final soundResource = _getSoundResourceName();

    return AndroidNotificationDetails(
      _getChannelId(soundResource),
      _getChannelName(soundResource),
      channelDescription: _channelDescription,

      importance: Importance.max,
      priority: Priority.high,

      playSound: true,

      sound: RawResourceAndroidNotificationSound(soundResource),

      // ========================================================
      // INI YANG MEMBUAT ANDROID MEMBUKA ACTIVITY SECARA
      // FULL SCREEN PADA SAAT WAKTUNYA TIBA.
      // ========================================================
      fullScreenIntent: true,

      category: AndroidNotificationCategory.alarm,

      visibility: NotificationVisibility.public,
    );
  }

  NotificationDetails _fullScreenNotificationDetails() {
    return NotificationDetails(android: _fullScreenAndroidDetails());
  }

  // ============================================================
  // PAYLOAD
  // ============================================================

  String _buildMedicinePayload({
    required MedicineModel medicine,
    required MedicineScheduleTimeModel scheduleTime,
    required String scheduledTime,
    required DateTime scheduledDate,
  }) {
    return jsonEncode({
      'type': 'medicine_reminder',

      'medicine_id': medicine.id,

      'name': medicine.name,

      'dosage': medicine.dosage,

      'dosage_unit': medicine.dosageUnit,

      'instruction': medicine.instruction,

      'schedule_time_id': scheduleTime.id,

      'scheduled_time': scheduledTime,

      'scheduled_date': scheduledDate.toIso8601String(),
    });
  }

  // ============================================================
  // CANCEL ALL
  // ============================================================

  Future<void> cancelAll() async {
    await _notifications.cancelAll();
  }
}
