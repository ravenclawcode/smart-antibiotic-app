import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shimmer/shimmer.dart';
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
  bool _isLoading = true;

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

    _fetchData();
  }

  Future<void> _fetchData() async {
    await Future.delayed(const Duration(milliseconds: 600));
    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
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
            Expanded(
              child: _isLoading
                  ? _buildShimmerContent()
                  : LayoutBuilder(
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
      ),
    );
  }

  Widget _buildShimmerContent() {
    return Shimmer.fromColors(
      baseColor: AppColors.surfaceSecondary,
      highlightColor: AppColors.surfaceCool,
      child: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: IntrinsicHeight(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 26),
                  child: Column(
                    children: [
                      const SizedBox(height: 28),
                      Container(
                        width: 88,
                        height: 88,
                        decoration: const BoxDecoration(
                          color: AppColors.surfacePrimary,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(height: 28),
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: SkeletonBox(width: 60, height: 18),
                      ),
                      const SizedBox(height: 10),
                      const SkeletonBox(
                        width: double.infinity,
                        height: 70,
                        radius: 16,
                      ),
                      const SizedBox(height: 18),
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: SkeletonBox(width: 50, height: 18),
                      ),
                      const SizedBox(height: 10),
                      const SkeletonBox(
                        width: double.infinity,
                        height: 70,
                        radius: 16,
                      ),
                      const SizedBox(height: 18),
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: SkeletonBox(width: 100, height: 18),
                      ),
                      const SizedBox(height: 10),
                      const SkeletonBox(
                        width: double.infinity,
                        height: 70,
                        radius: 16,
                      ),
                      const Spacer(),
                      const SkeletonBox(
                        width: double.infinity,
                        height: 70,
                        radius: 50,
                      ),
                      const SizedBox(height: 60),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class SkeletonBox extends StatelessWidget {
  final double width;
  final double height;
  final double radius;

  const SkeletonBox({
    super.key,
    required this.width,
    required this.height,
    this.radius = 4,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: AppColors.surfacePrimary,
        borderRadius: BorderRadius.circular(radius),
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
                  width: 120,
                  height: 22,
                  decoration: BoxDecoration(
                    color: AppColors.accent,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              )
            else
              Text(
                'Edit Profil',
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
  TextEditingController nameController,
  TextEditingController ageController,
  TextEditingController genderController,
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
        const SizedBox(height: 28),
        Align(
          alignment: Alignment.centerLeft,
          child: Text('Nama', style: AppTextStyles.bodyLarge),
        ),
        const SizedBox(height: 10),
        CustomEditNameForm(controller: nameController),
        const SizedBox(height: 14),
        Align(
          alignment: Alignment.centerLeft,
          child: Text('Umur', style: AppTextStyles.bodyLarge),
        ),
        const SizedBox(height: 10),
        CustomInputAgeForm(controller: ageController),
        const SizedBox(height: 14),
        Align(
          alignment: Alignment.centerLeft,
          child: Text('Jenis Kelamin', style: AppTextStyles.bodyLarge),
        ),
        const SizedBox(height: 10),
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
