import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:smart_antibiotic/utils/app_assets.dart';
import 'package:smart_antibiotic/utils/app_colors.dart';
import 'package:smart_antibiotic/utils/app_text.dart';

import '../../utils/custom_calendar.dart';
import '../../utils/custom_medicine_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DateTime selectedDate = DateTime.now();
  late DateTime currentWeekStart;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    currentWeekStart = now.subtract(Duration(days: now.weekday % 7));
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
      child: Scaffold(
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
                      _buildMedicineList(selectedDate),
                      SizedBox(height: 26),
                      _buildEducationList(),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => Navigator.pushNamed(context, '/chatbot'),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
          ),
          child: Image.asset(imgChatbot),
        ),
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
              'Serra Gohv',
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
              onTap: () => Navigator.pushNamed(context, '/settings'),
              child: Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: AppColors.accent,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Image.asset(
                  icSettings,
                  color: AppColors.textWhite,
                  cacheHeight: 20,
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

Widget _buildMedicineList(DateTime selectedDate) {
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
        imgStatus: SizedBox(),
      ),
      SizedBox(height: 12),
      CustomMedicineCard(
        time: '16.00',
        image: Image.asset(imgTablet, width: 30),
        name: 'Amoxicillin',
        dosage: 'Minum 1 Tablet',
        notes: '',
        isTaken: true,
        isSkipped: false,
        imgStatus: Image.asset(imgTaken, width: 12),
        statusText:
            'Diminum pukul 16.00, ${selectedDate.day} ${_getMonthName(selectedDate.month)}',
      ),
      // SizedBox(height: 12),
      // MedicineCard(
      //   time: '20.00',
      //   image: Image.asset(imgTablet, width: 30),
      //   name: 'Amoxicillin',
      //   dosage: 'Minum 1 Tablet',
      //   notes: '',
      //   isTaken: true,
      //   isSkipped: true,
      //   imgStatus: Image.asset(imgSkipped, width: 12),
      //   notesText: 'Lupa / sedang sibuk / tertidur',
      //   statusText:
      //       'Dilewati pukul 17.00, ${selectedDate.day} ${_getMonthName(selectedDate.month)}',
      // ),
    ],
  );
}

Widget _buildEducationList() {
  return Column(children: [Text('Antibiotik', style: AppTextStyles.bodyLarge)]);
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
