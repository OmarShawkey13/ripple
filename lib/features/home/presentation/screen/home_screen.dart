import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ripple/core/theme/colors.dart';
import 'package:ripple/core/utils/constants/constants.dart';
import 'package:ripple/core/utils/constants/routes.dart';
import 'package:ripple/core/utils/cubit/home_cubit.dart';
import 'package:ripple/core/utils/cubit/home_state.dart';
import 'package:ripple/core/utils/extensions/context_extension.dart';
import 'package:ripple/features/home/presentation/widgets/home_drawer.dart';
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
    homeCubit.getUserData().then((value) => homeCubit.getPosts());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeStates>(
      buildWhen: (previous, current) =>
          current is HomeGetPostsLoadingState ||
          current is HomeGetPostsSuccessState ||
          current is HomeGetPostsErrorState ||
          current is HomeGetUserSuccessState ||
          current is HomeGetUserErrorState ||
          current is HomeLikePostSuccessState || // To rebuild on like
          current is HomeChangeThemeState,
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: Text(
              appTranslation().get("app_name"),
            ),
          ),
          drawer: const HomeDrawer(),
          body: state is HomeGetPostsLoadingState
              ? const Center(child: CircularProgressIndicator())
              : ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  itemCount: homeCubit.posts.length,
                  itemBuilder: (context, index) => PostCard(
                    post: homeCubit.posts[index],
                  ),
                ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              context.push<Object>(Routes.addPost);
            },
            backgroundColor: ColorsManager.primary,
            foregroundColor: Colors.white,
            child: const Icon(Icons.add),
          ),
        );
      },
    );
  }
}
