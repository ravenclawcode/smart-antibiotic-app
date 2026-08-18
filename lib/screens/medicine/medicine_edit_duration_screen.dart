import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shimmer/shimmer.dart';
import 'package:smart_antibiotic/utils/custom_duration_sheet.dart';

import '../../models/medicine_model.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_text.dart';

class MedicineEditDurationScreen extends StatefulWidget {
  const MedicineEditDurationScreen({super.key});

  @override
  State<MedicineEditDurationScreen> createState() =>
      _MedicineEditDurationScreenState();
}

class _MedicineEditDurationScreenState
    extends State<MedicineEditDurationScreen> {
  DateTime? startDate;
  DateTime? endDate;
  bool isInitialized = false;
  bool _isLoading = true;
  MedicineModel? _medicine;

  @override
  void initState() {
    super.initState();
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

  void _saveDuration() {
    if (_medicine == null) {
      Navigator.pop(context);
      return;
    }

    final updatedMedicine = _medicine!.copyWith(
      startDate: startDate?.toIso8601String(),
      endDate: endDate?.toIso8601String(),
    );

    Navigator.pop(context, updatedMedicine);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (isInitialized) {
      return;
    }

    isInitialized = true;

    final arguments = ModalRoute.of(context)?.settings.arguments;

    MedicineModel? medicine;

    if (arguments is MedicineModel) {
      medicine = arguments;
    } else if (arguments is Map<String, dynamic>) {
      medicine = MedicineModel.fromJson(arguments);
    } else if (arguments is Map) {
      medicine = MedicineModel.fromJson(Map<String, dynamic>.from(arguments));
    }

    _medicine = medicine;

    startDate = medicine?.startDate != null
        ? DateTime.tryParse(medicine!.startDate!)
        : null;

    endDate = medicine?.endDate != null
        ? DateTime.tryParse(medicine!.endDate!)
        : null;
  }

  String _formatDate(DateTime? date) {
    if (date == null) return 'Tidak ada';
    final months = [
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
    return '${date.day} ${months[date.month - 1]}, ${date.year}';
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
            _buildHeader(context, isLoading: _isLoading, onSave: _saveDuration),
            const SizedBox(height: 20),
            Expanded(
              child: _isLoading
                  ? _buildShimmerContent()
                  : _buildContent(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(children: [_buildOptionMenu(context)]),
    );
  }

  Widget _buildOptionMenu(BuildContext context) {
    final item = [
      {
        'title': 'Tanggal Mulai',
        'date': _formatDate(startDate),
        'rawDate': startDate,
        'isStart': true,
      },
      {
        'title': 'Tanggal Selesai',
        'date': _formatDate(endDate),
        'rawDate': endDate,
        'isStart': false,
      },
    ];

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: item.length,
      padding: EdgeInsets.zero,
      itemBuilder: (context, index) {
        final menu = item[index];
        final bool isLastItem = index == item.length - 1;
        final String title = menu['title'] as String;
        final DateTime? rawDate = menu['rawDate'] as DateTime?;
        final bool isStart = menu['isStart'] as bool;

        return Padding(
          padding: EdgeInsets.fromLTRB(2, 2, 2, isLastItem ? 8 : 0),
          child: Column(
            children: [
              Row(
                children: [
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: AppTextStyles.bodyMedium.copyWith(
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 20),
                  InkWell(
                    focusColor: Colors.transparent,
                    hoverColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    splashColor: Colors.transparent,
                    overlayColor: WidgetStateProperty.all(Colors.transparent),
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                        builder: (context) => CustomDurationSheet(
                          title: title,
                          initialDate: rawDate ?? DateTime.now(),
                          onSave: (newDate) {
                            setState(() {
                              if (isStart) {
                                startDate = newDate;
                              } else {
                                endDate = newDate;
                              }
                            });
                          },
                          onDelete: () {
                            setState(() {
                              if (isStart) {
                                startDate = null;
                              } else {
                                endDate = null;
                              }
                            });
                          },
                        ),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceAccent,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        menu['date'] as String,
                        style: AppTextStyles.bodyMedium.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              if (!isLastItem) ...[
                const SizedBox(height: 4),
                const Divider(color: Color(0xFFE7ECF0)),
              ],
            ],
          ),
        );
      },
    );
  }
}

Widget _buildHeader(
  BuildContext context, {
  required bool isLoading,
  required VoidCallback onSave,
}) {
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
                onTap: onSave,
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
                  width: 80,
                  height: 22,
                  decoration: BoxDecoration(
                    color: AppColors.accent,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              )
            else
              Text(
                'Durasi',
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

Widget _buildShimmerContent() {
  return Shimmer.fromColors(
    baseColor: AppColors.surfaceSecondary,
    highlightColor: AppColors.surfaceCool,
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          SizedBox(height: 10),
          Row(
            children: [
              const SizedBox(width: 10),
              Container(
                width: 120,
                height: 20,
                decoration: BoxDecoration(
                  color: AppColors.surfacePrimary,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              const Spacer(),
              Container(
                width: 110,
                height: 32,
                decoration: BoxDecoration(
                  color: AppColors.surfacePrimary,
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Container(height: 1, color: AppColors.surfacePrimary),
          const SizedBox(height: 8),
          Row(
            children: [
              const SizedBox(width: 10),
              Container(
                width: 130,
                height: 20,
                decoration: BoxDecoration(
                  color: AppColors.surfacePrimary,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              const Spacer(),
              Container(
                width: 110,
                height: 32,
                decoration: BoxDecoration(
                  color: AppColors.surfacePrimary,
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}
