import 'package:flutter/material.dart';
import 'package:ripple/core/theme/colors.dart';
import 'package:ripple/core/theme/text_styles.dart';
import 'package:ripple/core/utils/constants/assets_helper.dart';
import 'package:ripple/core/utils/constants/constants.dart';
import 'package:ripple/core/utils/constants/spacing.dart';

class AboutAppInfo extends StatelessWidget {
  const AboutAppInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: ColorsManager.primary.withValues(alpha: 0.1),
            border: Border.all(
              color: ColorsManager.primary.withValues(alpha: 0.05),
              width: 2,
            ),
          ),
          child: Image.asset(
            AssetsHelper.logo,
            height: 80,
            width: 80,
          ),
        ),
        verticalSpace16,
        Text(
          "Ripple",
          style: TextStylesManager.bold28.copyWith(
            color: ColorsManager.primary,
            letterSpacing: 1.5,
          ),
        ),
        verticalSpace4,
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: ColorsManager.surfaceContainer,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            "${appTranslation().get('version')} 1.0.0",
            style: TextStylesManager.medium12.copyWith(
              color: ColorsManager.textSecondaryColor,
            ),
          ),
        ),
      ],
    );
  }
}
