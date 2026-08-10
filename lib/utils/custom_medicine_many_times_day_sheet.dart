import 'package:flutter/cupertino.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_text.dart';

class CustomMedicineManyTimesDaySheet extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final int initialValue;
  final String selectedFrequency;
  final ValueChanged<String> onNameChanged;

  const CustomMedicineManyTimesDaySheet({
    super.key,
    required this.formKey,
    this.initialValue = 1,
    this.selectedFrequency = '',
    required this.onNameChanged,
  });

  @override
  State<CustomMedicineManyTimesDaySheet> createState() =>
      _CustomMedicineManyTimesDaySheetState();
}

class _CustomMedicineManyTimesDaySheetState
    extends State<CustomMedicineManyTimesDaySheet> {
  late int selectedTimes;
  late List<int> timesList;
  late FixedExtentScrollController _scrollController;
  static const int _loopMultiplier = 1000;

  bool get _isSpecificContext {
    return widget.selectedFrequency != 'Lebih dari 3 kali sehari';
  }

  @override
  void initState() {
    super.initState();
    _initValues();

    final initialIndex = timesList.indexOf(selectedTimes);
    final initialScrollItem =
        (_loopMultiplier * timesList.length) +
        (initialIndex >= 0 ? initialIndex : 0);
    _scrollController = FixedExtentScrollController(
      initialItem: initialScrollItem,
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _notifyParent();
      }
    });
  }

  void _initValues() {
    if (_isSpecificContext) {
      timesList = List.generate(12, (i) => i + 1);
    } else {
      timesList = [4, 5, 6, 7, 8, 9, 10, 11, 12];
    }

    selectedTimes = widget.initialValue;
    if (!timesList.contains(selectedTimes)) {
      selectedTimes = timesList.first;
    }
  }

  @override
  void didUpdateWidget(covariant CustomMedicineManyTimesDaySheet oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedFrequency != widget.selectedFrequency ||
        oldWidget.initialValue != widget.initialValue) {
      if (widget.initialValue != selectedTimes ||
          oldWidget.selectedFrequency != widget.selectedFrequency) {
        _initValues();

        if (_scrollController.hasClients) {
          final targetIndex = timesList.indexOf(selectedTimes);
          final scrollItem =
              (_loopMultiplier * timesList.length) +
              (targetIndex >= 0 ? targetIndex : 0);
          _scrollController.jumpToItem(scrollItem);
        }
      }
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _notifyParent() {
    widget.onNameChanged('$selectedTimes');
  }

  Widget _buildSelectionOverlay() {
    return Container(
      decoration: const BoxDecoration(
        border: Border(
          top: BorderSide(color: Color(0xFFE7ECF0), width: 1),
          bottom: BorderSide(color: Color(0xFFE7ECF0), width: 1),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),
          Text(
            _isSpecificContext
                ? 'Berapa kali Anda minum obat\npada hari yang dipilih?'
                : 'Berapa kali sehari?',
            style: AppTextStyles.titleLarge,
            textAlign: TextAlign.start,
          ),
          if (_isSpecificContext) ...[
            const SizedBox(height: 8),
            Text(
              'Tentukan berapa kali Anda minum obat\ndalam satu hari',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
                fontSize: 18,
              ),
            ),
          ],
          const SizedBox(height: 30),
          SizedBox(
            height: 150,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: 50,
                  child: CupertinoPicker.builder(
                    itemExtent: 50,
                    diameterRatio: 10000,
                    squeeze: 1.0,
                    magnification: 1.0,
                    useMagnifier: false,
                    selectionOverlay: _buildSelectionOverlay(),
                    scrollController: _scrollController,
                    onSelectedItemChanged: (index) {
                      final actualIndex =
                          (index % timesList.length + timesList.length) %
                          timesList.length;
                      setState(() {
                        selectedTimes = timesList[actualIndex];
                      });
                      _notifyParent();
                    },
                    childCount: null,
                    itemBuilder: (context, index) {
                      final actualIndex =
                          (index % timesList.length + timesList.length) %
                          timesList.length;
                      final number = timesList[actualIndex];
                      final isSelected = selectedTimes == number;

                      return Center(
                        child: AnimatedDefaultTextStyle(
                          duration: const Duration(milliseconds: 200),
                          curve: Curves.easeOut,
                          style: AppTextStyles.titleLarge.copyWith(
                            fontWeight: FontWeight.bold,
                            color: isSelected
                                ? AppColors.textPrimary
                                : const Color(0xFFCFD8E0),
                          ),
                          child: Text('$number'),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 20),
                Text(
                  _isSpecificContext ? 'kali / hari' : 'kali',
                  style: AppTextStyles.titleLarge.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
