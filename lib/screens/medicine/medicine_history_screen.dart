import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:printing/printing.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import '../../providers/medicine_history_provider.dart';
import '../../utils/app_assets.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_text.dart';
import '../../utils/custom_dialog_history.dart';
import '../../utils/custom_history_card.dart';

class MedicineHistoryScreen extends StatefulWidget {
  const MedicineHistoryScreen({super.key});

  @override
  State<MedicineHistoryScreen> createState() => _MedicineHistoryScreenState();
}

class _MedicineHistoryScreenState extends State<MedicineHistoryScreen>
    with SingleTickerProviderStateMixin {
  bool _isLoading = true;
  bool _isFilterLoading = false;
  bool _isFiltered = false;
  bool _isSharing = false;
  String _selectedMedicine = '';
  String _selectedFormat = '';
  String _dateRangeText = '';

  List<Map<String, dynamic>> _historyItems = [];

  List<Map<String, dynamic>> _medicineOptions = [];

  String? _selectedMedicineId;

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.08), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: Curves.easeOutCubic,
          ),
        );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }

      _fetchData();
    });
  }

  Future<void> _fetchData() async {
    final provider = context.read<MedicineHistoryProvider>();

    await Future.wait([
      provider.fetchHistory(format: 'daily'),
      provider.fetchMedicineOptions(),
      Future.delayed(const Duration(milliseconds: 600)),
    ]);

    if (!mounted) {
      return;
    }

    setState(() {
      _historyItems = provider.historyItems;
      _medicineOptions = provider.medicineOptions;
      _isLoading = false;
    });
  }

  Future<void> _sharePdfReport() async {
    if (_isSharing) {
      return;
    }

    setState(() {
      _isSharing = true;
    });

    try {
      String apiFormat;

      switch (_selectedFormat) {
        case 'Harian':
          apiFormat = 'daily';
          break;

        case 'Mingguan':
          apiFormat = 'weekly';
          break;

        case 'Bulanan':
          apiFormat = 'monthly';
          break;

        default:
          apiFormat = 'daily';
      }

      final provider = context.read<MedicineHistoryProvider>();

      final Uint8List pdfBytes = await provider.exportPdf(
        medicineId: _selectedMedicineId,
        format: apiFormat,
      );

      await Printing.sharePdf(bytes: pdfBytes, filename: 'Riwayat_Obat.pdf');
    } catch (e) {
      if (!mounted) {
        return;
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSharing = false;
        });
      }
    }
  }

  Future<void> _filterMedicine() async {
    final result = await showDialog<Map<String, String>>(
      context: context,
      barrierDismissible: true,
      builder: (_) => CustomDialogHistory(
        initialMedicine: _selectedMedicine,
        initialFormat: _selectedFormat,
        medicines: _medicineOptions,
      ),
    );

    if (result == null) {
      return;
    }

    final medicineId = result['medicineId'];
    final medicineName = result['medicine'];
    final format = result['format'];

    if (medicineName == null ||
        medicineName.isEmpty ||
        format == null ||
        format.isEmpty) {
      return;
    }

    String apiFormat;

    switch (format) {
      case 'Harian':
        apiFormat = 'daily';
        break;

      case 'Mingguan':
        apiFormat = 'weekly';
        break;

      case 'Bulanan':
        apiFormat = 'monthly';
        break;

      default:
        apiFormat = 'daily';
    }

    setState(() {
      _isFilterLoading = true;
      _isFiltered = true;
      _selectedMedicine = medicineName;
      _selectedMedicineId = medicineId;
      _selectedFormat = format;
    });

    try {
      // ignore: use_build_context_synchronously
      final provider = context.read<MedicineHistoryProvider>();

      await Future.wait([
        provider.fetchHistory(medicineId: medicineId, format: apiFormat),
        Future.delayed(const Duration(milliseconds: 300)),
      ]);

      if (!mounted) {
        return;
      }

      setState(() {
        _historyItems = provider.historyItems;

        final period = provider.period;

        if (period != null) {
          final start = period['start_date']?.toString() ?? '';
          final end = period['end_date']?.toString() ?? '';

          if (start.isNotEmpty && end.isNotEmpty) {
            _dateRangeText = _formatDateRange(start, end);
          } else {
            _dateRangeText = '';
          }
        }

        _isFilterLoading = false;
      });

      _animationController.forward(from: 0);
    } catch (e) {
      if (!mounted) {
        return;
      }

      setState(() {
        _isFilterLoading = false;
      });
    }
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
        body: Column(
          children: [
            _buildHeader(context, isLoading: _isLoading),
            Expanded(
              child: _buildContent(
                context: context,
                isLoading: _isLoading,
                filterLoading: _isFilterLoading,
                filterMedicine: _filterMedicine,
                onShare: _sharePdfReport,
                isFiltered: _isFiltered,
                formatText: _selectedFormat,
                dateRangeText: _dateRangeText,
                historyItems: _historyItems,
                fadeAnimation: _fadeAnimation,
                slideAnimation: _slideAnimation,
                animationController: _animationController,
              ),
            ),
          ],
        ),
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
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: SafeArea(
        bottom: false,
        child: Row(
          children: [
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
            const SizedBox(width: 14),
            if (isLoading)
              Shimmer.fromColors(
                baseColor: AppColors.accent,
                highlightColor: AppColors.primary,
                child: Container(
                  width: 160,
                  height: 24,
                  decoration: BoxDecoration(
                    color: AppColors.accent,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              )
            else
              Text(
                'Riwayat Obat',
                style: AppTextStyles.titleLarge.copyWith(
                  color: AppColors.textWhite,
                ),
              ),
            const Spacer(),
          ],
        ),
      ),
    ),
  );
}

