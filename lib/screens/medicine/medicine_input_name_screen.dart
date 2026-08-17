import 'package:flutter/material.dart';
import 'package:smart_antibiotic/models/medicine_catalog_model.dart';

import '../../utils/app_text.dart';
import '../../utils/app_colors.dart';
import '../../utils/custom_input_add_medicine_form.dart';

class MedicineInputNameScreen extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final String initialValue;
  final ValueChanged<String> onNameChanged;

  final List<MedicineCatalogModel> suggestions;
  final bool isLoadingSuggestions;
  final ValueChanged<MedicineCatalogModel> onCatalogSelected;

  const MedicineInputNameScreen({
    super.key,
    required this.formKey,
    required this.initialValue,
    required this.onNameChanged,
    required this.suggestions,
    required this.isLoadingSuggestions,
    required this.onCatalogSelected,
  });

  @override
  State<MedicineInputNameScreen> createState() =>
      _MedicineInputNameScreenState();
}

class _MedicineInputNameScreenState extends State<MedicineInputNameScreen> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();

    _controller = TextEditingController(text: widget.initialValue);
  }

  @override
  void didUpdateWidget(covariant MedicineInputNameScreen oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.initialValue != oldWidget.initialValue &&
        widget.initialValue != _controller.text) {
      _controller.text = widget.initialValue;
      _controller.selection = TextSelection.fromPosition(
        TextPosition(offset: _controller.text.length),
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _selectCatalog(MedicineCatalogModel catalog) {
    _controller.text = catalog.name;

    _controller.selection = TextSelection.fromPosition(
      TextPosition(offset: _controller.text.length),
    );

    widget.onCatalogSelected(catalog);
  }

  @override
  Widget build(BuildContext context) {
    final bool showSuggestions =
        _controller.text.trim().isNotEmpty &&
        (widget.isLoadingSuggestions || widget.suggestions.isNotEmpty);

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),

          Text('Nama Obat', style: AppTextStyles.titleLarge),

          const SizedBox(height: 10),

          Form(
            key: widget.formKey,
            child: CustomInputAddMedicineForm(
              controller: _controller,
              onChanged: widget.onNameChanged,
            ),
          ),

          if (showSuggestions) ...[
            const SizedBox(height: 8),

            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.surfacePrimary,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFE7ECF0)),
              ),
              child: widget.isLoadingSuggestions
                  ? const Padding(
                      padding: EdgeInsets.all(16),
                      child: Center(
                        child: SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      ),
                    )
                  : Column(
                      children: widget.suggestions.map((catalog) {
                        return InkWell(
                          onTap: () {
                            _selectCatalog(catalog);
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 12,
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 42,
                                  height: 42,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFE0EFF7),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child:
                                      catalog.image != null &&
                                          catalog.image!.trim().isNotEmpty
                                      ? ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                          child: Image.network(
                                            catalog.image!,
                                            fit: BoxFit.cover,
                                            errorBuilder:
                                                (context, error, stackTrace) {
                                                  return const Icon(
                                                    Icons.medication_outlined,
                                                    color: AppColors.primary,
                                                  );
                                                },
                                          ),
                                        )
                                      : const Icon(
                                          Icons.medication_outlined,
                                          color: AppColors.primary,
                                        ),
                                ),

                                const SizedBox(width: 12),

                                Expanded(
                                  child: Text(
                                    catalog.name,
                                    style: AppTextStyles.bodyMedium.copyWith(
                                      fontSize: 16,
                                    ),
                                  ),
                                ),

                                const Icon(
                                  Icons.chevron_right_rounded,
                                  color: AppColors.textMuted,
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),
            ),
          ],
        ],
      ),
    );
  }
}
