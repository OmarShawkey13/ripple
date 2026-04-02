import 'package:flutter/material.dart';
import 'package:ripple/core/theme/colors.dart';
import 'package:ripple/core/theme/text_styles.dart';
import 'package:ripple/core/utils/constants/constants.dart';
import 'package:ripple/core/utils/constants/spacing.dart';

class AboutFooter extends StatelessWidget {
  const AboutFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          appTranslation().get('made_with_love'),
          style: TextStylesManager.medium14.copyWith(
            color: ColorsManager.textColor.withValues(alpha: 0.6),
          ),
        ),
        verticalSpace8,
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildSocialIcon(Icons.language_rounded),
            horizontalSpace16,
            _buildSocialIcon(Icons.code_rounded),
            horizontalSpace16,
            _buildSocialIcon(Icons.alternate_email_rounded),
          ],
        ),
      ],
    );
  }

  Widget _buildSocialIcon(IconData icon) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: ColorsManager.surfaceContainer,
      ),
      child: Icon(
        icon,
        size: 18,
        color: ColorsManager.primary,
      ),
    );
  }
}
