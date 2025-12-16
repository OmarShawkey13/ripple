import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:ripple/core/theme/colors.dart';
import 'package:ripple/core/utils/constants/spacing.dart';
import 'package:ripple/core/utils/cubit/home_cubit.dart';
import 'package:ripple/features/profile/presentation/widgets/edit_profile/edit_profile_circle_icon_button.dart';

class EditProfileHeader extends StatelessWidget {
  final HomeCubit cubit;
  final dynamic user;
  final double profileRadius;

  const EditProfileHeader({
    super.key,
    required this.cubit,
    required this.user,
    required this.profileRadius,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: profileRadius + 4,
          backgroundColor: ColorsManager.backgroundColor,
          child: CircleAvatar(
            radius: profileRadius,
            backgroundImage: _buildProfileImage(),
            child: Stack(
              alignment: Alignment.bottomRight,
              children: [
                if (cubit.profileImage == null && user.photoUrl!.isEmpty)
                  const Center(
                    child: Icon(Icons.person, size: 48),
                  ),
                EditProfileCircleIconButton(
                  icon: Icons.camera_alt,
                  onTap: () {
                    cubit.pickProfileImage();
                  },
                ),
              ],
            ),
          ),
        ),
        verticalSpace16,
      ],
    );
  }

  ImageProvider? _buildProfileImage() {
    if (cubit.profileImage != null) {
      return FileImage(cubit.profileImage!);
    }
    if (user.photoUrl.isNotEmpty) {
      return CachedNetworkImageProvider(user.photoUrl);
    }
    return null;
  }
}
