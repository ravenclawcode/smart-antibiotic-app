import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:smart_antibiotic/screens/home/home_screen.dart';
import 'package:smart_antibiotic/screens/medicine/medicine_screen.dart';

import '../utils/app_assets.dart';
import '../utils/app_colors.dart';
import '../utils/app_text.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int selectedIndex = 0;

  void onNavItemSelected(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  Color onIconSelected(int index) {
    return selectedIndex == index ? AppColors.primary : AppColors.textMuted;
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> screens = [HomeScreen(), MedicineScreen()];

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
      child: Scaffold(
        body: IndexedStack(index: selectedIndex, children: screens),
        bottomNavigationBar: Theme(
          data: Theme.of(context).copyWith(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            hoverColor: Colors.transparent,
          ),
          child: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            currentIndex: selectedIndex,
            onTap: onNavItemSelected,
            selectedLabelStyle: AppTextStyles.bodySmall.copyWith(
              height: 2.5,
              fontWeight: FontWeight.bold,
            ),
            unselectedLabelStyle: AppTextStyles.bodySmall.copyWith(
              height: 2.5,
              fontWeight: FontWeight.normal,
            ),
            selectedItemColor: AppColors.primary,
            unselectedItemColor: AppColors.textMuted,
            elevation: 1,
            items: [
              BottomNavigationBarItem(
                icon: Padding(
                  padding: const EdgeInsets.only(top: 5),
                  child: Image.asset(
                    icHome,
                    color: onIconSelected(0),
                    height: 22,
                  ),
                ),
                label: 'Beranda',
              ),
              BottomNavigationBarItem(
                icon: Padding(
                  padding: const EdgeInsets.only(top: 5),
                  child: Image.asset(
                    icMedicine,
                    color: onIconSelected(1),
                    height: 22,
                  ),
                ),
                label: 'Obat',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
