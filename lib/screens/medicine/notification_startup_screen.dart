import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/medicine_history_provider.dart';
import '../../routes/routes.dart';
import '../../services/notification_service.dart';

class NotificationStartupScreen extends StatefulWidget {
  const NotificationStartupScreen({super.key});

  @override
  State<NotificationStartupScreen> createState() =>
      _NotificationStartupScreenState();
}

class _NotificationStartupScreenState extends State<NotificationStartupScreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final notificationService = NotificationService.instance;

      if (!notificationService.hasPendingNotification()) {
        if (!mounted) return;

        Navigator.of(context).pushReplacementNamed(Routes.main);

        return;
      }

      final payload = notificationService.consumePendingPayload();
      final actionId = notificationService.consumePendingAction();

      if (payload == null || payload.isEmpty) {
        if (!mounted) return;

        Navigator.of(context).pushReplacementNamed(Routes.main);
        return;
      }

      try {
        final decoded = jsonDecode(payload);

        if (decoded is! Map<String, dynamic>) {
          if (!mounted) return;

          Navigator.of(context).pushReplacementNamed(Routes.main);
          return;
        }

        final reminderType = decoded['reminder_type'];

        if (reminderType == 'Ringkas') {
          if (actionId == 'TAKEN') {
            await context.read<MedicineHistoryProvider>().taken(
              scheduleTimeId: decoded['schedule_time_id'],
              scheduledDate: decoded['scheduled_date'],
              actionTime: 'now',
            );
          } else if (actionId == 'SKIPPED') {
            await context.read<MedicineHistoryProvider>().skipped(
              scheduleTimeId: decoded['schedule_time_id'],
              scheduledDate: decoded['scheduled_date'],
              actionTime: 'now',
              notes: 'Lainnya',
            );
          }

          if (!mounted) return;

          Navigator.of(context).pushReplacementNamed(Routes.main);
          return;
        }

        Navigator.of(
          context,
        ).pushReplacementNamed(Routes.reminder, arguments: decoded);
      } catch (_) {
        if (!mounted) return;

        Navigator.of(context).pushReplacementNamed(Routes.main);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: SizedBox.shrink());
  }
}
