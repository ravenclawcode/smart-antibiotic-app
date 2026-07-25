import 'package:flutter/material.dart';

import '../../utils/app_colors.dart';
import '../../utils/app_text.dart';

class SettingsEditProfilScreen extends StatelessWidget {
  const SettingsEditProfilScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Column(children: [_buildHeader(context)]));
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
