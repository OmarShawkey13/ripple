import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:ripple/core/models/user_model.dart';
import 'package:ripple/core/theme/colors.dart';
import 'package:ripple/core/utils/cubit/home/home_cubit.dart';

class EditProfileHeader extends StatelessWidget {
  final HomeCubit cubit;
  final UserModel user;

  const EditProfileHeader({
    super.key,
    required this.cubit,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => cubit.pickProfileImage(),
      behavior: HitTestBehavior.opaque,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: ColorsManager.backgroundColor,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 20,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: CircleAvatar(
              radius: 65,
              backgroundColor: ColorsManager.surfaceContainer,
              backgroundImage: _buildProfileImage(),
              child:
                  cubit.profileImage == null &&
                      (user.photoUrl == null || user.photoUrl!.isEmpty)
                  ? const Icon(
                      Icons.person_outline_rounded,
                      size: 50,
                      color: ColorsManager.primary,
                    )
                  : null,
            ),
          ),
          Positioned.fill(
            child: Container(
              margin: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.black.withValues(alpha: 0.3),
              ),
              child: const Icon(
                Icons.camera_enhance_rounded,
                color: Colors.white,
                size: 32,
              ),
            ),
          ),
        ],
      ),
    );
  }

  ImageProvider? _buildProfileImage() {
    if (cubit.profileImage != null) {
      return FileImage(cubit.profileImage!);
    }
    if (user.photoUrl != null && user.photoUrl!.isNotEmpty) {
      return CachedNetworkImageProvider(user.photoUrl!);
    }
    return null;
  }
}
