import 'package:flutter/material.dart';
import 'package:ripple/core/theme/colors.dart';
import 'package:ripple/core/theme/text_styles.dart';
import 'package:ripple/core/utils/constants/spacing.dart';

class AboutSection extends StatelessWidget {
  final String title;
  final String content;
  final bool isCenter;

  const AboutSection({
    super.key,
    required this.title,
    required this.content,
    this.isCenter = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: ColorsManager.surfaceContainer.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: ColorsManager.primary.withValues(alpha: 0.1),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: isCenter
            ? CrossAxisAlignment.center
            : CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: isCenter
                ? MainAxisAlignment.center
                : MainAxisAlignment.start,
            children: [
              Container(
                width: 4,
                height: 16,
                decoration: BoxDecoration(
                  color: ColorsManager.primary,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              horizontalSpace8,
              Text(
                title,
                style: TextStylesManager.bold16.copyWith(
                  color: ColorsManager.primary,
                ),
              ),
            ],
          ),
          verticalSpace12,
          Text(
            content,
            textAlign: isCenter ? TextAlign.center : TextAlign.start,
            style: TextStylesManager.regular14.copyWith(
              color: ColorsManager.textColor.withValues(alpha: 0.8),
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}
