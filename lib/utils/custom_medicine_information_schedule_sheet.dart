import 'package:flutter/material.dart';
import 'package:smart_antibiotic/utils/custom_dialog_change_hour.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_text.dart';

class CustomMedicineInformationScheduleSheet extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final String selectedFrequency;
  final String subtitle;
  final List<TimeOfDay> scheduleTimes;
  final Function(int index, TimeOfDay newTime) onSlotTimeChanged;

  const CustomMedicineInformationScheduleSheet({
    super.key,
    required this.formKey,
    this.selectedFrequency = '2 kali sehari',
    this.subtitle = '2 kali sehari',
    this.scheduleTimes = const [],
    required this.onSlotTimeChanged,
  });

  @override
  State<CustomMedicineInformationScheduleSheet> createState() =>
      _CustomMedicineInformationScheduleSheetState();
}

class _CustomMedicineInformationScheduleSheetState
    extends State<CustomMedicineInformationScheduleSheet> {
  String _formatTimeOfDay(TimeOfDay tod) {
    final h = tod.hour.toString().padLeft(2, '0');
    final m = tod.minute.toString().padLeft(2, '0');
    return '$h.$m';
  }

  void _openChangeHourDialog(int index) async {
    if (index < 0 || index >= widget.scheduleTimes.length) return;

    final TimeOfDay? updatedTime = await showDialog<TimeOfDay>(
      context: context,
      builder: (context) {
        return CustomDialogChangeHour(
          slotIndex: index,
          initialTime: widget.scheduleTimes[index],
        );
      },
    );

    if (updatedTime != null) {
      widget.onSlotTimeChanged(index, updatedTime);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),
          Text(
            'Jadwal Minum Obat',
            style: AppTextStyles.titleLarge,
            textAlign: TextAlign.start,
          ),
          const SizedBox(height: 6),
          Text(
            widget.subtitle,
            style: AppTextStyles.bodyMedium.copyWith(
              fontSize: 18,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 20),
          _buildOptionMenu(context),
        ],
      ),
    );
  }

  Widget _buildOptionMenu(BuildContext context) {
    final times = widget.scheduleTimes;

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: times.length,
      padding: EdgeInsets.zero,
      itemBuilder: (context, index) {
        final bool isLastItem = index == times.length - 1;
        final String takeLabel = 'Minum ke-${index + 1}';
        final String formattedTime = _formatTimeOfDay(times[index]);

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
                          takeLabel,
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
                    onTap: () => _openChangeHourDialog(index),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 2,
                        horizontal: 12,
                      ),
                      child: Text(
                        formattedTime,
                        style: AppTextStyles.bodyMedium.copyWith(
                          fontSize: 18,
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
