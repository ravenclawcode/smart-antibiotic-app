import 'package:flutter/material.dart';
import 'package:smart_antibiotic/utils/app_assets.dart';
import 'package:smart_antibiotic/utils/custom_input_gender_form.dart';

import '../../utils/app_colors.dart';
import '../../utils/app_text.dart';
import '../../utils/custom_button.dart';
import '../../utils/custom_button_off.dart';
import '../../utils/custom_edit_name_form.dart';
import '../../utils/custom_input_age_form.dart';

class SettingsEditProfilScreen extends StatefulWidget {
  final String initialValue;
  final ValueChanged<String> onNameChanged;
  const SettingsEditProfilScreen({
    super.key,
    required this.initialValue,
    required this.onNameChanged,
  });

  @override
  State<SettingsEditProfilScreen> createState() =>
      _SettingsEditProfilScreenState();
}

class _SettingsEditProfilScreenState extends State<SettingsEditProfilScreen> {
  late final TextEditingController _nameController;
  late final TextEditingController _ageController;
  late final TextEditingController _genderController;

  late String _initialName;
  late String _initialAge;
  late String _initialGender;

  bool _isNextEnabled = false;

  @override
  void initState() {
    super.initState();
    _initialName = widget.initialValue;
    _initialAge = '';
    _initialGender = '';

    _nameController = TextEditingController(text: _initialName);
    _ageController = TextEditingController(text: _initialAge);
    _genderController = TextEditingController(text: _initialGender);

    _nameController.addListener(_checkFormChanges);
    _ageController.addListener(_checkFormChanges);
    _genderController.addListener(_checkFormChanges);
  }

  void _checkFormChanges() {
    final bool hasNameChanged = _nameController.text != _initialName;
    final bool hasAgeChanged = _ageController.text != _initialAge;
    final bool hasGenderChanged = _genderController.text != _initialGender;

    final bool isAnyChanged =
        hasNameChanged || hasAgeChanged || hasGenderChanged;

    if (_isNextEnabled != isAnyChanged) {
      setState(() {
        _isNextEnabled = isAnyChanged;
      });
    }
    widget.onNameChanged(_nameController.text);
  }

  @override
  void dispose() {
    _nameController.removeListener(_checkFormChanges);
    _ageController.removeListener(_checkFormChanges);
    _genderController.removeListener(_checkFormChanges);
    _nameController.dispose();
    _ageController.dispose();
    _genderController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          _buildHeader(context),
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight,
                    ),
                    child: IntrinsicHeight(
                      child: Column(
                        children: [
                          const SizedBox(height: 28),
                          _buildContent(
                            _nameController,
                            _ageController,
                            _genderController,
                          ),
                          const Spacer(),
                          _buildActionButton(context, _isNextEnabled),
                          const SizedBox(height: 60),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
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
      padding: EdgeInsets.symmetric(horizontal: 26),
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
            SizedBox(width: 18),
            Text(
              'Edit Profil',
              style: AppTextStyles.titleLarge.copyWith(
                color: AppColors.textWhite,
              ),
            ),
            Spacer(),
          ],
        ),
      ),
    ),
  );
}

Widget _buildContent(
  TextEditingController nameController,
  ageController,
  genderController,
) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 26),
    child: Column(
      children: [
        Container(
          width: 88,
          height: 88,
          decoration: BoxDecoration(
            color: AppColors.surfaceAccent,
            borderRadius: BorderRadiusDirectional.circular(50),
          ),
          child: Padding(
            padding: const EdgeInsets.all(22),
            child: Image.asset(icPerson, color: AppColors.primary),
          ),
        ),
        SizedBox(height: 28),
        Align(
          alignment: AlignmentGeometry.centerLeft,
          child: Text('Nama', style: AppTextStyles.bodyLarge),
        ),
        SizedBox(height: 10),
        CustomEditNameForm(controller: nameController),
        SizedBox(height: 14),
        Align(
          alignment: AlignmentGeometry.centerLeft,
          child: Text('Umur', style: AppTextStyles.bodyLarge),
        ),
        SizedBox(height: 10),
        CustomInputAgeForm(controller: ageController),
        SizedBox(height: 14),
        Align(
          alignment: AlignmentGeometry.centerLeft,
          child: Text('Jenis Kelamin', style: AppTextStyles.bodyLarge),
        ),
        SizedBox(height: 10),
        CustomInputGenderForm(controller: genderController),
      ],
    ),
  );
}

Widget _buildActionButton(BuildContext context, bool isNextEnabled) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20),
    child: isNextEnabled
        ? CustomButton(
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Profil berhasil diperbarui',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.textWhite,
                    ),
                  ),
                ),
              );
              Navigator.pop(context);
            },
            label: 'Simpan Perubahan',
          )
        : CustomButtonOff(label: 'Simpan Perubahan'),
  );
}
