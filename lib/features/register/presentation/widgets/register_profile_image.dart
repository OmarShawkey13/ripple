import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ripple/core/theme/colors.dart';
import 'package:ripple/core/utils/constants/assets_helper.dart';
import 'package:ripple/core/utils/constants/primary/conditional_builder.dart';
import 'package:ripple/core/utils/cubit/auth/auth_cubit.dart';
import 'package:ripple/core/utils/cubit/auth/auth_state.dart';

class RegisterProfileImage extends StatelessWidget {
  const RegisterProfileImage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthStates>(
      buildWhen: (_, state) => state is AuthProfileImagePickedState,
      builder: (context, state) {
        final image = authCubit.registerProfileImage;
        return GestureDetector(
          onTap: () => authCubit.pickRegisterProfileImage(),
          child: Stack(
            alignment: Alignment.bottomRight,
            children: [
              CircleAvatar(
                radius: 55,
                backgroundColor: ColorsManager.primary.withValues(alpha: .15),
                child: ClipOval(
                  child: ConditionalBuilder(
                    loadingState: image != null,
                    successBuilder: (context) => const Image(
                      image: AssetImage(AssetsHelper.logo),
                      fit: BoxFit.cover,
                    ),
                    loadingBuilder: (context) => Image.file(
                      image!,
                      fit: BoxFit.cover,
                      width: 110,
                      height: 110,
                    ),
                  ),
                ),
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
                  color: ColorsManager.lightCard,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
