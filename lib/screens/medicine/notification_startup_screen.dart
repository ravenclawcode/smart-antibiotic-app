import 'package:flutter/material.dart';

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

    WidgetsBinding.instance.addPostFrameCallback((_) {
      NotificationService.instance.handlePendingNotification();
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: SizedBox.shrink());
  }
}
