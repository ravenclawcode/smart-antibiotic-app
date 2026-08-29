import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:smart_antibiotic/services/medicine_history_service.dart';
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

  int? _activeNotificationId;

  String? _pendingPayload;
  String? _pendingActionId;
  String? _pendingActionPayload;

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

  MedicineHistoryService? _medicineHistoryService;

  void setLocalStorage(LocalStorageService localStorage) {
    _localStorage = localStorage;
  }

  void setMedicineHistoryService(MedicineHistoryService service) {
    _medicineHistoryService = service;

    final actionId = _pendingActionId;
    final payload = _pendingActionPayload;

    if (actionId == null || payload == null) {
      return;
    }

    _pendingActionId = null;
    _pendingActionPayload = null;

    if (actionId == 'TAKEN') {
      _handleNotificationTaken(payload);
    } else if (actionId == 'SKIPPED') {
      _handleNotificationSkipped(payload);
    }
  }

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
      onDidReceiveBackgroundNotificationResponse: notificationTapBackground,
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

      if (response != null) {
        final notificationId = response.id;

        if (notificationId != null) {
          _activeNotificationId = notificationId;
        }

        final payload = response.payload;

        if (payload != null && payload.isNotEmpty) {
          try {
            final decoded = jsonDecode(payload);

            if (decoded is Map<String, dynamic> &&
                decoded['type'] == 'medicine_reminder') {
              if (response.actionId == 'TAKEN') {
                if (response.id != null) {
                  await _notifications.cancel(id: response.id!);
                }

                _activeNotificationId = null;

                _pendingPayload = payload;
                _pendingActionId = 'TAKEN';
                _pendingActionPayload = payload;
              } else if (response.actionId == 'SKIPPED') {
                if (response.id != null) {
                  await _notifications.cancel(id: response.id!);
                }

                _activeNotificationId = null;

                _pendingPayload = payload;
                _pendingActionId = 'SKIPPED';
                _pendingActionPayload = payload;
              } else {
                _pendingPayload = payload;
              }
            }
          } catch (_) {}
        }
      }
    }

    _initialized = true;
  }

  void setTimezone(String timezoneName) {
    try {
      final location = tz.getLocation(timezoneName);
      tz.setLocalLocation(location);
    } catch (_) {
      tz.setLocalLocation(tz.UTC);
    }
  }

  Future<void> _onNotificationResponse(NotificationResponse response) async {
    final notificationId = response.id;

    if (notificationId != null) {
      _activeNotificationId = notificationId;
    }

    final payload = response.payload;

    if (payload == null || payload.isEmpty) {
      return;
    }

    try {
      final decoded = jsonDecode(payload);

      if (decoded is! Map<String, dynamic> ||
          decoded['type'] != 'medicine_reminder') {
        return;
      }

      final reminderType = decoded['reminder_type'];

      if (response.actionId == 'TAKEN') {
        if (reminderType == _reminderTypeCompact) {
          await _handleCompactAction(
            actionId: 'TAKEN',
            payload: payload,
            notificationId: notificationId,
          );
          return;
        }

        if (notificationId != null) {
          await _notifications.cancel(id: notificationId);
        }

        _activeNotificationId = null;

        await _handleNotificationTaken(payload);
        return;
      }

      if (response.actionId == 'SKIPPED') {
        if (reminderType == _reminderTypeCompact) {
          await _handleCompactAction(
            actionId: 'SKIPPED',
            payload: payload,
            notificationId: notificationId,
          );
          return;
        }

        if (notificationId != null) {
          await _notifications.cancel(id: notificationId);
        }

        _activeNotificationId = null;

        await _handleNotificationSkipped(payload);
        return;
      }

      if (reminderType == _reminderTypeCompact) {
        await _cancelActiveNotification();
        _openMainApp();
        return;
      }

      // HANYA LAYAR PENUH YANG BOLEH KE CUSTOM REMINDER
      await _cancelActiveNotification();

      _pendingPayload = payload;

      _openReminderFromPayload(payload);
    } catch (_) {}
  }

  void _openMainApp() {
    final navigator = navigatorKey.currentState;

    if (navigator == null) {
      return;
    }

    navigator.pushNamedAndRemoveUntil(Routes.main, (route) => false);
  }

  Future<void> _cancelActiveNotification() async {
    final notificationId = _activeNotificationId;

    if (notificationId == null) {
      return;
    }

    await _notifications.cancel(id: notificationId);

    _activeNotificationId = null;
  }

  void _openReminderFromPayload(
    String payload, {
    bool replaceCurrentRoute = false,
  }) {
    try {
      final decoded = jsonDecode(payload);

      if (decoded is! Map<String, dynamic>) {
        return;
      }

      if (decoded['type'] != 'medicine_reminder') {
        return;
      }

      final navigator = navigatorKey.currentState;

      if (navigator == null) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _openReminderFromPayload(
            payload,
            replaceCurrentRoute: replaceCurrentRoute,
          );
        });

        return;
      }

      if (replaceCurrentRoute) {
        navigator.pushReplacementNamed(Routes.reminder, arguments: decoded);
      } else {
        navigator.pushNamed(Routes.reminder, arguments: decoded);
      }
    } catch (_) {}
  }

  Future<void> handlePendingNotification() async {
    final payload = consumePendingPayload();

    if (payload == null || payload.isEmpty) {
      return;
    }

    await _cancelActiveNotification();

    _openReminderFromPayload(payload, replaceCurrentRoute: true);
  }

  Future<void> openPendingNotification() async {
    final payload = consumePendingPayload();

    if (payload == null || payload.isEmpty) {
      return;
    }

    await _cancelActiveNotification();

    _openReminderFromPayload(payload, replaceCurrentRoute: true);
  }

  String? consumePendingPayload() {
    final payload = _pendingPayload;
    _pendingPayload = null;
    return payload;
  }

  String? consumePendingAction() {
    final actionId = _pendingActionId;
    _pendingActionId = null;
    return actionId;
  }

  bool hasPendingNotification() {
    return _pendingPayload != null && _pendingPayload!.isNotEmpty;
  }

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

    await androidImplementation?.requestFullScreenIntentPermission();
  }

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
      return;
    }

    await _notifications.zonedSchedule(
      id: id,
      title: title,
      body: body,
      scheduledDate: scheduledDate,
      notificationDetails: notificationDetails,
      payload: payload,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    );
  }

  Future<void> scheduleMedicineNotifications({
    required MedicineModel medicine,
    int preReminderMinutes = 30,
  }) async {
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

        if (preReminderTime.isAfter(now)) {
          await scheduleMedicineNotification(
            id: preNotificationId,
            title: 'Pengingat Minum Obat',
            body:
                '${medicine.name} akan diminum dalam '
                '$preReminderMinutes menit.',
            scheduledDate: preReminderTime,
            notificationDetails: _preReminderDetails(),
          );
        }

        if (medicineTime.isAfter(now)) {
          final reminderType = _getReminderType();

          final payload = _buildMedicinePayload(
            medicine: medicine,
            scheduleTime: scheduleTime,
            scheduledTime: scheduleTime.time,
            scheduledDate: medicineTime,
          );

          if (reminderType == _reminderTypeFullScreen) {
            await scheduleMedicineNotification(
              id: exactReminderId,
              title: 'Waktunya Minum Obat',
              body:
                  'Saatnya minum ${medicine.name} '
                  '${medicine.dosage} ${medicine.dosageUnit}.',
              scheduledDate: medicineTime,
              notificationDetails: _fullScreenNotificationDetails(),
              payload: payload,
            );
          } else {
            await scheduleMedicineNotification(
              id: exactReminderId,
              title: 'Waktunya Minum Obat',
              body:
                  'Saatnya minum ${medicine.name} '
                  '${medicine.dosage} ${medicine.dosageUnit}.',
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
        title: 'Pengingat Minum Obat',
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

      final notificationDetails = reminderType == _reminderTypeFullScreen
          ? _fullScreenNotificationDetails()
          : _compactNotificationDetails();

      await scheduleMedicineNotification(
        id: exactReminderId,
        title: 'Waktunya Minum Obat',
        body:
            'Saatnya minum ${medicine.name} '
            '${medicine.dosage} ${medicine.dosageUnit}.',
        scheduledDate: medicineTime,
        notificationDetails: notificationDetails,
        payload: payload,
      );
    }
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

  String _getReminderType() {
    final savedType = _localStorage?.getReminderType();

    if (savedType == _reminderTypeFullScreen) {
      return _reminderTypeFullScreen;
    }

    return _reminderTypeCompact;
  }

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
        AndroidNotificationAction('TAKEN', 'Minum', showsUserInterface: true),
        AndroidNotificationAction(
          'SKIPPED',
          'Lewati',
          showsUserInterface: true,
        ),
      ],
    );
  }

  NotificationDetails _compactNotificationDetails() {
    return NotificationDetails(android: _compactAndroidDetails());
  }

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
      fullScreenIntent: true,
      autoCancel: true,
      category: AndroidNotificationCategory.alarm,
      visibility: NotificationVisibility.public,
    );
  }

  NotificationDetails _fullScreenNotificationDetails() {
    return NotificationDetails(android: _fullScreenAndroidDetails());
  }

  String _buildMedicinePayload({
    required MedicineModel medicine,
    required MedicineScheduleTimeModel scheduleTime,
    required String scheduledTime,
    required DateTime scheduledDate,
  }) {
    return jsonEncode({
      'type': 'medicine_reminder',
      'reminder_type': _getReminderType(),
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

  Future<void> cancelAll() async {
    await _notifications.cancelAll();
    _activeNotificationId = null;
  }

  Future<void> _handleNotificationTaken(String payload) async {
    try {
      final decoded = jsonDecode(payload);

      if (decoded is! Map<String, dynamic>) {
        return;
      }

      if (decoded['type'] != 'medicine_reminder') {
        return;
      }

      final scheduleTimeId = decoded['schedule_time_id'];

      final scheduledDate = decoded['scheduled_date']?.toString();

      if (scheduleTimeId is! int ||
          scheduledDate == null ||
          scheduledDate.isEmpty) {
        return;
      }

      await _medicineHistoryService?.taken(
        scheduleTimeId: scheduleTimeId,
        scheduledDate: scheduledDate,
        actionTime: 'now',
      );
    } catch (_) {}
  }

  Future<void> _handleNotificationSkipped(String payload) async {
    try {
      final decoded = jsonDecode(payload);

      if (decoded is! Map<String, dynamic>) {
        return;
      }

      if (decoded['type'] != 'medicine_reminder') {
        return;
      }

      final scheduleTimeId = decoded['schedule_time_id'];

      final scheduledDate = decoded['scheduled_date']?.toString();

      if (scheduleTimeId is! int ||
          scheduledDate == null ||
          scheduledDate.isEmpty) {
        return;
      }

      await _medicineHistoryService?.skipped(
        scheduleTimeId: scheduleTimeId,
        scheduledDate: scheduledDate,
        actionTime: 'now',
        notes: 'Lainnya',
      );
    } catch (_) {}
  }

  Future<void> scheduleRescheduledReminder({
    required int medicineId,
    required int scheduleTimeId,
    required String medicineName,
    required String dosage,
    required String dosageUnit,
    required String instruction,
    required DateTime scheduledDateTime,
  }) async {
    final now = tz.TZDateTime.now(tz.local);

    final scheduledDate = tz.TZDateTime(
      tz.local,
      scheduledDateTime.year,
      scheduledDateTime.month,
      scheduledDateTime.day,
      scheduledDateTime.hour,
      scheduledDateTime.minute,
    );

    if (!scheduledDate.isAfter(now)) {
      return;
    }

    final reminderType = _getReminderType();

    final payload = jsonEncode({
      'type': 'medicine_reminder',
      'reminder_type': reminderType,
      'medicine_id': medicineId,
      'name': medicineName,
      'dosage': dosage,
      'dosage_unit': dosageUnit,
      'instruction': instruction,
      'schedule_time_id': scheduleTimeId,
      'scheduled_time':
          '${scheduledDate.hour.toString().padLeft(2, '0')}:'
          '${scheduledDate.minute.toString().padLeft(2, '0')}:00',
      'scheduled_date': scheduledDate.toIso8601String(),
    });

    final notificationId =
        medicineId * 1000000 +
        scheduleTimeId * 1000 +
        (scheduledDate.millisecondsSinceEpoch % 1000);

    final notificationDetails = reminderType == _reminderTypeFullScreen
        ? _fullScreenNotificationDetails()
        : _compactNotificationDetails();

    await scheduleMedicineNotification(
      id: notificationId,
      title: 'Waktunya Minum Obat',
      body: 'Saatnya minum $medicineName $dosage $dosageUnit.',
      scheduledDate: scheduledDate,
      notificationDetails: notificationDetails,
      payload: payload,
    );
  }

  Future<void> stopMedicineAlarm() async {
    await _notifications.cancelAll();
    _activeNotificationId = null;
  }

  Future<void> stopActiveMedicineAlarm() async {
    final notificationId = _activeNotificationId;

    if (notificationId == null) {
      return;
    }

    await _notifications.cancel(id: notificationId);

    _activeNotificationId = null;
  }

  Future<void> _handleCompactAction({
    required String actionId,
    required String payload,
    required int? notificationId,
  }) async {
    if (notificationId != null) {
      await _notifications.cancel(id: notificationId);
    }

    _activeNotificationId = null;

    if (actionId == 'TAKEN') {
      await _handleNotificationTaken(payload);
    } else if (actionId == 'SKIPPED') {
      await _handleNotificationSkipped(payload);
    }

    _openMainApp();
  }
}

@pragma('vm:entry-point')
void notificationTapBackground(NotificationResponse response) {}
