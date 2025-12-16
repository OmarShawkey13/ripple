import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ripple/core/theme/colors.dart';
import 'package:ripple/core/utils/constants/constants.dart';
import 'package:ripple/core/utils/cubit/home_cubit.dart';
import 'package:ripple/core/utils/cubit/home_state.dart';
import 'package:ripple/core/utils/extensions/context_extension.dart';
import 'package:ripple/features/profile/presentation/widgets/edit_profile/edit_profile_back_button.dart';
import 'package:ripple/features/profile/presentation/widgets/edit_profile/edit_profile_cover.dart';
import 'package:ripple/features/profile/presentation/widgets/edit_profile/edit_profile_form.dart';
import 'package:ripple/features/profile/presentation/widgets/edit_profile/edit_profile_header.dart';
import 'package:ripple/features/profile/presentation/widgets/edit_profile/edit_profile_save_button.dart';

class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({super.key});

  static const double coverHeight = 220;
  static const double profileRadius = 52;

  @override
  Widget build(BuildContext context) {
    final user = homeCubit.userModel;
    homeCubit.usernameController.text = user!.username ?? '';
    homeCubit.bioController.text = user.bio ?? '';
    return BlocConsumer<HomeCubit, HomeStates>(
      buildWhen: (previous, current) =>
          current is HomeUpdateProfileSuccessState ||
          current is HomeUpdateProfileErrorState ||
          current is HomeUpdateProfileLoadingState ||
          current is HomeProfileImagePickedState ||
          current is HomeCoverImagePickedState,
      listener: (context, state) {
        if (state is HomeUpdateProfileSuccessState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                appTranslation().get('profile_updated_successfully'),
              ),
              backgroundColor: ColorsManager.success,
              duration: const Duration(seconds: 2),
              behavior: SnackBarBehavior.floating,
            ),
          );
          context.pop;
        }
      },
      builder: (context, state) {
        if (state is HomeUpdateProfileLoadingState) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
        return Scaffold(
          backgroundColor: ColorsManager.backgroundColor,
          body: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                EditProfileCover(
                  height: coverHeight,
                  cubit: homeCubit,
                  user: user,
                ),
                const EditProfileBackButton(),
                const EditProfileSaveButton(),
                Padding(
                  padding: const EdgeInsets.only(
                    top: coverHeight - profileRadius,
                  ),
                  child: Column(
                    children: [
                      EditProfileHeader(
                        cubit: homeCubit,
                        user: user,
                        profileRadius: profileRadius,
                      ),
                      const EditProfileForm(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
