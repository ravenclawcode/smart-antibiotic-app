import 'package:flutter/material.dart';

import '../../utils/app_colors.dart';
import '../../utils/app_text.dart';

class MedicineScreen extends StatefulWidget {
  const MedicineScreen({super.key});

  @override
  State<MedicineScreen> createState() => _MedicineScreenState();
}

class _MedicineScreenState extends State<MedicineScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surfaceCool,
      body: Center(child: Text('Hai, Syifa', style: AppTextStyles.bodySmall)),
    );
  }
}
