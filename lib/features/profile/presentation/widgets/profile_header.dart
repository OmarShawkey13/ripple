import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:ripple/core/models/user_model.dart';
import 'package:ripple/core/theme/colors.dart';
import 'package:ripple/core/theme/emoji_text.dart';
import 'package:ripple/core/theme/text_styles.dart';
import 'package:ripple/core/utils/constants/constants.dart';
import 'package:ripple/core/utils/constants/primary/image_preview_page.dart';
import 'package:ripple/core/utils/constants/routes.dart';
import 'package:ripple/core/utils/constants/spacing.dart';
import 'package:ripple/core/utils/cubit/home_cubit.dart';
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
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute<Object>(
                builder: (context) => ImagePreviewPage(url: user.photoUrl!),
              ),
            );
          },
          child: CircleAvatar(
            radius: profileRadius + 4,
            backgroundColor: ColorsManager.backgroundColor,
            child: CircleAvatar(
              radius: profileRadius,
              backgroundImage: user.photoUrl!.isNotEmpty
                  ? CachedNetworkImageProvider(user.photoUrl!)
                  : null,
              child: user.photoUrl!.isEmpty
                  ? const Icon(Icons.person, size: 48)
                  : null,
            ),
          ),
        ),
        verticalSpace12,
        EmojiText(
          text: user.username!,
          style: TextStylesManager.bold20,
        ),
        verticalSpace6,
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: EmojiText(
            text: user.bio!,
            textAlign: TextAlign.center,
            style: TextStylesManager.regular14.copyWith(
              color: ColorsManager.textSecondaryColor,
            ),
          ),
        ),
        verticalSpace12,
        if (isCurrentUser)
          OutlinedButton(
            onPressed: () {
              context.push<Object>(Routes.editProfile);
            },
            style: OutlinedButton.styleFrom(
              foregroundColor: ColorsManager.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            child: Text(appTranslation().get('edit_profile')),
          )
        else
          ElevatedButton(
            onPressed: () {
              if (isFollowing) {
                homeCubit.unfollowUser(user.uid!);
              } else {
                homeCubit.followUser(user.uid!);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor:
                  isFollowing ? Colors.grey : ColorsManager.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            child: Text(buttonText),
          ),
        verticalSpace12,
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildStatColumn('Posts', postCount.toString()),
            _buildStatColumn('Followers', user.followers.length.toString()),
            _buildStatColumn('Following', user.following.length.toString()),
          ],
        ),
        verticalSpace16,
        Divider(
          color: ColorsManager.textSecondaryColor.withValues(alpha: 0.2),
        ),
        verticalSpace16,
      ],
    );
  }

  Widget _buildStatColumn(String title, String value) {
    return Column(
      children: [
        Text(
          value,
          style: TextStylesManager.bold16,
        ),
        verticalSpace4,
        Text(
          title,
          style: TextStylesManager.regular14.copyWith(
            color: ColorsManager.textSecondaryColor,
          ),
        ),
      ],
    );
  }
}
