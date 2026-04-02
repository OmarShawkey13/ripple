import 'package:flutter/material.dart';
import 'package:ripple/core/models/user_model.dart';
import 'package:ripple/core/theme/colors.dart';
import 'package:ripple/core/theme/text_styles.dart';
import 'package:ripple/core/utils/constants/constants.dart';
import 'package:ripple/core/utils/constants/routes.dart';
import 'package:ripple/core/utils/cubit/home/home_cubit.dart';
import 'package:ripple/core/utils/extensions/context_extension.dart';

class ProfileActionButtons extends StatelessWidget {
  final UserModel user;
  final UserModel currentUser;

  const ProfileActionButtons({
    super.key,
    required this.user,
    required this.currentUser,
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

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: isCurrentUser
          ? _buildEditProfileButton(context)
          : _buildFollowActionRow(isFollowing, buttonText),
    );
  }

  Widget _buildEditProfileButton(BuildContext context) {
    return FilledButton.icon(
      onPressed: () => context.push<Object>(Routes.editProfile),
      icon: const Icon(Icons.edit_rounded, size: 18),
      label: Text(
        appTranslation().get('edit_profile'),
        style: TextStylesManager.bold14,
      ),
      style: FilledButton.styleFrom(
        minimumSize: const Size(double.infinity, 50),
        backgroundColor: ColorsManager.primary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }

  Widget _buildFollowActionRow(bool isFollowing, String buttonText) {
    return FilledButton(
      onPressed: () {
        if (isFollowing) {
          homeCubit.unfollowUser(user.uid!);
        } else {
          homeCubit.followUser(user.uid!);
        }
      },
      style: FilledButton.styleFrom(
        minimumSize: const Size(double.infinity, 50),
        backgroundColor: isFollowing
            ? ColorsManager.surfaceContainer
            : ColorsManager.primary,
        foregroundColor: isFollowing ? ColorsManager.textColor : Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        elevation: 0,
      ),
      child: Text(
        buttonText,
        style: TextStylesManager.bold16,
      ),
    );
  }
}
