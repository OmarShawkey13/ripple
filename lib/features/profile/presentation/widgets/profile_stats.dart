import 'package:flutter/material.dart';
import 'package:ripple/core/models/user_model.dart';
import 'package:ripple/core/theme/colors.dart';
import 'package:ripple/core/theme/text_styles.dart';
import 'package:ripple/core/utils/constants/constants.dart';
import 'package:ripple/core/utils/constants/routes.dart';
import 'package:ripple/core/utils/constants/spacing.dart';
import 'package:ripple/core/utils/extensions/context_extension.dart';

class ProfileStats extends StatelessWidget {
  final UserModel user;
  final int postCount;

  const ProfileStats({
    super.key,
    required this.user,
    required this.postCount,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: ColorsManager.surfaceContainer.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: ColorsManager.outline.withValues(alpha: 0.1),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _StatItem(
            label: appTranslation().get('posts'),
            value: postCount.toString(),
          ),
          _buildVerticalDivider(),
          _StatItem(
            label: appTranslation().get('followers'),
            value: user.followers.length.toString(),
            onTap: () {
              context.push(
                Routes.followList,
                arguments: {
                  'title': appTranslation().get('followers'),
                  'uids': user.followers,
                },
              );
            },
          ),
          _buildVerticalDivider(),
          _StatItem(
            label: appTranslation().get('following'),
            value: user.following.length.toString(),
            onTap: () {
              context.push(
                Routes.followList,
                arguments: {
                  'title': appTranslation().get('following'),
                  'uids': user.following,
                },
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildVerticalDivider() {
    return Container(
      height: 24,
      width: 1,
      color: ColorsManager.outline.withValues(alpha: 0.2),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String label;
  final String value;
  final VoidCallback? onTap;

  const _StatItem({
    required this.label,
    required this.value,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        child: Column(
          children: [
            Text(
              value,
              style: TextStylesManager.bold20.copyWith(height: 1.1),
            ),
            verticalSpace4,
            Text(
              label,
              style: TextStylesManager.medium12.copyWith(
                color: ColorsManager.textSecondaryColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
