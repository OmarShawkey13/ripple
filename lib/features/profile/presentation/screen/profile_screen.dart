import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ripple/core/models/user_model.dart';
import 'package:ripple/core/theme/colors.dart';
import 'package:ripple/core/utils/cubit/home_cubit.dart';
import 'package:ripple/core/utils/cubit/home_state.dart';
import 'package:ripple/core/utils/extensions/context_extension.dart';
import 'package:ripple/features/profile/presentation/widgets/profile_back_button.dart';
import 'package:ripple/features/profile/presentation/widgets/profile_cover.dart';
import 'package:ripple/features/profile/presentation/widgets/profile_header.dart';
import 'package:ripple/features/profile/presentation/widgets/profile_posts_section.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  static const double coverHeight = 220;
  static const double profileRadius = 52;
  UserModel? viewedUser;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final userId = context.getArg<String?>();

    if (userId == null || userId == homeCubit.userModel?.uid) {
      viewedUser = homeCubit.userModel;
      if (viewedUser != null) {
        homeCubit.getMyPosts();
      }
    } else {
      homeCubit.userRepo.getUser(userId).then((user) {
        if (mounted) {
          setState(() {
            viewedUser = user;
          });
          if (user != null) {
            homeCubit.postRepo.getUserPosts(user.uid!).listen((posts) {
              if (mounted) {
                setState(() {
                  homeCubit.userPosts = posts;
                });
              }
            });
          }
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeStates>(
      buildWhen: (previous, current) =>
          current is HomeGetMyPostsSuccessState ||
          current is HomeGetMyPostsErrorState ||
          current is HomeGetMyPostsLoadingState ||
          current is HomeLikePostSuccessState ||
          current is HomeLikePostErrorState ||
          current is HomeUpdateProfileSuccessState ||
          current is HomeFollowUserSuccessState ||
          current is HomeUnfollowUserSuccessState,
      builder: (context, state) {
        final posts = homeCubit.userPosts;
        final currentUser = homeCubit.userModel;
        if (viewedUser == null || currentUser == null) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        return Scaffold(
          backgroundColor: ColorsManager.backgroundColor,
          body: SingleChildScrollView(
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
                  child: Column(
                    children: [
                      ProfileHeader(
                        user: viewedUser!,
                        profileRadius: profileRadius,
                        currentUser: currentUser,
                        postCount: posts.length,
                      ),
                      ProfilePostsSection(posts: posts),
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
