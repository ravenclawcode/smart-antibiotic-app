import 'package:flutter/material.dart';

import 'routes/routes.dart';
import 'utils/app_theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Smart Antibiotik',
      initialRoute: '/',
      onGenerateRoute: generateRoute,
      theme: AppTheme.lightTheme,
    );
  }
}
