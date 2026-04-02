import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ripple/core/utils/constants/primary/conditional_builder.dart';
import 'package:ripple/core/utils/constants/primary/loading_indicator.dart';
import 'package:ripple/core/utils/cubit/home/home_cubit.dart';
import 'package:ripple/core/utils/cubit/home/home_state.dart';
import 'package:ripple/core/utils/cubit/theme/theme_cubit.dart';
import 'package:ripple/core/utils/cubit/theme/theme_state.dart';
import 'package:ripple/features/home/presentation/widgets/home_app_bar.dart';
import 'package:ripple/features/home/presentation/widgets/home_drawer.dart';
import 'package:ripple/features/home/presentation/widgets/post_card.dart';
import 'package:ripple/features/home/presentation/widgets/whats_new_widget.dart';
import 'package:ripple/core/theme/colors.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    homeCubit.getUserData();
    homeCubit.getPosts();
    homeCubit.getNotifications();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeState>(
      builder: (context, state) {
        return BlocBuilder<HomeCubit, HomeStates>(
          buildWhen: (previous, current) =>
              current is HomeGetFeedPostsLoadingState ||
              current is HomeGetFeedPostsSuccessState ||
              current is HomeGetFeedPostsErrorState ||
              current is HomeGetCurrentUserSuccessState ||
              current is HomeGetCurrentUserErrorState ||
              current is HomeLikePostSuccessState ||
              current is HomeDeletePostSuccessState ||
              current is HomeUpdatePostSuccessState,
          builder: (context, state) {
            return Scaffold(
              drawer: const HomeDrawer(),
              appBar: const HomeAppBar(),
              body: RefreshIndicator(
                onRefresh: () async => homeCubit.getPosts(),
                color: ColorsManager.primary,
                child: CustomScrollView(
                  physics: const BouncingScrollPhysics(),
                  slivers: [
                    const SliverToBoxAdapter(
                      child: WhatsNewWidget(),
                    ),
                    SliverToBoxAdapter(
                      child: ConditionalBuilder(
                        loadingState:
                            state is HomeGetFeedPostsLoadingState &&
                            homeCubit.posts.isEmpty,
                        successBuilder: (context) => ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) => PostCard(
                            post: homeCubit.posts[index],
                          ),
                          separatorBuilder: (context, index) => Divider(
                            height: 1,
                            thickness: 0.5,
                            color: ColorsManager.outline.withValues(alpha: 0.3),
                            indent: 16,
                            endIndent: 16,
                          ),
                          itemCount: homeCubit.posts.length,
                        ),
                        loadingBuilder: (context) => const Padding(
                          padding: EdgeInsets.symmetric(vertical: 50.0),
                          child: LoadingIndicator(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
