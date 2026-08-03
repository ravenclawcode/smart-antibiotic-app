import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../utils/app_colors.dart';
import '../../utils/app_text.dart';
import '../../utils/custom_button.dart';
import '../../utils/custom_button_off.dart';
import '../../utils/custom_input_add_medicine_form.dart';

class MedicineEditNameScreen extends StatefulWidget {
  final ValueChanged<String>? onNameChanged;
  const MedicineEditNameScreen({super.key, this.onNameChanged});

  @override
  State<MedicineEditNameScreen> createState() => _MedicineEditNameScreenState();
}

class _MedicineEditNameScreenState extends State<MedicineEditNameScreen> {
  late final TextEditingController _nameMedicineController;

  String _initialMedicineName = '';
  bool _isNextEnabled = false;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _nameMedicineController = TextEditingController();
    _nameMedicineController.addListener(_checkFormChanges);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInitialized) {
      final arguments = ModalRoute.of(context)?.settings.arguments;
      if (arguments is Map<String, dynamic>) {
        _initialMedicineName = (arguments['name'] as String?) ?? '';
      } else if (arguments is String) {
        _initialMedicineName = arguments;
      }

      _nameMedicineController.text = _initialMedicineName;
      _isInitialized = true;
    }
  }

  void _checkFormChanges() {
    final String currentText = _nameMedicineController.text.trim();
    final bool hasNameChanged =
        currentText != _initialMedicineName && currentText.isNotEmpty;

    if (_isNextEnabled != hasNameChanged) {
      setState(() {
        _isNextEnabled = hasNameChanged;
      });
    }

    if (widget.onNameChanged != null) {
      widget.onNameChanged!(_nameMedicineController.text);
    }
  }

  @override
  void dispose() {
    _nameMedicineController.removeListener(_checkFormChanges);
    _nameMedicineController.dispose();
    super.dispose();
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
            _buildHeader(context),
            const SizedBox(height: 20),
            Expanded(
              child: _buildContent(
                context,
                _isNextEnabled,
                _nameMedicineController,
              ),
            ),
            const SizedBox(height: 60),
          ],
        ),
      ),
    );
  }
}

Widget _buildHeader(BuildContext context) {
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
            Text(
              'Nama Obat',
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

Widget _buildContent(
  BuildContext context,
  bool isNextEnabled,
  TextEditingController nameMedicineController,
) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20),
    child: Column(
      children: [
        CustomInputAddMedicineForm(controller: nameMedicineController),
        const Spacer(),
        _buildActionButton(context, isNextEnabled, nameMedicineController),
      ],
    ),
  );
}

Widget _buildActionButton(
  BuildContext context,
  bool isNextEnabled,
  TextEditingController controller,
) {
  return isNextEnabled
      ? CustomButton(
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'Nama obat berhasil diperbarui',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textWhite,
                  ),
                ),
              ),
            );
            Navigator.pop(context, controller.text.trim());
          },
          label: 'Simpan Perubahan',
        )
      : const CustomButtonOff(label: 'Simpan Perubahan');
}
