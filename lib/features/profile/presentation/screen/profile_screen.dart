import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ripple/core/theme/colors.dart';
import 'package:ripple/core/utils/constants/primary/conditional_builder.dart';
import 'package:ripple/core/utils/constants/spacing.dart';
import 'package:ripple/core/utils/cubit/home/home_cubit.dart';
import 'package:ripple/core/utils/cubit/home/home_state.dart';
import 'package:ripple/core/utils/extensions/context_extension.dart';
import 'package:ripple/features/profile/presentation/widgets/profile_back_button.dart';
import 'package:ripple/features/profile/presentation/widgets/profile_cover.dart';
import 'package:ripple/features/profile/presentation/widgets/profile_header.dart';
import 'package:ripple/features/profile/presentation/widgets/profile_posts_section.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  static const double coverHeight = 240;
  static const double profileRadius = 56;

  @override
  Widget build(BuildContext context) {
    final userId = context.getArg<String?>();
    homeCubit.initProfile(userId);

    return BlocBuilder<HomeCubit, HomeStates>(
      buildWhen: (previous, current) =>
          current is HomeGetProfilePostsSuccessState ||
          current is HomeGetProfilePostsLoadingState ||
          current is HomeGetProfilePostsErrorState ||
          current is HomeGetViewedUserSuccessState ||
          current is HomeGetViewedUserLoadingState ||
          current is HomeGetViewedUserErrorState ||
          current is HomeFollowUserSuccessState ||
          current is HomeUnfollowUserSuccessState,
      builder: (context, state) {
        final currentUser = homeCubit.userModel;
        final viewedUser = (userId == null || userId == currentUser?.uid)
            ? currentUser
            : homeCubit.viewedUserModel;
        final posts = homeCubit.userPosts;

        return Scaffold(
          backgroundColor: ColorsManager.backgroundColor,
          body: ConditionalBuilder(
            loadingState: viewedUser == null || currentUser == null,
            successBuilder: (context) => RefreshIndicator(
              onRefresh: () async => homeCubit.initProfile(userId),
              color: ColorsManager.primary,
              child: CustomScrollView(
                physics: const BouncingScrollPhysics(),
                slivers: [
                  SliverToBoxAdapter(
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        ProfileCover(
                          height: coverHeight,
                          imageUrl: viewedUser!.coverUrl,
                        ),
                        const ProfileBackButton(),
                        Padding(
                          padding: const EdgeInsets.only(
                            top: coverHeight - profileRadius,
                          ),
                          child: ProfileHeader(
                            user: viewedUser,
                            profileRadius: profileRadius,
                            currentUser: currentUser!,
                            postCount: posts.length,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.only(top: 8),
                    sliver: ProfilePostsSection(posts: posts),
                  ),
                  SliverToBoxAdapter(child: verticalSpace32),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
