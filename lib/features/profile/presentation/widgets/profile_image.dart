import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:ripple/core/models/user_model.dart';
import 'package:ripple/core/theme/colors.dart';

class ProfileImage extends StatelessWidget {
  final UserModel user;
  final double profileRadius;

  const ProfileImage({
    super.key,
    required this.user,
    required this.profileRadius,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: ColorsManager.backgroundColor,
          width: 6,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
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
                Icons.person_rounded,
                size: profileRadius,
                color: ColorsManager.primary,
              )
            : null,
      ),
    );
  }
}
