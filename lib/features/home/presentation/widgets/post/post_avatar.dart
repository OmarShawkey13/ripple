import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:ripple/core/theme/colors.dart';
import 'package:ripple/core/utils/constants/routes.dart';
import 'package:ripple/core/utils/extensions/context_extension.dart';

class PostAvatar extends StatelessWidget {
  final String? userProfilePic;
  final String userId;
  final double radius;

  const PostAvatar({
    super.key,
    required this.userProfilePic,
    required this.userId,
    this.radius = 20,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push(Routes.profile, arguments: userId),
      child: Container(
        padding: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            colors: [
              ColorsManager.primary.withValues(alpha: 0.7),
              ColorsManager.secondary.withValues(alpha: 0.5),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Container(
          padding: const EdgeInsets.all(2),
          decoration: BoxDecoration(
            color: ColorsManager.cardColor,
            shape: BoxShape.circle,
          ),
          child: CircleAvatar(
            radius: radius,
            backgroundColor: ColorsManager.surfaceContainer,
            backgroundImage:
                userProfilePic != null && userProfilePic!.isNotEmpty
                ? CachedNetworkImageProvider(userProfilePic!)
                : null,
            child: userProfilePic == null || userProfilePic!.isEmpty
                ? Icon(
                    Icons.person_rounded,
                    color: ColorsManager.textSecondaryColor,
                    size: radius,
                  )
                : null,
          ),
        ),
      ),
    );
  }
}
