import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:smart_antibiotic/utils/app_assets.dart';

import '../../utils/app_colors.dart';
import '../../utils/app_text.dart';
import '../../utils/custom_input_feedback_form.dart';

class SettingsCommentsAndFeedback extends StatefulWidget {
  const SettingsCommentsAndFeedback({super.key});

  @override
  State<SettingsCommentsAndFeedback> createState() =>
      _SettingsCommentsAndFeedbackState();
}

class _SettingsCommentsAndFeedbackState
    extends State<SettingsCommentsAndFeedback> {
  late TextEditingController feedbackController;

  List<Map<String, String>> feedbacks = [
    {
      'name': 'Syifa',
      'time': '30 July 2026',
      'comment': 'Apakah Amoxicillin aman dikonsumsi bersama makanan?',
      'reply':
          'Ya, Amoxicillin bisa diminum bersama makanan untuk mengurangi gangguan lambung.',
    },
    {
      'name': 'Syifa',
      'time': '31 July 2026',
      'comment': 'Tolong tambahkan materi tentang efek samping Ciprofloxacin',
      'reply': '',
    },
  ];

  @override
  void initState() {
    super.initState();
    feedbackController = TextEditingController();
  }

  @override
  void dispose() {
    feedbackController.dispose();
    super.dispose();
  }

  void _addFeedback() {
    final text = feedbackController.text.trim();
    if (text.isEmpty) return;

    setState(() {
      feedbacks.insert(0, {
        'name': 'Syifa',
        'time': 'Hari ini',
        'comment': text,
        'reply': '',
      });
      feedbackController.clear();
    });

    FocusScope.of(context).unfocus();
  }

  void _deleteFeedback(int index) {
    setState(() {
      feedbacks.removeAt(index);
    });
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
            _buildHeader(context),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      SizedBox(height: 20),
                      CustomInputFeedbackForm(
                        controller: feedbackController,
                        userName: 'Syifa',
                        onSubmit: _addFeedback,
                      ),
                      SizedBox(height: 30),
                      _buildFeedbackList(),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 26),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      height: 115,
      width: double.infinity,
      color: AppColors.primary,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
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
              SizedBox(width: 14),
              Text(
                'Komentar & Masukan',
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

  Widget _buildFeedbackList() {
    if (feedbacks.isEmpty) {
      return Center(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Text(
            'Belum ada komentar atau masukan.',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: feedbacks.length,
      padding: EdgeInsets.zero,
      itemBuilder: (context, index) {
        final list = feedbacks[index];
        final String replyText = list['reply'] ?? '';
        final bool hasReply = replyText.trim().isNotEmpty;

        return Padding(
          padding: EdgeInsets.only(bottom: 16),
          child: Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Color(0xFFE7ECF0)),
            ),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                list['name'] as String,
                                style: AppTextStyles.bodyMedium.copyWith(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                              SizedBox(width: 12),
                              Text(
                                list['time'] as String,
                                style: AppTextStyles.bodySmall.copyWith(
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 8),
                          Text(
                            list['comment'] as String,
                            style: AppTextStyles.bodyMedium.copyWith(
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                    ),
                    InkWell(
                      onTap: () => _deleteFeedback(index),
                      child: Padding(
                        padding: EdgeInsets.all(4.0),
                        child: Image.asset(
                          icDelete,
                          height: 16,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                if (hasReply)
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceAccent,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Admin Smart Antibiotik',
                          style: AppTextStyles.bodyLarge.copyWith(
                            fontSize: 17,
                            color: AppColors.primary,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(replyText, style: AppTextStyles.bodyMedium),
                      ],
                    ),
                  )
                else
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Menunggu balasan...',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.textSecondary,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
