import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ripple/core/theme/colors.dart';
import 'package:ripple/core/utils/constants/constants.dart';
import 'package:ripple/core/utils/constants/primary/conditional_builder.dart';
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
    homeCubit.getUserData().then((value) {
      homeCubit.getPosts();
      homeCubit.getNotifications();
    });
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
          current is HomeLikePostSuccessState ||
          current is HomeChangeThemeState ||
          current is HomeGetNotificationsSuccessState,
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: Text(
              appTranslation().get("app_name"),
            ),
            actions: [
              Stack(
                alignment: Alignment.center,
                children: [
                  IconButton(
                    onPressed: () {
                      context.push<Object>(Routes.notifications);
                    },
                    icon: const Icon(Icons.notifications),
                  ),
                  if (homeCubit.unreadNotificationsCount > 0)
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: ColorsManager.primary,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          '${homeCubit.unreadNotificationsCount}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
          drawer: const HomeDrawer(),
          body: ConditionalBuilder(
            condition: state is HomeGetPostsLoadingState,
            builder: (context) => const Center(
              child: CircularProgressIndicator(),
            ),
            fallback: (context) => ListView.builder(
              physics: const BouncingScrollPhysics(),
              itemCount: homeCubit.posts.length,
              itemBuilder: (context, index) => PostCard(
                post: homeCubit.posts[index],
              ),
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
