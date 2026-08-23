import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import 'package:smart_antibiotic/utils/app_assets.dart';
import 'package:smart_antibiotic/utils/app_colors.dart';
import 'package:smart_antibiotic/utils/app_text.dart';
import 'package:smart_antibiotic/utils/custom_calendar.dart';
import 'package:smart_antibiotic/utils/custom_dialog_medicine.dart';
import 'package:smart_antibiotic/utils/custom_education_card.dart';
import 'package:smart_antibiotic/utils/custom_medicine_card.dart';
import 'package:smart_antibiotic/utils/custom_quiz_card.dart';

import '../../models/home_medicine_item.dart';
import '../../providers/home_provider.dart';
import '../../providers/medicine_provider.dart';
import '../../providers/quiz_provider.dart';
import '../../utils/custom_dialog_delete_medicine.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DateTime selectedDate = DateTime.now();
  late DateTime currentWeekStart;

  bool _hasInitialLoaded = false;

  @override
  void initState() {
    super.initState();

    final now = DateTime.now();
    selectedDate = DateTime(now.year, now.month, now.day);

    final daysToSubtract = now.weekday % 7;
    currentWeekStart = DateTime(
      now.year,
      now.month,
      now.day,
    ).subtract(Duration(days: daysToSubtract));

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted) return;

      try {
        await Future.wait([
          context.read<HomeProvider>().load(selectedDate),
          context.read<QuizProvider>().loadQuizzes(),
        ]);
      } finally {
        if (mounted) {
          setState(() {
            _hasInitialLoaded = true;
          });
        }
      }
    });
  }

  Future<void> _loadDate(DateTime date) async {
    if (!mounted) return;
    await context.read<HomeProvider>().load(date);
  }

  Future<void> _showMedicineDialog(
    BuildContext context,
    HomeMedicineItem item,
    DateTime selectedDate,
  ) async {
    final medicine = item.medicine;

    if (!context.mounted) return;

    await showDialog(
      context: context,
      barrierDismissible: true,
      builder: (dialogContext) {
        return CustomDialogMedicine(
          medicine: medicine,
          time: item.time,
          image: Image.asset(imgTablet, width: 44),
          name: item.name,
          dosage: item.dosage,
          notes: item.instruction ?? '',
          medicineId: item.medicineId,
          scheduleTimeId: item.scheduleTimeId,
          scheduledDate: item.scheduledDate,
          isTaken: item.isTaken,
          takenAt: item.takenAt,
          isSkipped: item.isSkipped,
          skippedAt: item.skippedAt,
          isMissed: item.isMissed,
          imgStatus: _buildStatusImage(item),
          statusText: _buildStatusText(item, selectedDate),
          notesText: item.notes,
          isRescheduled: item.isRescheduled,
          rescheduledTime: item.rescheduledTime,
          onTaken: (String actionTime) async {
            if (dialogContext.mounted) {
              Navigator.pop(dialogContext);
            }
            await context.read<HomeProvider>().taken(
              item: item,
              date: selectedDate,
              actionTime: actionTime,
            );
          },
          onSkipped: (String actionTime, String notes) async {
            if (dialogContext.mounted) {
              Navigator.pop(dialogContext);
            }
            await context.read<HomeProvider>().skipped(
              item: item,
              date: selectedDate,
              actionTime: actionTime,
              notes: notes,
            );
          },
          onReschedule: (String time) async {
            if (dialogContext.mounted) {
              Navigator.pop(dialogContext);
            }
            await context.read<HomeProvider>().reschedule(
              item: item,
              date: selectedDate,
              newTime: time,
            );
          },
          onCancel: () async {
            if (dialogContext.mounted) {
              Navigator.pop(dialogContext);
            }
            await context.read<HomeProvider>().cancel(
              item: item,
              date: selectedDate,
            );
          },
          onEditFutureDoses: () async {
            await context.read<HomeProvider>().reloadWithLoading(selectedDate);
          },
          onDeleteSingleDose:
              (int medicineId, int scheduleTimeId, String scheduledDate) async {
                final medicineProvider = context.read<MedicineProvider>();
                final homeProvider = context.read<HomeProvider>();

                final success = await homeProvider.runWithLoading<bool>(
                  () async {
                    final success = await medicineProvider.deleteDose(
                      medicineId: medicineId,
                      scheduleTimeId: scheduleTimeId,
                      scheduledDate: scheduledDate,
                    );

                    if (success) {
                      await homeProvider.load(selectedDate, showLoading: false);
                    }
                    return success;
                  },
                );

                if (!context.mounted) return;

                if (!success) {
                  final message =
                      medicineProvider.errorMessage ?? 'Gagal menghapus dosis.';
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text(message)));
                }
              },
          onDeleteFutureDoses:
              (int medicineId, int scheduleTimeId, String scheduledDate) async {
                final result = await showDialog<Map<String, Object>>(
                  context: context,
                  builder: (deleteDialogContext) {
                    return CustomDialogDeleteMedicine(medicine: medicine);
                  },
                );

                if (!context.mounted || result == null) return;

                final medicineProvider = context.read<MedicineProvider>();
                final homeProvider = context.read<HomeProvider>();
                final keepHistory = result['keepHistory'] as bool? ?? true;

                final success = await homeProvider.runWithLoading<bool>(
                  () async {
                    final success = keepHistory
                        ? await medicineProvider.deleteMedicine(medicineId)
                        : await medicineProvider.deleteMedicinePermanent(
                            medicineId,
                          );

                    if (success) {
                      await homeProvider.load(selectedDate, showLoading: false);
                    }
                    return success;
                  },
                );

                if (!context.mounted) return;

                if (!success) {
                  final message =
                      medicineProvider.errorMessage ?? 'Gagal menghapus obat.';
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text(message)));
                }
              },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<HomeProvider>();
    final isLoading = provider.isLoading;

    final isInitialLoading = isLoading && !_hasInitialLoaded;
    final isDateLoading = isLoading && _hasInitialLoaded;

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
            _HomeHeader(
              isLoading: isInitialLoading,
              userName: provider.userName,
            ),

            isInitialLoading
                ? _buildShimmerCalendar()
                : AnimatedSwitcher(
                    duration: const Duration(milliseconds: 250),
                    switchInCurve: Curves.easeIn,
                    switchOutCurve: Curves.easeOut,
                    transitionBuilder:
                        (Widget child, Animation<double> animation) {
                          return FadeTransition(
                            opacity: animation,
                            child: child,
                          );
                        },
                    child: CustomCalendar(
                      key: ValueKey<DateTime>(currentWeekStart),
                      selectedDate: selectedDate,
                      currentWeekStart: currentWeekStart,
                      onDateSelected: (date) {
                        setState(() {
                          selectedDate = date;
                        });
                        _loadDate(date);
                      },
                      onWeekChanged: (newWeekStart) {
                        setState(() {
                          final dayOffset = selectedDate
                              .difference(currentWeekStart)
                              .inDays;
                          currentWeekStart = newWeekStart;
                          selectedDate = newWeekStart.add(
                            Duration(days: dayOffset % 7),
                          );
                        });
                        _loadDate(selectedDate);
                      },
                      onResetToToday: (today, weekStart) {
                        setState(() {
                          selectedDate = today;
                          currentWeekStart = weekStart;
                        });
                        _loadDate(today);
                      },
                    ),
                  ),

            Expanded(
              child: SingleChildScrollView(
                child: isInitialLoading || isDateLoading
                    ? _buildShimmerContent()
                    : Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 16),
                            _HomeMedicineList(
                              selectedDate: selectedDate,
                              onTapItem: (item) => _showMedicineDialog(
                                context,
                                item,
                                selectedDate,
                              ),
                            ),
                            const SizedBox(height: 16),
                            const _HomeEducationSection(),
                            const SizedBox(height: 26),
                            _HomeQuizSection(),
                            const SizedBox(height: 26),
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
}

