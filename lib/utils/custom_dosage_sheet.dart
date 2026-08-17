import 'package:flutter/cupertino.dart';
import 'package:smart_antibiotic/utils/app_colors.dart';
import 'package:smart_antibiotic/utils/app_text.dart';
import 'package:smart_antibiotic/utils/custom_base_bottom_sheet.dart';

class CustomDosageSheet extends StatefulWidget {
  final String initialUnit;
  final Function(String selectedUnit) onSelect;

  const CustomDosageSheet({
    super.key,
    this.initialUnit = 'Tablet',
    required this.onSelect,
  });

  @override
  State<CustomDosageSheet> createState() => _CustomDosageSheetState();
}

class _CustomDosageSheetState extends State<CustomDosageSheet> {
  final List<String> dosageUnits = ['Kapsul', 'Tablet', 'Kaplet'];

  late int selectedIndex;
  late FixedExtentScrollController _scrollController;

  @override
  void initState() {
    super.initState();

    selectedIndex = dosageUnits.indexOf(widget.initialUnit);

    if (selectedIndex == -1) {
      selectedIndex = dosageUnits.indexOf('Tablet');
    }

    _scrollController = FixedExtentScrollController(initialItem: selectedIndex);
  }

  Widget _buildSelectionOverlay() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 130),
      child: Container(
        decoration: const BoxDecoration(
          border: Border(
            top: BorderSide(color: Color(0xFFE7ECF0), width: 1),
            bottom: BorderSide(color: Color(0xFFE7ECF0), width: 1),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CustomBaseBottomSheet(
      title: 'Pilih Bentuk Obat',
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 12),

          SizedBox(
            height: 150,
            child: CupertinoPicker(
              itemExtent: 50,
              diameterRatio: 10000,
              squeeze: 1.0,
              magnification: 1.0,
              useMagnifier: false,
              scrollController: _scrollController,
              selectionOverlay: _buildSelectionOverlay(),
              onSelectedItemChanged: (index) {
                setState(() {
                  selectedIndex = index;
                });

                widget.onSelect(dosageUnits[index]);
              },

              children: List.generate(dosageUnits.length, (index) {
                final isSelected = selectedIndex == index;

                return Center(
                  child: AnimatedDefaultTextStyle(
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.easeOut,
                    style: AppTextStyles.titleLarge.copyWith(
                      fontWeight: isSelected
                          ? FontWeight.bold
                          : FontWeight.normal,
                      color: isSelected
                          ? AppColors.textPrimary
                          : const Color(0xFFCFD8E0),
                    ),
                    child: Text(dosageUnits[index]),
                  ),
                );
              }),
            ),
          ),

          const SizedBox(height: 16),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
