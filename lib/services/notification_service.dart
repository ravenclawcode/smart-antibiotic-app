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

  final List<String> _pendingPayloads = [];
  String? _pendingActionId;
  String? _pendingActionPayload;

  static const int _defaultScheduleDays = 30;
  static const int _maxScheduleDays = 365;
  static const int _snoozeIdOffset = 500000;

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

    const androidSettings = AndroidInitializationSettings('ic_launcher');

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
              final actionId = response.actionId;

              if (actionId == 'TAKEN') {
                if (notificationId != null) {
                  await _notifications.cancel(id: notificationId);
                }

                _activeNotificationId = null;

                _addPendingPayload(payload);

                _pendingActionId = 'TAKEN';
                _pendingActionPayload = payload;
              } else if (actionId == 'SKIPPED') {
                if (notificationId != null) {
                  await _notifications.cancel(id: notificationId);
                }

                _activeNotificationId = null;

                _addPendingPayload(payload);

                _pendingActionId = 'SKIPPED';
                _pendingActionPayload = payload;
              } else {
                _addPendingPayload(payload);
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

      await _cancelActiveNotification();

      _addPendingPayload(payload);

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
    if (_pendingPayloads.isEmpty) {
      return null;
    }

    return _pendingPayloads.removeAt(0);
  }

  void _addPendingPayload(String payload) {
    if (payload.isEmpty) {
      return;
    }

    if (!_pendingPayloads.contains(payload)) {
      _pendingPayloads.add(payload);
    }
  }

  String? consumePendingAction() {
    final actionId = _pendingActionId;
    _pendingActionId = null;
    return actionId;
  }

  bool hasPendingNotification() {
    return _pendingPayloads.isNotEmpty;
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

    late final DateTime lastDate;

    if (parsedEndDate != null) {
      var endDateOnly = _dateOnly(
        parsedEndDate.year,
        parsedEndDate.month,
        parsedEndDate.day,
      );

      if (endDateOnly.difference(firstDate).inDays > _maxScheduleDays) {
        endDateOnly = firstDate.add(
          const Duration(days: _maxScheduleDays),
        );
      }

      lastDate = endDateOnly;
    } else {
      final today = _dateOnly(now.year, now.month, now.day);
      final rollingEnd = today.add(
        const Duration(days: _defaultScheduleDays),
      );

      lastDate = rollingEnd.isAfter(firstDate)
          ? rollingEnd
          : firstDate.add(const Duration(days: _defaultScheduleDays));
    }

    if (lastDate.isBefore(firstDate)) {
      return;
    }

    var dates = _generateDates(
      medicine: medicine,
      startDate: firstDate,
      endDate: lastDate,
    );

    final perDay = medicine.scheduleTimes.length;
    const maxDoses = 800;
    if (perDay > 0 && dates.length * perDay > maxDoses) {
      final keepDays = (maxDoses ~/ perDay).clamp(1, dates.length);
      dates = dates.sublist(0, keepDays);
    }

    final preCutoff = now.add(const Duration(days: 14));

    for (final date in dates) {
      for (int t = 0; t < medicine.scheduleTimes.length; t++) {
        final scheduleTime = medicine.scheduleTimes[t];
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

        final preNotificationId = _regularNotificationId(
          medicineId: medicine.id!,
          date: date,
          timeIndex: t,
          type: 0,
        );

        final exactReminderId = _regularNotificationId(
          medicineId: medicine.id!,
          date: date,
          timeIndex: t,
          type: 1,
        );

        if (preReminderTime.isAfter(now) &&
            !preReminderTime.isAfter(preCutoff)) {
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
            timeIndex: t,
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

  int _daysSinceEpoch(DateTime date) {
    final d = DateTime(date.year, date.month, date.day);
    return d.difference(DateTime(1970, 1, 1)).inDays;
  }

  int _timeIndex(MedicineModel medicine, int scheduleTimeId) {
    final idx = medicine.scheduleTimes.indexWhere(
      (e) => e.id == scheduleTimeId,
    );
    if (idx != -1) return idx.clamp(0, 49);
    return scheduleTimeId % 50;
  }

  int _regularNotificationId({
    required int medicineId,
    required DateTime date,
    required int timeIndex,
    required int type,
  }) {
    final days = _daysSinceEpoch(date) % 2000;
    final low = ((days * 50 + timeIndex.clamp(0, 49)) * 2 + type);
    return (medicineId * 1000000) + low;
  }

  int _snoozeNotificationId({
    required int medicineId,
    required DateTime date,
    required int timeIndex,
  }) {
    final days = _daysSinceEpoch(date) % 2000;
    final low =
        _snoozeIdOffset + ((days * 50 + timeIndex.clamp(0, 49)) * 2 + 1);
    return (medicineId * 1000000) + low;
  }

  int _legacyNotificationId({
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

    final t = _timeIndex(medicine, scheduleTimeId);

    final preId = _regularNotificationId(
      medicineId: medicine.id!,
      date: targetDate,
      timeIndex: t,
      type: 0,
    );

    final exactId = _regularNotificationId(
      medicineId: medicine.id!,
      date: targetDate,
      timeIndex: t,
      type: 1,
    );

    final snoozeId = _snoozeNotificationId(
      medicineId: medicine.id!,
      date: targetDate,
      timeIndex: t,
    );

    await cancel(preId);
    await cancel(exactId);
    await cancel(snoozeId);

    await _cancelLegacyDose(
      medicine: medicine,
      scheduleTimeId: scheduleTimeId,
      targetDate: targetDate,
    );
  }

  Future<void> _cancelLegacyDose({
    required MedicineModel medicine,
    required int scheduleTimeId,
    required DateTime targetDate,
  }) async {
    try {
      final dateIndex = _getDateIndexByDate(
        medicine: medicine,
        targetDate: targetDate,
      );

      if (dateIndex == null) return;

      final t = _timeIndex(medicine, scheduleTimeId);
      final n = medicine.scheduleTimes.isEmpty
          ? 1
          : medicine.scheduleTimes.length;
      final occurrenceIndex = dateIndex * n + t;

      await cancel(
        _legacyNotificationId(
          medicineId: medicine.id!,
          occurrenceIndex: occurrenceIndex,
          scheduleTimeId: scheduleTimeId,
          type: 0,
        ),
      );
      await cancel(
        _legacyNotificationId(
          medicineId: medicine.id!,
          occurrenceIndex: occurrenceIndex,
          scheduleTimeId: scheduleTimeId,
          type: 1,
        ),
      );
    } catch (_) {}
  }

  Future<void> scheduleMedicineDose({
    required MedicineModel medicine,
    required int scheduleTimeId,
    required DateTime scheduledDate,
    required String time,
    int preReminderMinutes = 30,
    String? dosageOverride,
    String? dosageUnitOverride,
    String? instructionOverride,
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

    final t = _timeIndex(medicine, scheduleTimeId);

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

    final preNotificationId = _regularNotificationId(
      medicineId: medicine.id!,
      date: targetDate,
      timeIndex: t,
      type: 0,
    );

    final exactReminderId = _regularNotificationId(
      medicineId: medicine.id!,
      date: targetDate,
      timeIndex: t,
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

      final effectiveDosage = dosageOverride ?? medicine.dosage;
      final effectiveUnit = dosageUnitOverride ?? medicine.dosageUnit;
      final effectiveInstruction =
          instructionOverride ?? medicine.instruction;

      final payload = _buildMedicinePayload(
        medicine: medicine,
        scheduleTime: scheduleTime,
        scheduledTime: time,
        scheduledDate: medicineTime,
        timeIndex: t,
        dosageOverride: effectiveDosage,
        dosageUnitOverride: effectiveUnit,
        instructionOverride: effectiveInstruction,
      );

      final notificationDetails = reminderType == _reminderTypeFullScreen
          ? _fullScreenNotificationDetails()
          : _compactNotificationDetails();

      await scheduleMedicineNotification(
        id: exactReminderId,
        title: 'Waktunya Minum Obat',
        body: 'Saatnya minum ${medicine.name} '
            '$effectiveDosage $effectiveUnit.',
        scheduledDate: medicineTime,
        notificationDetails: notificationDetails,
        payload: payload,
      );
    }
  }

  int? _getDateIndexByDate({
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
    int timeIndex = 0,
    String? dosageOverride,
    String? dosageUnitOverride,
    String? instructionOverride,
  }) {
    return jsonEncode({
      'type': 'medicine_reminder',
      'reminder_type': _getReminderType(),
      'medicine_id': medicine.id,
      'name': medicine.name,
      'dosage': dosageOverride ?? medicine.dosage,
      'dosage_unit': dosageUnitOverride ?? medicine.dosageUnit,
      'instruction': instructionOverride ?? medicine.instruction,
      'schedule_time_id': scheduleTime.id,
      'time_index': timeIndex,
      'scheduled_time': scheduledTime,
      'scheduled_date': scheduledDate.toIso8601String(),
      'scheduled_day':
          '${scheduledDate.year.toString().padLeft(4, '0')}-'
          '${scheduledDate.month.toString().padLeft(2, '0')}-'
          '${scheduledDate.day.toString().padLeft(2, '0')}',
    });
  }

  String _toDayString(String raw) {
    try {
      final parsed = DateTime.parse(raw);
      return '${parsed.year.toString().padLeft(4, '0')}-'
          '${parsed.month.toString().padLeft(2, '0')}-'
          '${parsed.day.toString().padLeft(2, '0')}';
    } catch (_) {
      return raw.length >= 10 ? raw.substring(0, 10) : raw;
    }
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

      final rawDate = decoded['scheduled_day']?.toString() ??
          decoded['scheduled_date']?.toString();

      if (scheduleTimeId is! int || rawDate == null || rawDate.isEmpty) {
        return;
      }

      await _medicineHistoryService?.taken(
        scheduleTimeId: scheduleTimeId,
        scheduledDate: _toDayString(rawDate),
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

      final rawDate = decoded['scheduled_day']?.toString() ??
          decoded['scheduled_date']?.toString();

      if (scheduleTimeId is! int || rawDate == null || rawDate.isEmpty) {
        return;
      }

      await _medicineHistoryService?.skipped(
        scheduleTimeId: scheduleTimeId,
        scheduledDate: _toDayString(rawDate),
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
    String? originalScheduledDate,
    int timeIndex = 0,
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

    DateTime anchorDay;
    try {
      anchorDay = originalScheduledDate != null &&
              originalScheduledDate.isNotEmpty
          ? _dateOnly(
              DateTime.parse(originalScheduledDate).year,
              DateTime.parse(originalScheduledDate).month,
              DateTime.parse(originalScheduledDate).day,
            )
          : _dateOnly(
              scheduledDate.year, scheduledDate.month, scheduledDate.day);
    } catch (_) {
      anchorDay = _dateOnly(
        scheduledDate.year,
        scheduledDate.month,
        scheduledDate.day,
      );
    }

    final t = timeIndex.clamp(0, 49);

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
      'time_index': t,
      'is_snooze': true,
      'scheduled_time':
          '${scheduledDate.hour.toString().padLeft(2, '0')}:'
          '${scheduledDate.minute.toString().padLeft(2, '0')}:00',
      'scheduled_date': scheduledDate.toIso8601String(),
      'scheduled_day':
          '${anchorDay.year.toString().padLeft(4, '0')}-'
          '${anchorDay.month.toString().padLeft(2, '0')}-'
          '${anchorDay.day.toString().padLeft(2, '0')}',
    });

    final notificationId = _snoozeNotificationId(
      medicineId: medicineId,
      date: anchorDay,
      timeIndex: t,
    );

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

  DateTime? _lastResync;

  Future<void> resyncMedicines(
    List<MedicineModel> medicines, {
    int preReminderMinutes = 30,
    bool force = false,
  }) async {
    final now = DateTime.now();
    if (!force &&
        _lastResync != null &&
        now.difference(_lastResync!).inHours < 12) {
      return;
    }
    _lastResync = now;

    late final Map<int, int> counts;
    try {
      final pending = await _notifications.pendingNotificationRequests();
      counts = {};
      for (final p in pending) {
        final mid = p.id ~/ 1000000;
        counts[mid] = (counts[mid] ?? 0) + 1;
      }
    } catch (_) {
      return;
    }

    for (final medicine in medicines) {
      try {
        if (medicine.id == null || !medicine.isActive) continue;
        final perDay =
            medicine.scheduleTimes.isEmpty ? 1 : medicine.scheduleTimes.length;
        final threshold = (perDay * 4).clamp(20, 60);
        if ((counts[medicine.id] ?? 0) < threshold) {
          await scheduleMedicineNotifications(
            medicine: medicine,
            preReminderMinutes: preReminderMinutes,
          );
        }
        await Future.delayed(const Duration(milliseconds: 10));
      } catch (_) {}
    }
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
