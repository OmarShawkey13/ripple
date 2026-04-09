import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ripple/core/theme/colors.dart';
import 'package:ripple/core/utils/constants/primary/conditional_builder.dart';
import 'package:ripple/core/utils/constants/spacing.dart';
import 'package:ripple/core/utils/cubit/home/home_cubit.dart';
import 'package:ripple/core/utils/cubit/home/home_state.dart';
import 'package:ripple/core/utils/extensions/context_extension.dart';
import 'package:ripple/core/theme/text_styles.dart';
import 'package:ripple/features/profile/presentation/widgets/profile_back_button.dart';
import 'package:ripple/features/profile/presentation/widgets/profile_cover.dart';
import 'package:ripple/features/profile/presentation/widgets/profile_header.dart';
import 'package:ripple/features/profile/presentation/widgets/profile_posts_section.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  static const double coverHeight = 200;
  static const double profileRadius = 56;

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String? userId;
  late ScrollController _scrollController;
  bool _showTitle = false;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()
      ..addListener(() {
        final offset = _scrollController.offset;
        if (offset > ProfileScreen.coverHeight - kToolbarHeight - 20) {
          if (!_showTitle) setState(() => _showTitle = true);
        } else {
          if (_showTitle) setState(() => _showTitle = false);
        }
      });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      userId = context.getArg<String?>();
      homeCubit.initProfile(userId);
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
          body: ConditionalBuilder(
            loadingState: viewedUser == null || currentUser == null,
            successBuilder: (context) => RefreshIndicator(
              onRefresh: () async => homeCubit.initProfile(userId),
              color: ColorsManager.primary,
              child: CustomScrollView(
                controller: _scrollController,
                physics: const BouncingScrollPhysics(),
                slivers: [
                  SliverAppBar(
                    expandedHeight: ProfileScreen.coverHeight,
                    pinned: true,
                    stretch: true,
                    elevation: 0,
                    leadingWidth: 70,
                    leading: const Center(child: ProfileBackButton()),
                    title: AnimatedOpacity(
                      duration: const Duration(milliseconds: 200),
                      opacity: _showTitle ? 1.0 : 0.0,
                      child: Text(
                        viewedUser?.username ?? '',
                        style: TextStylesManager.bold18.copyWith(
                          color: ColorsManager.textColor,
                        ),
                      ),
                    ),
                    centerTitle: true,
                    flexibleSpace: FlexibleSpaceBar(
                      stretchModes: const [
                        StretchMode.zoomBackground,
                        StretchMode.blurBackground,
                        StretchMode.fadeTitle,
                      ],
                      background: ProfileCover(
                        height: ProfileScreen.coverHeight,
                        imageUrl: viewedUser?.coverUrl,
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: ProfileHeader(
                      user: viewedUser!,
                      profileRadius: ProfileScreen.profileRadius,
                      currentUser: currentUser!,
                      postCount: posts.length,
                    ),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.only(top: 0),
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
