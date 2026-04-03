import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:ripple/core/models/user_model.dart';
import 'package:ripple/core/theme/colors.dart';
import 'package:ripple/core/utils/constants/spacing.dart';
import 'package:ripple/core/utils/cubit/home/home_cubit.dart';

class EditProfileCover extends StatelessWidget {
  final HomeCubit cubit;
  final UserModel user;

  const EditProfileCover({
    super.key,
    required this.cubit,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => cubit.pickCoverImage(),
      behavior: HitTestBehavior.opaque,
      child: Stack(
        children: [
          Container(
            height: 220,
            width: double.infinity,
            decoration: BoxDecoration(
              color: ColorsManager.surfaceContainer,
              image: _buildCoverImage(),
            ),
          ),
          // Gradient Overlay
          Container(
            height: 220,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withValues(alpha: 0.3),
                  Colors.transparent,
                  Colors.black.withValues(alpha: 0.5),
                ],
              ),
            ),
          ),
          // Edit Label
          Positioned(
            top: 16,
            right: 16,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.2),
                  width: 1,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.camera_alt_outlined,
                    color: Colors.white,
                    size: 16,
                  ),
                  horizontalSpace8,
                  const Text(
                    'Change Cover',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  DecorationImage? _buildCoverImage() {
    if (cubit.coverImage != null) {
      return DecorationImage(
        image: FileImage(cubit.coverImage!),
        fit: BoxFit.cover,
      );
    }
    if (user.coverUrl != null && user.coverUrl!.isNotEmpty) {
      return DecorationImage(
        image: CachedNetworkImageProvider(user.coverUrl!),
        fit: BoxFit.cover,
      );
    }
    return null;
  }
}