class _HomeHeader extends StatelessWidget {
  final bool isLoading;
  final String? userName;

  const _HomeHeader({required this.isLoading, required this.userName});

  @override
  Widget build(BuildContext context) {
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
                    userName ?? '',
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
                    decoration: const BoxDecoration(
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
                      child: Image.asset(
                        icSettings,
                        color: AppColors.textWhite,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _HomeMedicineList extends StatelessWidget {
  final DateTime selectedDate;
  final ValueChanged<HomeMedicineItem> onTapItem;

  const _HomeMedicineList({
    required this.selectedDate,
    required this.onTapItem,
  });

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<HomeProvider>();

    if (provider.medicines.isEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 24),
        child: Text(
          'Tidak ada jadwal obat.',
          textAlign: TextAlign.center,
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
      );
    }

    return Column(
      children: provider.medicines.map((item) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: CustomMedicineCard(
            time: item.time,
            image: Image.asset(imgTablet, width: 30),
            name: item.name,
            dosage: item.dosage,
            notes: item.instruction ?? '',
            isTaken: item.isTaken,
            takenAt: item.takenAt,
            isSkipped: item.isSkipped,
            skippedAt: item.skippedAt,
            isMissed: item.isMissed,
            isRescheduled: item.isRescheduled,
            imgStatus: _buildStatusImage(item),
            statusText: _buildStatusText(item, selectedDate),
            notesText: item.notes,
            rescheduledTime: item.rescheduledTime,
            onTap: () => onTapItem(item),
          ),
        );
      }).toList(),
    );
  }
}

