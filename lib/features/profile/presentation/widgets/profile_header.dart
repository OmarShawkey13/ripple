import 'package:flutter/material.dart';
import 'package:ripple/core/models/user_model.dart';
import 'package:ripple/core/theme/colors.dart';
import 'package:ripple/core/theme/emoji_text.dart';
import 'package:ripple/core/theme/text_styles.dart';
import 'package:ripple/core/utils/constants/spacing.dart';
import 'package:ripple/features/profile/presentation/widgets/profile_action_buttons.dart';
import 'package:ripple/features/profile/presentation/widgets/profile_image.dart';
import 'package:ripple/features/profile/presentation/widgets/profile_stats.dart';

class ProfileHeader extends StatelessWidget {
  final UserModel user;
  final UserModel currentUser;
  final double profileRadius;
  final int postCount;

  const ProfileHeader({
    super.key,
    required this.user,
    required this.profileRadius,
    required this.currentUser,
    required this.postCount,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: ColorsManager.backgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Column(
        children: [
          ProfileImage(user: user, profileRadius: profileRadius),
          verticalSpace16,
          EmojiText(
            text: user.username ?? '',
            style: TextStylesManager.bold26.copyWith(
              letterSpacing: -0.5,
              color: ColorsManager.textColor,
            ),
          ),
          if (user.bio != null && user.bio!.isNotEmpty) ...[
            verticalSpace8,
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: EmojiText(
                text: user.bio!,
                textAlign: TextAlign.center,
                style: TextStylesManager.regular14.copyWith(
                  color: ColorsManager.textSecondaryColor,
                  height: 1.5,
                ),
              ),
            ),
          ],
          verticalSpace24,
          ProfileStats(user: user, postCount: postCount),
          verticalSpace24,
          ProfileActionButtons(user: user, currentUser: currentUser),
          verticalSpace24,
          Divider(
            height: 1,
            thickness: 1,
            color: ColorsManager.dividerColor.withValues(alpha: 0.05),
          ),
        ],
      ),
    );
  }
}
