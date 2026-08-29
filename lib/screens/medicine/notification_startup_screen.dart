import 'dart:convert';

import 'package:flutter/material.dart';

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

        Navigator.of(context).pushReplacementNamed(Routes.home);

        return;
      }

      final payload = notificationService.consumePendingPayload();

      if (payload == null || payload.isEmpty) {
        if (!mounted) return;

        Navigator.of(context).pushReplacementNamed(Routes.home);
        return;
      }

      try {
        final decoded = jsonDecode(payload);

        if (decoded is! Map<String, dynamic>) {
          if (!mounted) return;

          Navigator.of(context).pushReplacementNamed(Routes.home);
          return;
        }

        final reminderType = decoded['reminder_type'];

        if (reminderType == 'Ringkas') {
          if (!mounted) return;

          Navigator.of(context).pushReplacementNamed(Routes.home);
          return;
        }

        if (!mounted) return;

        Navigator.of(
          context,
        ).pushReplacementNamed(Routes.reminder, arguments: decoded);
      } catch (_) {
        if (!mounted) return;

        Navigator.of(context).pushReplacementNamed(Routes.home);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: SizedBox.shrink());
  }
}
