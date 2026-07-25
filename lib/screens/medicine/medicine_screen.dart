import 'package:flutter/material.dart';
import 'package:smart_antibiotic/utils/custom_button_add.dart';

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
      body: Column(
        children: [
          _buildHeader(context),
          Spacer(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: CustomButtonAdd(onTap: () {}, label: 'Tambah Obat'),
          ),
          SizedBox(height: 26),
        ],
      ),
    );
  }
}

Widget _buildHeader(BuildContext context) {
  return Container(
    height: 115,
    width: double.infinity,
    color: AppColors.primary,
    child: Padding(
      padding: EdgeInsets.symmetric(horizontal: 26),
      child: SafeArea(
        bottom: false,
        child: Row(
          children: [
            Text(
              'Obat',
              style: AppTextStyles.titleLarge.copyWith(
                color: AppColors.textWhite,
              ),
            ),
            Spacer(),
            InkWell(
              focusColor: Colors.transparent,
              hoverColor: Colors.transparent,
              highlightColor: Colors.transparent,
              splashColor: Colors.transparent,
              onTap: () => Navigator.pushNamed(context, '/medicine-history'),
              child: Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: AppColors.accent,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Icon(
                  Icons.history_rounded,
                  size: 24,
                  color: AppColors.surfacePrimary,
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
