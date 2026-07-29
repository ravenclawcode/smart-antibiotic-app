import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../utils/app_colors.dart';
import '../../utils/app_text.dart';

class EducationAntibiotikDetailScreen extends StatefulWidget {
  const EducationAntibiotikDetailScreen({super.key});

  @override
  State<EducationAntibiotikDetailScreen> createState() =>
      _EducationAntibiotikDetailScreenState();
}

class _EducationAntibiotikDetailScreenState
    extends State<EducationAntibiotikDetailScreen> {
  String selectedCategory = 'Ringkasan';

  final ScrollController _scrollController = ScrollController();
  final Map<String, GlobalKey> _sectionKeys = {};

  final List<Map<String, String>> _items = [
    {
      'title': 'Ringkasan',
      'description':
          'Amoxicillin adalah antibiotik golongan penisilin yang digunakan untuk mengobati infeksi yang disebabkan oleh bakteri. Obat ini bekerja dengan menghentikan pertumbuhan bakteri sehingga infeksi dapat sembuh.',
    },
    {
      'title': 'Indikasi',
      'description':
          'Amoxicillin digunakan untuk mengatasi berbagai infeksi bakteri, seperti:\n• Infeksi tenggorokan\n• Infeksi telinga\n• Infeksi sinus\n• Infeksi saluran pernapasan\n• Infeksi saluran kemih\n• Infeksi kulit dan jaringan lunak\n• Infeksi gigi\n• Terapi infeksi Helicobacter pylori.',
    },
    {
      'title': 'Mekanisme',
      'description':
          'Amoxicillin bekerja dengan menghambat pembentukan dinding sel bakteri.\n\nAkibatnya:\n• Dinding sel bakteri menjadi lemah\n• Bakteri pecah dan mati\n• Infeksi dapat dikendalikan oleh sistem kekebalan tubuh',
    },
    {
      'title': 'Dosis',
      'description':
          'Dosis harus mengikuti resep dokter.\n\nDewasa\n• 250–500 mg setiap 8 jam, atau\n• 500–875 mg setiap 12 jam.\n\nAnak-anak\n• Dosis dihitung berdasarkan berat badan, umumnya 20–45 mg/kgBB per hari, dibagi menjadi 2–3 kali pemberian.',
    },
    {
      'title': 'Video',
      'description': 'Cara Kerja Amoxicillin dan Penggunaan yang Benar',
    },
  ];

  @override
  void initState() {
    super.initState();
    for (var item in _items) {
      _sectionKeys[item['title']!] = GlobalKey();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToSection(String category) {
    final key = _sectionKeys[category];
    if (key != null && key.currentContext != null) {
      Scrollable.ensureVisible(
        key.currentContext!,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        alignment: 0.0,
      );
    }
  }

  void onCategorySelected(String category) {
    setState(() {
      selectedCategory = category;
    });
    _scrollToSection(category);
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
      child: Scaffold(
        body: Column(
          children: [
            _buildHeader(context, selectedCategory, onCategorySelected),
            Expanded(
              child: _buildContent(
                scrollController: _scrollController,
                items: _items,
                sectionKeys: _sectionKeys,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget _buildHeader(
  BuildContext context,
  String selectedCategory,
  ValueChanged<String> onCategorySelected,
) {
  return Container(
    height: 164,
    width: double.infinity,
    color: AppColors.primary,
    child: SafeArea(
      bottom: false,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
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
                SizedBox(width: 14),
                Text(
                  'Amoxicillin',
                  style: AppTextStyles.titleLarge.copyWith(
                    color: AppColors.textWhite,
                  ),
                ),
                Spacer(),
              ],
            ),
          ),
          SizedBox(height: 16),
          _buildTabBar(selectedCategory, onCategorySelected),
          SizedBox(height: 4),
        ],
      ),
    ),
  );
}

Widget _buildTabBar(
  String selectedCategory,
  ValueChanged<String> onCategorySelected,
) {
  final List item = ['Ringkasan', 'Indikasi', 'Mekanisme', 'Dosis', 'Video'];

  return SizedBox(
    height: 38,
    child: ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 20),
      scrollDirection: Axis.horizontal,
      itemCount: item.length,
      itemBuilder: (context, index) {
        final poin = item[index];
        final isSelected = selectedCategory == poin;
        return InkWell(
          focusColor: Colors.transparent,
          hoverColor: Colors.transparent,
          highlightColor: Colors.transparent,
          splashColor: Colors.transparent,
          onTap: () => onCategorySelected(poin),
          child: Container(
            margin: EdgeInsets.only(right: index == item.length - 1 ? 0 : 12),
            padding: EdgeInsets.symmetric(horizontal: 15),
            decoration: BoxDecoration(
              color: isSelected ? AppColors.surfacePrimary : AppColors.accent,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Center(
              child: Text(
                poin,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: isSelected ? AppColors.primary : AppColors.textWhite,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ),
          ),
        );
      },
    ),
  );
}

Widget _buildContent({
  required ScrollController scrollController,
  required List<Map<String, String>> items,
  required Map<String, GlobalKey> sectionKeys,
}) {
  return SingleChildScrollView(
    controller: scrollController,
    child: Column(
      children: [
        ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          padding: EdgeInsets.zero,
          itemCount: items.length,
          itemBuilder: (context, index) {
            final poin = items[index];
            final title = poin['title']!;
            final String rawDescription = poin['description']!;
            final List<String> lines = rawDescription.split('\n');

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  key: sectionKeys[title],
                  padding: EdgeInsets.only(top: 20),
                  child: Container(
                    height: 36,
                    width: double.infinity,
                    color: AppColors.surfaceAccent,
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Text(title, style: AppTextStyles.bodyLarge),
                    ),
                  ),
                ),
                SizedBox(height: 12),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: lines.asMap().entries.map((entry) {
                      final lineIndex = entry.key;
                      final line = entry.value;
                      final trimmedLine = line.trim();

                      if (trimmedLine.isEmpty) {
                        return SizedBox(height: 8);
                      }

                      if (trimmedLine.startsWith('•')) {
                        final cleanText = trimmedLine.replaceFirst(
                          RegExp(r'^•\s*'),
                          '',
                        );
                        return Padding(
                          padding: EdgeInsets.only(bottom: 4),
                          child: _buildBulletItem(cleanText),
                        );
                      }

                      if (title == 'Ringkasan' && lineIndex == 0) {
                        final firstSpaceIndex = trimmedLine.indexOf(' ');

                        if (firstSpaceIndex != -1) {
                          final firstWord = trimmedLine.substring(
                            0,
                            firstSpaceIndex,
                          );
                          final remainingText = trimmedLine.substring(
                            firstSpaceIndex,
                          );

                          return Padding(
                            padding: EdgeInsets.only(bottom: 4),
                            child: Text.rich(
                              TextSpan(
                                children: [
                                  TextSpan(
                                    text: firstWord,
                                    style: AppTextStyles.bodyMedium.copyWith(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  TextSpan(
                                    text: remainingText,
                                    style: AppTextStyles.bodyMedium.copyWith(
                                      fontSize: 18,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }
                      }

                      return Padding(
                        padding: EdgeInsets.only(bottom: 4),
                        child: Text(
                          line,
                          style: AppTextStyles.bodyMedium.copyWith(
                            fontSize: 18,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                SizedBox(height: 26),
              ],
            );
          },
        ),
      ],
    ),
  );
}

Widget _buildBulletItem(String text) {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Padding(
        padding: EdgeInsets.only(left: 4),
        child: Text(
          '• ',
          style: AppTextStyles.bodyMedium.copyWith(fontSize: 18),
        ),
      ),
      Expanded(
        child: Text(
          text,
          style: AppTextStyles.bodyMedium.copyWith(fontSize: 18, height: 1.4),
        ),
      ),
    ],
  );
}
