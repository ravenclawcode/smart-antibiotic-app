import 'package:flutter/material.dart';
import 'package:smart_antibiotic/utils/app_assets.dart';
import 'package:smart_antibiotic/utils/custom_button_add.dart';
import 'package:smart_antibiotic/utils/custom_medicine_list_card.dart';

import '../../utils/app_colors.dart';
import '../../utils/app_text.dart';

class MedicineScreen extends StatefulWidget {
  const MedicineScreen({super.key});

  @override
  State<MedicineScreen> createState() => _MedicineScreenState();
}

class _MedicineScreenState extends State<MedicineScreen> {
  final medicine = [
    {
      'name': 'Amoxicillin',
      'dosage': '1 Tablet',
      'instruction': 'Sebelum makan',
      'start_date': '2026-08-03',
      'end_date': '2026-09-03',
      'frequency_type': 'daily',
      'times_per_day': 2,
      'interval_value': null,
      'days': null,
      'dates': null,
      'times': ['08:00', '20:00'],
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surfaceCool,
      body: Column(
        children: [
          _buildHeader(context),
          Expanded(child: _buildContent(medicine)),
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

Widget _buildContent(List<Map<String, dynamic>> medicineData) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20),
    child: Column(
      children: [
        SizedBox(height: 20),
        Expanded(child: _buildList(medicineData)),
        CustomButtonAdd(onTap: () {}, label: 'Tambah Obat'),
      ],
    ),
  );
}

Widget _buildList(List<Map<String, dynamic>> medicineData) {
  return ListView.builder(
    shrinkWrap: true,
    physics: NeverScrollableScrollPhysics(),
    itemCount: medicineData.length,
    padding: EdgeInsets.zero,
    itemBuilder: (context, index) {
      final item = medicineData[index];

      return Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: CustomMedicineListCard(
          title: (item['name'] as String?) ?? '-',
          image: Image.asset(imgTablet, height: 30),
          onTap: () =>
              Navigator.pushNamed(context, '/medicine-detail', arguments: item),
        ),
      );
    },
  );
}
