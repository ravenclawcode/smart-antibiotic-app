import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:smart_antibiotic/providers/feedback_provider.dart';
import 'package:smart_antibiotic/utils/app_assets.dart';
import 'package:smart_antibiotic/utils/app_colors.dart';
import 'package:smart_antibiotic/utils/app_text.dart';

import '../models/feedback_model.dart';

class CustomFeedbackCard extends StatefulWidget {
  final FeedbackModel feedback;
  final VoidCallback onDelete;

  const CustomFeedbackCard(
    FeedbackProvider provider, {
    super.key,
    required this.feedback,
    required this.onDelete,
  });

  @override
  State<CustomFeedbackCard> createState() => CustomFeedbackCardState();
}

class CustomFeedbackCardState extends State<CustomFeedbackCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnim;
  late Animation<Offset> _slideAnim;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _fadeAnim = CurvedAnimation(parent: _controller, curve: Curves.easeOut);

    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.2),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String _formatCreatedAt(String createdAt) {
    final date = DateTime.tryParse(createdAt);

    if (date == null) {
      return createdAt;
    }

    final localDate = date.toLocal();
    final now = DateTime.now();

    final today = DateTime(now.year, now.month, now.day);

    final dateOnly = DateTime(localDate.year, localDate.month, localDate.day);

    if (dateOnly == today) {
      return DateFormat('HH.mm').format(localDate);
    }

    if (localDate.year == now.year) {
      return DateFormat('d MMM', 'id_ID').format(localDate);
    }

    return DateFormat('d MMM yyyy', 'id_ID').format(localDate);
  }

  @override
  Widget build(BuildContext context) {
    final feedback = widget.feedback;

    return FadeTransition(
      opacity: _fadeAnim,
      child: SlideTransition(
        position: _slideAnim,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFE7ECF0)),
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
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                feedback.name,
                                style: AppTextStyles.bodyMedium.copyWith(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Flexible(
                                child: Text(
                                  _formatCreatedAt(feedback.createdAt),
                                  overflow: TextOverflow.ellipsis,
                                  style: AppTextStyles.bodySmall.copyWith(
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            feedback.message,
                            style: AppTextStyles.bodyMedium.copyWith(
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                    ),
                    InkWell(
                      focusColor: Colors.transparent,
                      hoverColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      splashColor: Colors.transparent,
                      onTap: widget.onDelete,
                      child: Padding(
                        padding: const EdgeInsets.all(4),
                        child: Image.asset(
                          icDelete,
                          height: 16,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                if (feedback.adminReply != null)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
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
                        const SizedBox(height: 4),
                        Text(
                          feedback.adminReply!,
                          style: AppTextStyles.bodyMedium,
                        ),
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
        ),
      ),
    );
  }
}
