import 'package:flutter/material.dart';
import '../../utils/app_text.dart';
import '../../utils/custom_add_medicine_form.dart';

class MedicineInputDosageScreen extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final String initialValue;
  final ValueChanged<String> onNameChanged;

  const MedicineInputDosageScreen({
    super.key,
    required this.formKey,
    required this.initialValue,
    required this.onNameChanged,
  });

  @override
  State<MedicineInputDosageScreen> createState() =>
      _MedicineInputDosageScreenState();
}

class _MedicineInputDosageScreenState extends State<MedicineInputDosageScreen> {
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
          Text('Masukkan Jumlah Dosis', style: AppTextStyles.titleLarge),
          const SizedBox(height: 10),
          Form(
            key: widget.formKey,
            child: CustomAddMedicineForm(
              controller: _controller,
              keyboardType: TextInputType.number,
              hintText: 'Masukkan dosis',
            ),
          ),
        ],
      ),
    );
  }
}
