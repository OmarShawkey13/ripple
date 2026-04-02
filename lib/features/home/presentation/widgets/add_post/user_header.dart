import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:ripple/core/theme/colors.dart';
import 'package:ripple/core/theme/emoji_text.dart';
import 'package:ripple/core/theme/text_styles.dart';
import 'package:ripple/core/utils/constants/spacing.dart';
import 'package:ripple/core/utils/cubit/home/home_cubit.dart';

class UserHeader extends StatelessWidget {
  const UserHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final user = homeCubit.userModel;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: ColorsManager.surfaceContainer,
            backgroundImage:
                user?.photoUrl != null && user!.photoUrl!.isNotEmpty
                ? CachedNetworkImageProvider(user.photoUrl!)
                : null,
            child: user?.photoUrl == null || user!.photoUrl!.isEmpty
                ? Icon(
                    Icons.person,
                    color: ColorsManager.textSecondaryColor,
                    size: 22,
                  )
                : null,
          ),
          horizontalSpace12,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                EmojiText(
                  text: user?.username ?? '',
                  style: TextStylesManager.bold16.copyWith(
                    color: ColorsManager.textColor,
                  ),
                ),
                verticalSpace4,
              ],
            ),
          ),
        ],
      ),
    );
  }
}
