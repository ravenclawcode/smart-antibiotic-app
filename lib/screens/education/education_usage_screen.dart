import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../utils/app_assets.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_text.dart';
import '../../utils/custom_list_card.dart';

class EducationUsageScreen extends StatelessWidget {
  const EducationUsageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
      child: Scaffold(
        body: Column(
          children: [
            _buildHeader(context),
            SingleChildScrollView(child: _buildContent(context)),
          ],
        ),
      ),
    );
  }
}

Widget _buildHeader(BuildContext context) {
  final isSmallScreen = MediaQuery.of(context).size.width < 360;

  return Container(
    height: 115,
    width: double.infinity,
    color: AppColors.primary,
    child: Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: SafeArea(
        bottom: false,
        child: Row(
          children: [
            InkWell(
              focusColor: Colors.transparent,
              hoverColor: Colors.transparent,
              highlightColor: Colors.transparent,
              splashColor: Colors.transparent,
              onTap: () => Navigator.pop(context),
              child: Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: AppColors.accent,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Icon(
                  Icons.arrow_back_ios_new_rounded,
                  size: 20,
                  color: AppColors.surfacePrimary,
                ),
              ),
            ),
            SizedBox(width: 14),
            Expanded(
              child: Text(
                'Cara Penggunaan Antibiotik',
                style: AppTextStyles.titleLarge.copyWith(
                  fontSize: isSmallScreen ? 24 : 21,
                  color: AppColors.textWhite,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

Widget _buildContent(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20),
    child: Column(
      children: [
        SizedBox(height: 26),
        Text(
          'Beberapa hal yang perlu diperhatikan dalam penggunaan antibiotik:',
          style: AppTextStyles.bodyMedium.copyWith(fontSize: 18),
        ),
        SizedBox(height: 16),
        _buildList(context),
      ],
    ),
  );
}

Widget _buildList(BuildContext context) {
  final item = [
    {
      'title': 'Gunakan sesuai resep dokter',
      'subtitle': 'Jangan membeli tanpa resep',
      'image': Image.asset(imgDoctor),
    },
    {
      'title': 'Habiskan sesuai aturan',
      'subtitle':
          'Jangan berhenti di tengah jalan meskipun merasa sudah sembuh',
      'image': Image.asset(imgCalendar),
    },
    {
      'title': 'Gunakan sesuai resep dokter',
      'subtitle': 'Ikuti dosis dan jadwal yang di anjurkan',
      'image': Image.asset(imgPills),
    },
    {
      'title': 'Jangan berbagi antibiotik',
      'subtitle':
          'Obat yang cocok untuk orang lain belum tentu cocok untuk Anda.',
      'image': Image.asset(imgPeople),
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
        child: CustomListCard(
          title: menu['title'] as String,
          subtitle: menu['subtitle'] as String,
          image: menu['image'] as Image,
          color: Color(0xFFE0EDFA),
        ),
      );
    },
  );
}
