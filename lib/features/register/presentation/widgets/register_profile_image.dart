import 'package:flutter/material.dart';
import 'package:ripple/core/theme/colors.dart';
import 'package:ripple/core/utils/constants/assets_helper.dart';
import 'package:ripple/core/utils/cubit/home_cubit.dart';

class RegisterProfileImage extends StatelessWidget {
  const RegisterProfileImage({super.key});

  @override
  Widget build(BuildContext context) {
    final image = homeCubit.registerProfileImage;
    return GestureDetector(
      onTap: () => homeCubit.pickRegisterProfileImage(),
      child: Stack(
        alignment: Alignment.bottomRight,
        children: [
          CircleAvatar(
            radius: 55,
            backgroundColor: ColorsManager.primary.withValues(alpha: .15),
            backgroundImage: image != null
                ? FileImage(image)
                : const AssetImage(AssetsHelper.logo),
          ),
          Container(
            padding: const EdgeInsets.all(6),
            decoration: const BoxDecoration(
              color: ColorsManager.primary,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.camera_alt,
              size: 18,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
