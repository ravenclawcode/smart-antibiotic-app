import 'package:flutter/material.dart';
import 'package:smart_antibiotic/utils/app_assets.dart';
import 'package:smart_antibiotic/utils/app_colors.dart';
import 'package:smart_antibiotic/utils/app_text.dart';
import 'package:smart_antibiotic/utils/custom_dialog_medicine.dart';

import '../../utils/custom_calendar.dart';
import '../../utils/custom_education_card.dart';
import '../../utils/custom_medicine_card.dart';
import '../../utils/custom_quiz_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DateTime selectedDate = DateTime.now();
  late DateTime currentWeekStart;

  void _showMedicineDialog({
    required String time,
    required Widget image,
    required String name,
    required String dosage,
    required String notes,
    required bool isTaken,
    required bool isSkipped,
    required bool isMissed,
    required Widget imgStatus,
    String? statusText,
    String? notesText,
  }) async {
    await showDialog(
      context: context,
      barrierDismissible: true,
      builder: (_) => CustomDialogMedicine(
        time: time,
        image: image,
        name: name,
        dosage: dosage,
        notes: notes,
        isTaken: isTaken,
        isSkipped: isSkipped,
        isMissed: isMissed,
        imgStatus: imgStatus,
        statusText: statusText,
        notesText: notesText,
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    currentWeekStart = now.subtract(Duration(days: now.weekday % 7));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surfaceCool,
      body: Column(
        children: [
          _buildHeader(context),
          CustomCalendar(
            selectedDate: selectedDate,
            currentWeekStart: currentWeekStart,
            onDateSelected: (date) {
              setState(() => selectedDate = date);
            },
            onWeekChanged: (newWeekStart) {
              setState(() => currentWeekStart = newWeekStart);
            },
            onResetToToday: (today, weekStart) {
              setState(() {
                selectedDate = today;
                currentWeekStart = weekStart;
              });
            },
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 16),
                    _buildMedicineList(
                      context,
                      _showMedicineDialog,
                      selectedDate,
                    ),
                    SizedBox(height: 26),
                    _buildEducationList(context),
                    SizedBox(height: 26),
                    _buildQuisList(context),
                    SizedBox(height: 26),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, '/chatbot'),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
        child: Image.asset(imgChatbot),
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
            Expanded(
              child: Text(
                'Syifa',
                style: AppTextStyles.titleLarge.copyWith(
                  color: AppColors.textWhite,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            InkWell(
              focusColor: Colors.transparent,
              hoverColor: Colors.transparent,
              highlightColor: Colors.transparent,
              splashColor: Colors.transparent,
              onTap: () => Navigator.pushNamed(context, '/settings'),
              child: Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: AppColors.accent,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Image.asset(icSettings, color: AppColors.textWhite),
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

Widget _buildMedicineList(
  BuildContext context,
  Function showMedicineDialog,
  DateTime selectedDate,
) {
  final dateFormatted =
      "${selectedDate.day} ${_getMonthName(selectedDate.month)}";

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      CustomMedicineCard(
        time: '09.00',
        image: Image.asset(imgTablet, width: 30),
        name: 'Amoxicillin',
        dosage: 'Minum 1 Tablet',
        notes: '',
        isTaken: false,
        isSkipped: false,
        isMissed: false,
        imgStatus: const SizedBox(),
        onTap: () => showMedicineDialog(
          time: '09.00',
          image: Image.asset(imgTablet, width: 44),
          name: 'Amoxicillin',
          dosage: 'Minum 1 Tablet',
          notes: '',
          isTaken: false,
          isSkipped: false,
          isMissed: false,
          imgStatus: const SizedBox(),
        ),
      ),
      const SizedBox(height: 12),

      CustomMedicineCard(
        time: '16.00',
        image: Image.asset(imgTablet, width: 30),
        name: 'Amoxicillin',
        dosage: 'Minum 1 Tablet',
        notes: '',
        isTaken: true,
        isSkipped: false,
        isMissed: false,
        imgStatus: Image.asset(imgTaken, width: 12),
        statusText: 'Diminum pukul 16.00, $dateFormatted',
        onTap: () => showMedicineDialog(
          time: '16.00',
          image: Image.asset(imgTablet, width: 44),
          name: 'Amoxicillin',
          dosage: 'Minum 1 Tablet',
          notes: '',
          isTaken: true,
          isSkipped: false,
          isMissed: false,
          imgStatus: Image.asset(imgTaken, width: 14),
          statusText: 'Diminum pukul 16.00, $dateFormatted',
        ),
      ),
      const SizedBox(height: 12),

      CustomMedicineCard(
        time: '20.00',
        image: Image.asset(imgTablet, width: 30),
        name: 'Amoxicillin',
        dosage: 'Minum 1 Tablet',
        notes: '',
        isTaken: false,
        isSkipped: true,
        isMissed: false,
        imgStatus: Image.asset(imgSkipped, width: 12),
        notesText: 'Lupa / sedang sibuk / tertidur',
        statusText: 'Dilewati pukul 20.00, $dateFormatted',
        onTap: () => showMedicineDialog(
          time: '20.00',
          image: Image.asset(imgTablet, width: 44),
          name: 'Amoxicillin',
          dosage: 'Minum 1 Tablet',
          notes: '',
          isTaken: false,
          isSkipped: true,
          isMissed: false,
          imgStatus: Image.asset(imgSkipped, width: 14),
          notesText: 'Lupa / sedang sibuk / tertidur',
          statusText: 'Dilewati pukul 20.00, $dateFormatted',
        ),
      ),
      const SizedBox(height: 12),

      CustomMedicineCard(
        time: '23.00',
        image: Image.asset(imgTablet, width: 30),
        name: 'Amoxicillin',
        dosage: 'Minum 1 Tablet',
        notes: '',
        isTaken: false,
        isSkipped: false,
        isMissed: true,
        imgStatus: Image.asset(imgMissed, width: 12),
        statusText: 'Terlewat',
        onTap: () => showMedicineDialog(
          time: '23.00',
          image: Image.asset(imgTablet, width: 44),
          name: 'Amoxicillin',
          dosage: 'Minum 1 Tablet',
          notes: '',
          isTaken: false,
          isSkipped: false,
          isMissed: true,
          imgStatus: Image.asset(imgMissed, width: 14),
          statusText: 'Terlewat',
        ),
      ),
    ],
  );
}

Widget _buildEducationList(BuildContext context) {
  return Column(
    children: [
      Row(
        children: [
          Text(
            'Antibiotik',
            style: AppTextStyles.titleSmall.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          Spacer(),
          InkWell(
            focusColor: Colors.transparent,
            hoverColor: Colors.transparent,
            highlightColor: Colors.transparent,
            splashColor: Colors.transparent,
            onTap: () => Navigator.pushNamed(context, '/education'),
            child: Row(
              children: [
                Text(
                  'Lihat Semua',
                  style: AppTextStyles.bodySmall.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
                SizedBox(width: 2),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 12,
                  color: AppColors.primary,
                ),
              ],
            ),
          ),
        ],
      ),
      SizedBox(height: 14),
      SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        clipBehavior: Clip.none,
        child: Row(
          children: [
            CustomEducationCard(
              title: 'Apa itu Antibiotik?',
              image: Image.asset(imgEdu1),
              colorCard: Color(0xFFE3EFFD),
              colorText: Color(0xFF1A61CB),
              onTap: () =>
                  Navigator.pushNamed(context, '/education-definition'),
            ),
            SizedBox(width: 10),
            CustomEducationCard(
              title: 'Jenis-Jenis Antibiotik',
              image: Image.asset(imgEdu2),
              colorCard: Color(0xFFE2F5F1),
              colorText: Color(0xFF076151),
              onTap: () => Navigator.pushNamed(context, '/education-type'),
            ),
            SizedBox(width: 10),
            CustomEducationCard(
              title: 'Kapan Diperlukan?',
              image: Image.asset(imgEdu3),
              colorCard: Color(0xFFFEECD5),
              colorText: Color(0xFF8D4402),
              onTap: () =>
                  Navigator.pushNamed(context, '/education-indications'),
            ),
            SizedBox(width: 10),
            CustomEducationCard(
              title: 'Cara\nPenggunaan Antibiotik',
              image: Image.asset(imgEdu4),
              colorCard: Color(0xFFE7E5FE),
              colorText: Color(0xFF4A29A3),
              onTap: () => Navigator.pushNamed(context, '/education-usage'),
            ),
            SizedBox(width: 10),
            CustomEducationCard(
              title: 'Resistensi Antibiotik',
              image: Image.asset(imgEdu5),
              colorCard: Color(0xFFFEE1E3),
              colorText: Color(0xFFAA2125),
              onTap: () =>
                  Navigator.pushNamed(context, '/education-resistance'),
            ),
            SizedBox(width: 10),
            CustomEducationCard(
              title: 'Kategori Antibiotik',
              image: Image.asset(imgEdu6),
              colorCard: Color(0xFFE1F6F9),
              colorText: Color(0xFF0C6C79),
              onTap: () => Navigator.pushNamed(context, '/education-category'),
            ),
          ],
        ),
      ),
    ],
  );
}

Widget _buildQuisList(BuildContext context) {
  return Column(
    children: [
      Row(
        children: [
          Text(
            'Kuis',
            style: AppTextStyles.titleSmall.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          Spacer(),
          InkWell(
            focusColor: Colors.transparent,
            hoverColor: Colors.transparent,
            highlightColor: Colors.transparent,
            splashColor: Colors.transparent,
            onTap: () => Navigator.pushNamed(context, '/quiz'),
            child: Row(
              children: [
                Text(
                  'Lihat Semua',
                  style: AppTextStyles.bodySmall.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
                SizedBox(width: 2),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 12,
                  color: AppColors.primary,
                ),
              ],
            ),
          ),
        ],
      ),
      SizedBox(height: 14),
      SingleChildScrollView(
        scrollDirection: Axis.vertical,
        clipBehavior: Clip.none,
        child: Column(
          children: [
            CustomQuizCard(
              title: 'Level 1',
              subtitle: 'Lorem Ipsum',
              image: Image.asset(imgKuis1),
              color: AppColors.surfacePrimary,
              onTap: () {},
            ),
            SizedBox(height: 10),
            CustomQuizCard(
              title: 'Level 2',
              subtitle: 'Lorem Ipsum',
              image: Image.asset(imgKuis2),
              color: AppColors.surfacePrimary,
              onTap: () {},
            ),
            SizedBox(height: 10),
            CustomQuizCard(
              title: 'Level 3',
              subtitle: 'Lorem Ipsum',
              image: Image.asset(imgKuis3),
              color: AppColors.surfacePrimary,
              onTap: () {},
            ),
          ],
        ),
      ),
    ],
  );
}

String _getMonthName(int month) {
  const months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'Mei',
    'Jun',
    'Jul',
    'Agu',
    'Sep',
    'Okt',
    'Nov',
    'Des',
  ];
  return months[month - 1];
}
