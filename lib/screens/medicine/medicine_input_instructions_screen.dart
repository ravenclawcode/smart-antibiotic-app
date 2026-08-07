import 'package:flutter/material.dart';
import '../../utils/app_text.dart';
import '../../utils/custom_add_medicine_form.dart';

class MedicineInputInstructionsScreen extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final String initialValue;
  final ValueChanged<String> onNameChanged;

  const MedicineInputInstructionsScreen({
    super.key,
    required this.formKey,
    required this.initialValue,
    required this.onNameChanged,
  });

  @override
  State<MedicineInputInstructionsScreen> createState() =>
      _MedicineInputInstructionsScreenState();
}

class _MedicineInputInstructionsScreenState
    extends State<MedicineInputInstructionsScreen> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue);
    _controller.addListener(_onTextChanged);
  }

  void _onTextChanged() {
    widget.onNameChanged(_controller.text);
  }

  @override
  void didUpdateWidget(covariant MedicineInputInstructionsScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialValue != oldWidget.initialValue &&
        widget.initialValue != _controller.text) {
      _controller.text = widget.initialValue;
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_onTextChanged);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),
          Text('Tambah Instruksi (Opsional)', style: AppTextStyles.titleLarge),
          const SizedBox(height: 10),
          Form(
            key: widget.formKey,
            child: CustomAddMedicineForm(
              controller: _controller,
              keyboardType: TextInputType.text,
              hintText: 'Ketik di sini...',
            ),
          ),
        ],
      ),
    );
  }
}
