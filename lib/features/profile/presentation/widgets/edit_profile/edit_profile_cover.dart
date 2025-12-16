import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:ripple/core/theme/colors.dart';
import 'package:ripple/core/utils/cubit/home_cubit.dart';
import 'package:ripple/features/profile/presentation/widgets/edit_profile/edit_profile_circle_icon_button.dart';

class EditProfileCover extends StatelessWidget {
  final double height;
  final HomeCubit cubit;
  final dynamic user;

  const EditProfileCover({
    super.key,
    required this.height,
    required this.cubit,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: height,
          width: double.infinity,
          decoration: BoxDecoration(
            color: ColorsManager.cardColor,
            image: _buildCoverImage(),
          ),
        ),

        // 📸 Camera button
        PositionedDirectional(
          bottom: 12,
          end: 12,
          child: EditProfileCircleIconButton(
            icon: Icons.camera_alt,
            onTap: () {
              cubit.pickCoverImage();
            },
          ),
        ),
      ],
    );
  }

  DecorationImage? _buildCoverImage() {
    if (cubit.coverImage != null) {
      return DecorationImage(
        image: FileImage(cubit.coverImage!),
        fit: BoxFit.cover,
      );
    }
    if (user.coverUrl.isNotEmpty) {
      return DecorationImage(
        image: CachedNetworkImageProvider(user.coverUrl),
        fit: BoxFit.cover,
      );
    }
    return null;
  }
}
