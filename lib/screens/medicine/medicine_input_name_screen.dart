import 'package:flutter/material.dart';
import '../../utils/app_text.dart';
import '../../utils/custom_input_add_medicine_form.dart';

class MedicineInputNameScreen extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final String initialValue;
  final ValueChanged<String> onNameChanged;

  const MedicineInputNameScreen({
    super.key,
    required this.formKey,
    required this.initialValue,
    required this.onNameChanged,
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
    _controller.addListener(() {
      widget.onNameChanged(_controller.text);
    });
  }

  @override
  void dispose() {
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
          Text('Nama Obat', style: AppTextStyles.titleLarge),
          const SizedBox(height: 10),
          Form(
            key: widget.formKey,
            child: CustomInputAddMedicineForm(controller: _controller),
          ),
        ],
      ),
    );
  }
}
