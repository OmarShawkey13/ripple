import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ripple/core/theme/colors.dart';
import 'package:ripple/core/utils/constants/constants.dart';
import 'package:ripple/core/utils/constants/primary/loading_indicator.dart';
import 'package:ripple/core/utils/constants/spacing.dart';
import 'package:ripple/core/utils/cubit/home/home_cubit.dart';
import 'package:ripple/core/utils/cubit/home/home_state.dart';
import 'package:ripple/core/utils/extensions/context_extension.dart';
import 'package:ripple/features/profile/presentation/widgets/edit_profile/edit_profile_app_bar.dart';
import 'package:ripple/features/profile/presentation/widgets/edit_profile/edit_profile_cover.dart';
import 'package:ripple/features/profile/presentation/widgets/edit_profile/edit_profile_form.dart';
import 'package:ripple/features/profile/presentation/widgets/edit_profile/edit_profile_header.dart';

class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = homeCubit.userModel;
    if (user == null) return const SizedBox.shrink();

    homeCubit.usernameController.text = user.username ?? '';
    homeCubit.bioController.text = user.bio ?? '';

    return BlocConsumer<HomeCubit, HomeStates>(
      buildWhen: (previous, current) =>
          current is HomeUpdateProfileLoadingState ||
          current is HomeUpdateProfileSuccessState ||
          current is HomeUpdateProfileErrorState ||
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
              behavior: SnackBarBehavior.floating,
            ),
          );
          context.pop;
        } else if (state is HomeUpdateProfileErrorState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.error),
              backgroundColor: ColorsManager.error,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      },
      builder: (context, state) {
        final isLoading = state is HomeUpdateProfileLoadingState;
        return Scaffold(
          backgroundColor: ColorsManager.backgroundColor,
          appBar: EditProfileAppBar(
            isLoading: isLoading,
            onSave: () => homeCubit.updateProfile(),
          ),
          body: Stack(
            children: [
              CustomScrollView(
                physics: const BouncingScrollPhysics(),
                slivers: [
                  SliverToBoxAdapter(
                    child: Stack(
                      alignment: Alignment.topCenter,
                      clipBehavior: Clip.none,
                      children: [
                        EditProfileCover(
                          cubit: homeCubit,
                          user: user,
                        ),
                        Positioned(
                          bottom: -65,
                          child: EditProfileHeader(
                            cubit: homeCubit,
                            user: user,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SliverToBoxAdapter(child: verticalSpace85),
                  const SliverToBoxAdapter(
                    child: EditProfileForm(),
                  ),
                  SliverToBoxAdapter(child: verticalSpace40),
                ],
              ),
              if (isLoading)
                Container(
                  color: Colors.black.withValues(alpha: 0.4),
                  child: const Center(child: LoadingIndicator()),
                ),
            ],
          ),
        );
      },
    );
  }
}
