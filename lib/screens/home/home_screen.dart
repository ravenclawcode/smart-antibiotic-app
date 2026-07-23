import 'package:flutter/material.dart';
import 'package:smart_antibiotic/utils/app_text.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Hai, Ravenclaw', style: AppTextStyles.bodySmall),
      ),
    );
  }
}
