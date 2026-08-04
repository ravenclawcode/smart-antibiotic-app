import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:shimmer/shimmer.dart';

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
  bool _isFiltered = false;
  bool _isSharing = false;
  String _selectedMedicine = '';
  String _selectedFormat = '';
  String _dateRangeText = '';

  List<Map<String, dynamic>> _historyItems = [];

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

    _fetchData();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _fetchData() async {
    await Future.delayed(const Duration(milliseconds: 600));
    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _filterMedicine() async {
    final result = await showDialog<Map<String, String>>(
      context: context,
      barrierDismissible: true,
      builder: (_) => CustomDialogHistory(
        initialMedicine: _selectedMedicine,
        initialFormat: _selectedFormat,
      ),
    );

    if (result != null &&
        result['medicine']!.isNotEmpty &&
        result['format']!.isNotEmpty) {
      setState(() {
        _isFiltered = true;
        _selectedMedicine = result['medicine']!;
        _selectedFormat = result['format']!;

        if (_selectedFormat == 'Harian') {
          _dateRangeText = '28 Juni 2026';
        } else if (_selectedFormat == 'Mingguan') {
          _dateRangeText = '28 Juni - 5 Juli 2026';
        } else if (_selectedFormat == 'Bulanan') {
          _dateRangeText = 'Juni - Juli 2026';
        } else {
          _dateRangeText = '28 Juni - 5 Juli 2026';
        }

        _historyItems = [
          {
            'date': 'Min, 28 Jun',
            'time': '09.00',
            'name': _selectedMedicine,
            'dosage': '1 Tablet',
            'isTaken': true,
            'isSkipped': false,
            'isMissed': false,
            'imgStatus': Image.asset(imgTaken, width: 12),
            'statusText': 'Diminum',
          },
          {
            'date': 'Sen, 29 Jun',
            'time': '16.00',
            'name': _selectedMedicine,
            'dosage': '1 Tablet',
            'isTaken': true,
            'isSkipped': false,
            'isMissed': false,
            'imgStatus': Image.asset(imgTaken, width: 12),
            'statusText': 'Diminum',
          },
          {
            'date': 'Sel, 30 Jun',
            'time': '20.00',
            'name': _selectedMedicine,
            'dosage': '1 Tablet',
            'isTaken': false,
            'isSkipped': true,
            'isMissed': false,
            'imgStatus': Image.asset(imgSkipped, width: 12),
            'statusText': 'Dilewati',
          },
          {
            'date': 'Rab, 1 Juli',
            'time': '09.00',
            'name': _selectedMedicine,
            'dosage': '1 Tablet',
            'isTaken': false,
            'isSkipped': false,
            'isMissed': true,
            'imgStatus': Image.asset(imgMissed, width: 12),
            'statusText': 'Terlewatkan',
          },
        ];
      });

      _animationController.forward(from: 0.0);
    }
  }

  Future<void> _sharePdfReport() async {
    if (_isSharing) return;

    setState(() {
      _isSharing = true;
    });

    try {
      final pdf = pw.Document();

      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4,
          build: (pw.Context context) {
            return pw.Padding(
              padding: const pw.EdgeInsets.all(24),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text(
                    'Laporan Riwayat Obat',
                    style: pw.TextStyle(
                      fontSize: 22,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                  pw.SizedBox(height: 8),
                  pw.Text('Obat: $_selectedMedicine'),
                  pw.Text('Format: Status $_selectedFormat ($_dateRangeText)'),
                  pw.Divider(height: 24),
                  pw.TableHelper.fromTextArray(
                    headers: [
                      'Tanggal',
                      'Waktu',
                      'Nama Obat',
                      'Dosis',
                      'Status',
                    ],
                    data: _historyItems.map((item) {
                      return [
                        item['date'],
                        item['time'],
                        item['name'],
                        item['dosage'],
                        item['statusText'],
                      ];
                    }).toList(),
                  ),
                ],
              ),
            );
          },
        ),
      );

      await Printing.sharePdf(
        bytes: await pdf.save(),
        filename:
            'Smart_Antibiotik_${DateTime.now().millisecondsSinceEpoch}.pdf',
      );
    } finally {
      if (mounted) {
        setState(() {
          _isSharing = false;
        });
      }
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
        body: SingleChildScrollView(
          child: Column(
            children: [
              _buildHeader(context, isLoading: _isLoading),
              _buildContent(
                isLoading: _isLoading,
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
              const SizedBox(height: 26),
            ],
          ),
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
  required bool isLoading,
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
            isLoading
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

            if (!isLoading && isFiltered) ...[
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
        if (!isLoading && isFiltered) ...[
          const SizedBox(height: 26),
          _buildListHistory(historyItems, animationController),
        ],
      ],
    ),
  );
}

Widget _buildListHistory(
  List<Map<String, dynamic>> items,
  AnimationController controller,
) {
  return ListView.builder(
    itemCount: items.length,
    shrinkWrap: true,
    physics: const NeverScrollableScrollPhysics(),
    padding: EdgeInsets.zero,
    itemBuilder: (context, index) {
      final data = items[index];

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

      return FadeTransition(
        opacity: itemFade,
        child: SlideTransition(
          position: itemSlide,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(data['date'], style: AppTextStyles.bodyLarge),
              const SizedBox(height: 12),
              CustomHistoryCard(
                time: data['time'],
                image: Image.asset(imgTablet, width: 30),
                name: data['name'],
                dosage: data['dosage'],
                isTaken: data['isTaken'],
                isSkipped: data['isSkipped'],
                isMissed: data['isMissed'],
                imgStatus: data['imgStatus'],
                statusText: data['statusText'],
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      );
    },
  );
}
