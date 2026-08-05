import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shimmer/shimmer.dart';
import 'package:smart_antibiotic/utils/app_assets.dart';
import 'package:smart_antibiotic/utils/app_colors.dart';
import 'package:smart_antibiotic/utils/app_text.dart';
import 'package:smart_antibiotic/utils/custom_calendar.dart';
import 'package:smart_antibiotic/utils/custom_dialog_medicine.dart';
import 'package:smart_antibiotic/utils/custom_education_card.dart';
import 'package:smart_antibiotic/utils/custom_medicine_card.dart';
import 'package:smart_antibiotic/utils/custom_quiz_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DateTime selectedDate = DateTime.now();
  late DateTime currentWeekStart;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    currentWeekStart = now.subtract(Duration(days: now.weekday % 7));
    _fetchData();
  }

  Future<void> _fetchData() async {
    await Future.delayed(const Duration(milliseconds: 600));
    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

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
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: AppColors.surfaceCool,
        body: Column(
          children: [
            _buildHeader(context, isLoading: _isLoading),
            _isLoading
                ? _buildShimmerCalendar()
                : CustomCalendar(
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
                child: _isLoading
                    ? _buildShimmerContent()
                    : _buildContent(context),
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

  Widget _buildShimmerCalendar() {
    return Shimmer.fromColors(
      baseColor: AppColors.surfaceSecondary,
      highlightColor: AppColors.surfaceCool,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(
            7,
            (index) => Container(
              width: 42,
              height: 60,
              decoration: BoxDecoration(
                color: AppColors.surfacePrimary,
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildShimmerContent() {
    return Shimmer.fromColors(
      baseColor: AppColors.surfaceSecondary,
      highlightColor: AppColors.surfaceCool,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 2,
              padding: EdgeInsets.zero,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Container(
                    width: double.infinity,
                    height: 72,
                    decoration: BoxDecoration(
                      color: AppColors.surfacePrimary,
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 26),
            Row(
              children: [
                Container(
                  width: 100,
                  height: 18,
                  decoration: BoxDecoration(
                    color: AppColors.surfacePrimary,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const Spacer(),
                Container(
                  width: 70,
                  height: 14,
                  decoration: BoxDecoration(
                    color: AppColors.surfacePrimary,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: const NeverScrollableScrollPhysics(),
              child: Row(
                children: List.generate(
                  4,
                  (index) => Container(
                    margin: const EdgeInsets.only(right: 10),
                    width: 110,
                    height: 155,
                    decoration: BoxDecoration(
                      color: AppColors.surfacePrimary,
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 26),
            Row(
              children: [
                Container(
                  width: 60,
                  height: 18,
                  decoration: BoxDecoration(
                    color: AppColors.surfacePrimary,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const Spacer(),
                Container(
                  width: 70,
                  height: 14,
                  decoration: BoxDecoration(
                    color: AppColors.surfacePrimary,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 3,
              padding: EdgeInsets.zero,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Container(
                    width: double.infinity,
                    height: 70,
                    decoration: BoxDecoration(
                      color: AppColors.surfacePrimary,
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 26),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          _buildMedicineList(context, _showMedicineDialog, selectedDate),
          const SizedBox(height: 26),
          _buildEducationList(context),
          const SizedBox(height: 26),
          _buildQuisList(context),
          const SizedBox(height: 26),
        ],
      ),
    );
  }
}

Widget _buildHeader(BuildContext context, {required bool isLoading}) {
  return Container(
    height: 115,
    width: double.infinity,
    color: AppColors.primary,
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 26),
      child: SafeArea(
        bottom: false,
        child: Row(
          children: [
            if (isLoading)
              Shimmer.fromColors(
                baseColor: AppColors.accent,
                highlightColor: AppColors.primary,
                child: Container(
                  width: 100,
                  height: 24,
                  decoration: BoxDecoration(
                    color: AppColors.accent,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              )
            else
              Expanded(
                child: Text(
                  'Serra Gohv',
                  style: AppTextStyles.titleLarge.copyWith(
                    color: AppColors.textWhite,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            const Spacer(),
            if (isLoading)
              Shimmer.fromColors(
                baseColor: AppColors.accent,
                highlightColor: AppColors.primary,
                child: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: AppColors.accent,
                    shape: BoxShape.circle,
                  ),
                ),
              )
            else
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
          const Spacer(),
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
                const SizedBox(width: 2),
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
      const SizedBox(height: 14),
      SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        clipBehavior: Clip.none,
        child: Row(
          children: [
            CustomEducationCard(
              title: 'Apa itu Antibiotik?',
              image: Image.asset(imgEdu1),
              colorCard: const Color(0xFFE3EFFD),
              colorText: const Color(0xFF1A61CB),
              onTap: () =>
                  Navigator.pushNamed(context, '/education-definition'),
            ),
            const SizedBox(width: 10),
            CustomEducationCard(
              title: 'Jenis-Jenis Antibiotik',
              image: Image.asset(imgEdu2),
              colorCard: const Color(0xFFE2F5F1),
              colorText: const Color(0xFF076151),
              onTap: () => Navigator.pushNamed(context, '/education-type'),
            ),
            const SizedBox(width: 10),
            CustomEducationCard(
              title: 'Kapan Diperlukan?',
              image: Image.asset(imgEdu3),
              colorCard: const Color(0xFFFEECD5),
              colorText: const Color(0xFF8D4402),
              onTap: () =>
                  Navigator.pushNamed(context, '/education-indications'),
            ),
            const SizedBox(width: 10),
            CustomEducationCard(
              title: 'Cara\nPenggunaan Antibiotik',
              image: Image.asset(imgEdu4),
              colorCard: const Color(0xFFE7E5FE),
              colorText: const Color(0xFF4A29A3),
              onTap: () => Navigator.pushNamed(context, '/education-usage'),
            ),
            const SizedBox(width: 10),
            CustomEducationCard(
              title: 'Resistensi Antibiotik',
              image: Image.asset(imgEdu5),
              colorCard: const Color(0xFFFEE1E3),
              colorText: const Color(0xFFAA2125),
              onTap: () =>
                  Navigator.pushNamed(context, '/education-resistance'),
            ),
            const SizedBox(width: 10),
            CustomEducationCard(
              title: 'Kategori Antibiotik',
              image: Image.asset(imgEdu6),
              colorCard: const Color(0xFFE1F6F9),
              colorText: const Color(0xFF0C6C79),
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
          const Spacer(),
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
                const SizedBox(width: 2),
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
      const SizedBox(height: 14),
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
              onTap: () => Navigator.pushNamed(context, '/quiz-detail'),
            ),
            const SizedBox(height: 10),
            CustomQuizCard(
              title: 'Level 2',
              subtitle: 'Lorem Ipsum',
              image: Image.asset(imgKuis2),
              color: AppColors.surfacePrimary,
              onTap: () {},
            ),
            const SizedBox(height: 10),
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
