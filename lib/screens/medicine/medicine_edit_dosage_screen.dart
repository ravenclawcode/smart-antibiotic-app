import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shimmer/shimmer.dart';

import '../../models/medicine_model.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_text.dart';

class MedicineEditDosageScreen extends StatefulWidget {
  const MedicineEditDosageScreen({super.key});

  @override
  State<MedicineEditDosageScreen> createState() =>
      _MedicineEditDosageScreenState();
}

class _MedicineEditDosageScreenState extends State<MedicineEditDosageScreen> {
  bool _isLoading = true;

  MedicineModel? _medicine;
  bool _isInitialized = false;

  int? _medicineId;
  int? _scheduleTimeId;
  String? _scheduledDate;

  String? _instruction;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_isInitialized) {
      return;
    }

    _isInitialized = true;

    final arguments = ModalRoute.of(context)?.settings.arguments;

    if (arguments is MedicineModel) {
      _medicine = arguments;
      _medicineId = arguments.id;

      _instruction = arguments.instruction?.trim() ?? '';
    } else if (arguments is Map) {
      final data = Map<String, dynamic>.from(arguments);

      final medicineData = data['medicine'];
      final argumentInstruction = data['instruction'];

      if (medicineData is MedicineModel) {
        _medicine = medicineData;
      } else if (medicineData is Map) {
        _medicine = MedicineModel.fromJson(
          Map<String, dynamic>.from(medicineData),
        );
      }

      _medicineId = int.tryParse(data['medicineId']?.toString() ?? '');

      _scheduleTimeId = int.tryParse(data['scheduleTimeId']?.toString() ?? '');

      _scheduledDate = data['scheduledDate']?.toString();

      if (argumentInstruction != null) {
        _instruction = argumentInstruction.toString().trim();
      } else {
        _instruction = _medicine?.instruction?.trim() ?? '';
      }
    }
  }

  Future<void> _fetchData() async {
    await Future.delayed(const Duration(milliseconds: 600));

    if (mounted) {
      setState(() {
        _isLoading = false;
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

            const SizedBox(height: 20),

            _isLoading
                ? _buildShimmerContent()
                : _buildContent(
                    context,
                    _medicine,
                    _medicineId,
                    _scheduleTimeId,
                    _scheduledDate,
                    _instruction,
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
                  width: 60,
                  height: 22,
                  decoration: BoxDecoration(
                    color: AppColors.accent,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              )
            else
              Text(
                'Dosis',
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
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20),
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFE7ECF0)),
      ),
      child: Shimmer.fromColors(
        baseColor: AppColors.surfaceSecondary,
        highlightColor: AppColors.surfaceCool,
        child: Column(
          children: [
            const SizedBox(height: 6),

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
                  width: 14,
                  height: 14,
                  margin: const EdgeInsets.only(right: 10),
                  decoration: BoxDecoration(
                    color: AppColors.surfacePrimary,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 4),

            const Divider(color: Color(0xFFE7ECF0)),

            const SizedBox(height: 4),

            Row(
              children: [
                const SizedBox(width: 10),

                Container(
                  width: 100,
                  height: 20,
                  decoration: BoxDecoration(
                    color: AppColors.surfacePrimary,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),

                const Spacer(),

                Container(
                  width: 14,
                  height: 14,
                  margin: const EdgeInsets.only(right: 10),
                  decoration: BoxDecoration(
                    color: AppColors.surfacePrimary,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 6),
          ],
        ),
      ),
    ),
  );
}

Widget _buildContent(
  BuildContext context,
  MedicineModel? medicine,
  int? medicineId,
  int? scheduleTimeId,
  String? scheduledDate,
  String? instruction,
) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20),
    child: Column(
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: const Color(0xFFE7ECF0)),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
          child: _buildOptionMenu(
            context,
            medicine,
            medicineId,
            scheduleTimeId,
            scheduledDate,
            instruction,
          ),
        ),
      ],
    ),
  );
}

Widget _buildOptionMenu(
  BuildContext context,
  MedicineModel? medicine,
  int? medicineId,
  int? scheduleTimeId,
  String? scheduledDate,
  String? instruction,
) {
  final item = [
    {'title': 'Jumlah Dosis', 'route': '/medicine-edit-dose-amount'},
    {'title': 'Instruksi', 'route': '/medicine-edit-instruction'},
  ];

  return ListView.builder(
    shrinkWrap: true,
    physics: const NeverScrollableScrollPhysics(),
    itemCount: item.length,
    padding: EdgeInsets.zero,
    itemBuilder: (context, index) {
      final menu = item[index];

      final bool isLastItem = index == item.length - 1;

      return InkWell(
        focusColor: Colors.transparent,
        hoverColor: Colors.transparent,
        highlightColor: Colors.transparent,
        splashColor: Colors.transparent,
        overlayColor: WidgetStateProperty.all(Colors.transparent),

        onTap: () async {
          final result = await Navigator.pushNamed(
            context,
            menu['route'] as String,
            arguments: {
              'medicine': medicine,
              'medicineId': medicineId,
              'scheduleTimeId': scheduleTimeId,
              'scheduledDate': scheduledDate,
              'instruction': instruction,
            },
          );

          if (result != null && context.mounted) {
            Navigator.of(context).pop(result);
          }
        },

        child: Padding(
          padding: EdgeInsets.fromLTRB(2, 6, 2, isLastItem ? 8 : 0),
          child: Column(
            children: [
              Row(
                children: [
                  const SizedBox(width: 10),

                  Expanded(
                    child: Text(
                      menu['title'] as String,
                      style: AppTextStyles.bodyMedium.copyWith(fontSize: 18),
                    ),
                  ),

                  const SizedBox(width: 20),

                  const Padding(
                    padding: EdgeInsets.only(right: 10),
                    child: Icon(Icons.arrow_forward_ios_rounded, size: 14),
                  ),
                ],
              ),

              if (!isLastItem) ...[
                const SizedBox(height: 4),

                const Divider(color: Color(0xFFE7ECF0)),
              ],
            ],
          ),
        ),
      );
    },
  );
}
