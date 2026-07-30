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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surfaceCool,
      body: Column(
        children: [
          _buildHeader(context),
          Expanded(child: _buildContent()),
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

Widget _buildContent() {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20),
    child: Column(
      children: [
        SizedBox(height: 20),
        Expanded(child: _buildList()),
        CustomButtonAdd(onTap: () {}, label: 'Tambah Obat'),
      ],
    ),
  );
}

Widget _buildList() {
  final item = [
    {
      'title': 'Amoxicillin',
      'image': Image.asset(imgTablet, height: 30),
      'route': '/lorem-ipsum',
    },
  ];

  return ListView.builder(
    shrinkWrap: true,
    physics: NeverScrollableScrollPhysics(),
    itemCount: item.length,
    padding: EdgeInsets.zero,
    itemBuilder: (context, index) {
      final menu = item[index];

      return Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: CustomMedicineListCard(
          title: menu['title'] as String,
          image: menu['image'] as Image,
          onTap: () => Navigator.pushNamed(context, menu['route'] as String),
        ),
      );
    },
  );
}