Widget _buildContent({
  required BuildContext context,
  required bool isLoading,
  required bool filterLoading,
  required VoidCallback filterMedicine,
  required VoidCallback onShare,
  required bool isFiltered,
  required String formatText,
  required String dateRangeText,
  required List<Map<String, dynamic>> historyItems,
  required Animation<double> fadeAnimation,
  required Animation<Offset> slideAnimation,
  required AnimationController animationController,
}) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: isFiltered ? 20 : 25),
        Row(
          children: [
            (isLoading || filterLoading)
                ? Shimmer.fromColors(
                    baseColor: AppColors.surfaceSecondary,
                    highlightColor: AppColors.surfaceCool,
                    child: Container(
                      height: 38,
                      width: 90,
                      decoration: BoxDecoration(
                        color: AppColors.surfacePrimary,
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  )
                : InkWell(
                    focusColor: Colors.transparent,
                    hoverColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    splashColor: Colors.transparent,
                    onTap: filterMedicine,
                    child: Container(
                      height: 38,
                      decoration: BoxDecoration(
                        color: AppColors.surfaceAccent,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          children: [
                            Image.asset(
                              icFilter,
                              height: 10,
                              color: AppColors.primary,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              'Filter',
                              style: AppTextStyles.bodyMedium.copyWith(
                                fontWeight: FontWeight.bold,
                                color: AppColors.primary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

            if (!isLoading && !filterLoading && isFiltered) ...[
              const SizedBox(width: 10),
              FadeTransition(
                opacity: fadeAnimation,
                child: SlideTransition(
                  position: slideAnimation,
                  child: Row(
                    children: [
                      InkWell(
                        focusColor: Colors.transparent,
                        hoverColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        splashColor: Colors.transparent,
                        onTap: onShare,
                        child: Container(
                          height: 38,
                          width: 44,
                          decoration: BoxDecoration(
                            color: AppColors.surfaceAccent,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(11),
                            child: Image.asset(
                              icShare,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: FadeTransition(
                  opacity: fadeAnimation,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'Status $formatText',
                        style: AppTextStyles.bodyLarge,
                      ),
                      Text(
                        dateRangeText,
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
        if (!isLoading && !filterLoading && isFiltered) ...[
          const SizedBox(height: 13),

          if (historyItems.isEmpty)
            Expanded(
              child: Center(
                child: Text(
                  'Tidak ada riwayat obat.',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
            )
          else
            Expanded(
              child: _buildListHistory(historyItems, animationController),
            ),
        ],
      ],
    ),
  );
}

Widget _buildListHistory(
  List<Map<String, dynamic>> items,
  AnimationController controller,
) {
  final Map<String, List<Map<String, dynamic>>> groupedItems = {};

  for (final item in items) {
    final date = item['date']?.toString() ?? '';

    groupedItems.putIfAbsent(date, () => []);
    groupedItems[date]!.add(item);
  }

  final groupedEntries = groupedItems.entries.toList();

  groupedEntries.sort((a, b) {
    final dateA = DateTime.tryParse(a.key) ?? DateTime(1970);
    final dateB = DateTime.tryParse(b.key) ?? DateTime(1970);
    return dateA.compareTo(dateB);
  });

  return ListView.builder(
    itemCount: groupedEntries.length,
    shrinkWrap: false,
    padding: const EdgeInsets.only(bottom: 26),
    itemBuilder: (context, index) {
      final entry = groupedEntries[index];

      final date = entry.key;
      final dateItems = entry.value;

      final double start = (index * 0.15).clamp(0.0, 0.6);
      final double end = (start + 0.4).clamp(0.0, 1.0);

      final itemFade = CurvedAnimation(
        parent: controller,
        curve: Interval(start, end, curve: Curves.easeOut),
      );

      final itemSlide =
          Tween<Offset>(begin: const Offset(0, 0.12), end: Offset.zero).animate(
            CurvedAnimation(
              parent: controller,
              curve: Interval(start, end, curve: Curves.easeOutCubic),
            ),
          );

      return Padding(
        padding: EdgeInsets.only(top: index == 0 ? 13 : 0),
        child: FadeTransition(
          opacity: itemFade,
          child: SlideTransition(
            position: itemSlide,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(_formatDate(date), style: AppTextStyles.bodyLarge),

                const SizedBox(height: 12),

                ...dateItems.map(
                  (data) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: CustomHistoryCard(
                      time: data['time']?.toString() ?? '-',
                      image: _medicineImage(data['dosage_unit']?.toString()),
                      name: data['name']?.toString() ?? '-',
                      dosage: _formatDosage(
                        data['dosage'],
                        data['dosage_unit'],
                      ),
                      isTaken: data['status'] == 'taken',
                      isSkipped: data['status'] == 'skipped',
                      isMissed: data['status'] == 'missed',
                      isReschedule: data['status'] == 'rescheduled',
                      imgStatus: _statusImage(data['status']?.toString()),
                      statusText: _statusText(data['status']?.toString()),
                    ),
                  ),
                ),

                const SizedBox(height: 8),
              ],
            ),
          ),
        ),
      );
    },
  );
}

Widget _medicineImage(String? imageType) {
  switch (imageType?.toLowerCase().trim()) {
    case 'kapsul':
      return Image.asset(imgKapsul, width: 30);

    case 'kaplet':
      return Image.asset(imgKaplet, width: 30);

    case 'tablet':
    default:
      return Image.asset(imgTablet, width: 30);
  }
}

Widget _statusImage(String? status) {
  switch (status) {
    case 'taken':
      return Image.asset(imgTaken, width: 12);

    case 'skipped':
      return Image.asset(imgSkipped, width: 12);

    case 'missed':
      return Image.asset(imgMissed, width: 12);

    case 'rescheduled':
      return Image.asset(imgReschedule, width: 12);

    default:
      return const SizedBox.shrink();
  }
}

String _statusText(String? status) {
  switch (status) {
    case 'taken':
      return 'Diminum';

    case 'skipped':
      return 'Dilewati';

    case 'missed':
      return 'Terlewatkan';

    case 'rescheduled':
      return 'Dijadwalkan ulang';

    default:
      return '-';
  }
}

String _formatDate(String? dateString) {
  if (dateString == null || dateString.isEmpty) {
    return '-';
  }

  try {
    final date = DateTime.parse(dateString);

    const months = [
      'Januari',
      'Februari',
      'Maret',
      'April',
      'Mei',
      'Juni',
      'Juli',
      'Agustus',
      'September',
      'Oktober',
      'November',
      'Desember',
    ];

    const weekdays = ['Sen', 'Sel', 'Rab', 'Kam', 'Jum', 'Sab', 'Min'];

    return '${weekdays[date.weekday - 1]}, ${date.day} ${months[date.month - 1]}';
  } catch (_) {
    return dateString;
  }
}

String _formatDateRange(String startString, String endString) {
  try {
    final start = DateTime.parse(startString);
    final end = DateTime.parse(endString);

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

    if (start.year == end.year &&
        start.month == end.month &&
        start.day == end.day) {
      return '${start.day} ${months[start.month - 1]} ${start.year}';
    }

    if (start.year == end.year) {
      return '${start.day} ${months[start.month - 1]} - '
          '${end.day} ${months[end.month - 1]} ${end.year}';
    }

    return '${start.day} ${months[start.month - 1]} ${start.year} - '
        '${end.day} ${months[end.month - 1]} ${end.year}';
  } catch (_) {
    return '$startString - $endString';
  }
}

String _formatDosage(dynamic dosage, dynamic dosageUnit) {
  if (dosage == null) {
    return '-';
  }

  final dosageText = dosage.toString();

  if (dosageUnit == null || dosageUnit.toString().trim().isEmpty) {
    return 'Minum $dosageText';
  }

  String unit = dosageUnit.toString().trim();

  unit = unit[0].toUpperCase() + unit.substring(1).toLowerCase();

  return 'Minum $dosageText $unit';
}