class _HomeEducationSection extends StatelessWidget {
  const _HomeEducationSection();

  @override
  Widget build(BuildContext context) {
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
                onTap: () =>
                    Navigator.pushNamed(context, '/education-category'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _HomeQuizSection extends StatelessWidget {
  const _HomeQuizSection();

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<QuizProvider>();
    final quizzes = provider.quizzes;

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
        Column(
          children: [
            ...quizzes.asMap().entries.map((entry) {
              final index = entry.key;
              final quiz = entry.value;

              final images = [imgKuis1, imgKuis2, imgKuis3];

              final imagePath = images[index % images.length];

              return Padding(
                padding: EdgeInsets.only(
                  bottom: index < quizzes.length - 1 ? 10 : 0,
                ),
                child: CustomQuizCard(
                  title: 'Level ${quiz.level}',
                  subtitle: quiz.description ?? '',
                  image: Image.asset(imagePath),
                  color: AppColors.surfacePrimary,
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      '/quiz-detail',
                      arguments: quiz.id,
                    );
                  },
                ),
              );
            }),
          ],
        ),
      ],
    );
  }
}

Widget _buildStatusImage(HomeMedicineItem item) {
  if (item.isTaken) {
    return Image.asset(imgTaken, width: 14);
  }
  if (item.isSkipped) {
    return Image.asset(imgSkipped, width: 14);
  }
  if (item.isMissed) {
    return Image.asset(imgMissed, width: 14);
  }
  if (item.isRescheduled) {
    return Image.asset(icClock, width: 14, color: AppColors.primary);
  }
  return const SizedBox();
}

String? _buildStatusText(HomeMedicineItem item, DateTime selectedDate) {
  if (item.isTaken) {
    if (item.takenAt != null && item.takenAt!.isNotEmpty) {
      final formatted = _formatStatusDateTime(item.takenAt!);
      return formatted.isNotEmpty ? 'Diminum $formatted' : 'Sudah diminum';
    }
    return 'Sudah diminum';
  }

  if (item.isSkipped) {
    if (item.skippedAt != null && item.skippedAt!.isNotEmpty) {
      final formatted = _formatStatusDateTime(item.skippedAt!);
      return formatted.isNotEmpty ? 'Dilewati $formatted' : 'Dilewati';
    }
    return 'Dilewati';
  }

  if (item.isMissed) {
    return 'Terlewat';
  }

  if (item.isRescheduled) {
    if (item.rescheduledTime != null && item.rescheduledTime!.isNotEmpty) {
      final formatted = _formatRescheduledStatusDateTime(item.rescheduledTime!);
      return formatted.isNotEmpty
          ? 'Dijadwalkan ulang $formatted'
          : 'Dijadwalkan ulang';
    }
    return 'Dijadwalkan ulang';
  }

  return null;
}

String _formatStatusDateTime(String value) {
  try {
    final date = DateTime.parse(value).toLocal();
    final hour = date.hour.toString().padLeft(2, '0');
    final minute = date.minute.toString().padLeft(2, '0');
    return 'pukul $hour.$minute ${_formatDateLabel(date)}';
  } catch (_) {
    return '';
  }
}

String _formatRescheduledStatusDateTime(String value) {
  try {
    DateTime date;
    if (value.contains('T') || value.contains(' ')) {
      date = DateTime.parse(value).toLocal();
    } else {
      final parts = value.split(':');
      final hour = int.tryParse(parts[0]) ?? 0;
      final minute = int.tryParse(parts[1]) ?? 0;
      final now = DateTime.now();
      date = DateTime(now.year, now.month, now.day, hour, minute);
    }

    final hour = date.hour.toString().padLeft(2, '0');
    final minute = date.minute.toString().padLeft(2, '0');
    return 'pukul $hour.$minute ${_formatDateLabel(date)}';
  } catch (_) {
    return '';
  }
}

String _formatDateLabel(DateTime date) {
  final now = DateTime.now();
  if (date.year == now.year && date.month == now.month && date.day == now.day) {
    return 'hari ini, ${date.day} ${_monthShort(date.month)}';
  }
  return '${date.day} ${_monthShort(date.month)}';
}

String _monthShort(int month) {
  const months = [
    '',
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
  return (month >= 1 && month <= 12) ? months[month] : '';
}
