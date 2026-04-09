import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:ripple/core/models/user_model.dart';
import 'package:ripple/core/theme/colors.dart';
import 'package:ripple/core/utils/constants/primary/image_preview_page.dart';

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
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute<Object>(
          builder: (context) => ImagePreviewPage(urls: [user.photoUrl!]),
        ),
      ),
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: ColorsManager.backgroundColor,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 15,
              offset: const Offset(0, 8),
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
      ),
    );
  }
}
