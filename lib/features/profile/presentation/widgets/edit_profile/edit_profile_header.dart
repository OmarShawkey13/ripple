import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:ripple/core/theme/colors.dart';
import 'package:ripple/core/utils/constants/spacing.dart';
import 'package:ripple/core/utils/cubit/home/home_cubit.dart';
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
        Container(
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
          child: Stack(
            alignment: Alignment.bottomRight,
            children: [
              CircleAvatar(
                radius: profileRadius,
                backgroundColor: ColorsManager.surfaceContainer,
                backgroundImage: _buildProfileImage(),
                child:
                    cubit.profileImage == null &&
                        (user.photoUrl == null || user.photoUrl!.isEmpty)
                    ? Icon(
                        Icons.person_outline,
                        size: profileRadius,
                        color: ColorsManager.primary,
                      )
                    : null,
              ),
              EditProfileCircleIconButton(
                icon: Icons.camera_alt_rounded,
                onTap: () => cubit.pickProfileImage(),
              ),
            ],
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
    if (user.photoUrl != null && user.photoUrl!.isNotEmpty) {
      return CachedNetworkImageProvider(user.photoUrl!);
    }
    return null;
  }
}
