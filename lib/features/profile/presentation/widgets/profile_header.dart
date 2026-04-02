import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:ripple/core/models/user_model.dart';
import 'package:ripple/core/theme/colors.dart';
import 'package:ripple/core/theme/emoji_text.dart';
import 'package:ripple/core/theme/text_styles.dart';
import 'package:ripple/core/utils/constants/constants.dart';
import 'package:ripple/core/utils/constants/routes.dart';
import 'package:ripple/core/utils/constants/spacing.dart';
import 'package:ripple/core/utils/cubit/home/home_cubit.dart';
import 'package:ripple/core/utils/extensions/context_extension.dart';

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
    final isCurrentUser = user.uid == currentUser.uid;
    final isFollowing = currentUser.following.contains(user.uid);
    final isFollowedBy = currentUser.followers.contains(user.uid);

    String buttonText;
    if (isFollowing) {
      buttonText = appTranslation().get('unfollow');
    } else if (isFollowedBy) {
      buttonText = appTranslation().get('follow_back');
    } else {
      buttonText = appTranslation().get('follow');
    }

    return Column(
      children: [
        _buildProfileImage(context),
        verticalSpace12,
        EmojiText(
          text: user.username ?? '',
          style: TextStylesManager.bold22.copyWith(letterSpacing: 0.5),
        ),
        verticalSpace8,
        if (user.bio != null && user.bio!.isNotEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: EmojiText(
              text: user.bio!,
              textAlign: TextAlign.center,
              style: TextStylesManager.regular14.copyWith(
                color: ColorsManager.textSecondaryColor,
                height: 1.4,
              ),
            ),
          ),
        verticalSpace20,
        _buildStatsRow(),
        verticalSpace24,
        _buildActionButton(context, isCurrentUser, isFollowing, buttonText),
        verticalSpace24,
        Divider(
          height: 1,
          thickness: 1,
          color: ColorsManager.dividerColor.withValues(alpha: 0.1),
        ),
      ],
    );
  }

  Widget _buildProfileImage(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: ColorsManager.backgroundColor,
          width: 4,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: CircleAvatar(
        radius: profileRadius,
        backgroundColor: ColorsManager.surfaceContainer,
        backgroundImage: user.photoUrl != null && user.photoUrl!.isNotEmpty
            ? CachedNetworkImageProvider(user.photoUrl!)
            : null,
        child: user.photoUrl == null || user.photoUrl!.isEmpty
            ? Icon(
                Icons.person_outline,
                size: profileRadius,
                color: ColorsManager.primary,
              )
            : null,
      ),
    );
  }

  Widget _buildStatsRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _StatItem(
          label: appTranslation().get('posts'),
          value: postCount.toString(),
        ),
        _StatItem(
          label: appTranslation().get('followers'),
          value: user.followers.length.toString(),
        ),
        _StatItem(
          label: appTranslation().get('following'),
          value: user.following.length.toString(),
        ),
      ],
    );
  }

  Widget _buildActionButton(
    BuildContext context,
    bool isCurrentUser,
    bool isFollowing,
    String buttonText,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: isCurrentUser
          ? OutlinedButton(
              onPressed: () => context.push<Object>(Routes.editProfile),
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(double.infinity, 44),
                side: BorderSide(
                  color: ColorsManager.primary.withValues(alpha: 0.5),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                appTranslation().get('edit_profile'),
                style: TextStylesManager.bold14.copyWith(
                  color: ColorsManager.primary,
                ),
              ),
            )
          : FilledButton(
              onPressed: () {
                if (isFollowing) {
                  homeCubit.unfollowUser(user.uid!);
                } else {
                  homeCubit.followUser(user.uid!);
                }
              },
              style: FilledButton.styleFrom(
                minimumSize: const Size(double.infinity, 44),
                backgroundColor: isFollowing
                    ? ColorsManager.surfaceContainer
                    : ColorsManager.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                buttonText,
                style: TextStylesManager.bold14.copyWith(
                  color: isFollowing ? ColorsManager.textColor : Colors.white,
                ),
              ),
            ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String label;
  final String value;

  const _StatItem({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value, style: TextStylesManager.bold18),
        verticalSpace4,
        Text(
          label,
          style: TextStylesManager.regular12.copyWith(
            color: ColorsManager.textSecondaryColor,
          ),
        ),
      ],
    );
  }
}
