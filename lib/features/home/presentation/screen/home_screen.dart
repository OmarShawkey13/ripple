import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ripple/core/utils/constants/primary/conditional_builder.dart';
import 'package:ripple/core/utils/cubit/home/home_cubit.dart';
import 'package:ripple/core/utils/cubit/home/home_state.dart';
import 'package:ripple/core/utils/cubit/theme/theme_cubit.dart';
import 'package:ripple/core/utils/cubit/theme/theme_state.dart';
import 'package:ripple/features/home/presentation/widgets/home_app_bar.dart';
import 'package:ripple/features/home/presentation/widgets/home_drawer.dart';
import 'package:ripple/features/home/presentation/widgets/home_fab.dart';
import 'package:ripple/features/home/presentation/widgets/post_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    homeCubit.getUserData().then((value) {
      homeCubit.getPosts();
      homeCubit.getNotifications();
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeState>(
      builder: (context, state) {
        return BlocBuilder<HomeCubit, HomeStates>(
          buildWhen: (previous, current) =>
              current is HomeGetPostsLoadingState ||
              current is HomeGetPostsSuccessState ||
              current is HomeGetPostsErrorState ||
              current is HomeGetUserSuccessState ||
              current is HomeGetUserErrorState ||
              current is HomeLikePostSuccessState,
          builder: (context, state) {
            return Scaffold(
              appBar: const HomeAppBar(),
              drawer: const HomeDrawer(),
              body: ConditionalBuilder(
                loadingState: state is HomeGetPostsLoadingState,
                successBuilder: (context) => ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  itemCount: homeCubit.posts.length,
                  itemBuilder: (context, index) => PostCard(
                    post: homeCubit.posts[index],
                  ),
                ),
              ),
              floatingActionButton: const HomeFAB(),
            );
          },
        );
      },
    );
  }
}
