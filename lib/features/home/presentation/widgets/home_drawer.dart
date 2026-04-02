import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ripple/core/theme/colors.dart';
import 'package:ripple/core/theme/text_styles.dart';
import 'package:ripple/core/utils/constants/constants.dart';
import 'package:ripple/core/utils/constants/routes.dart';
import 'package:ripple/core/utils/constants/spacing.dart';
import 'package:ripple/core/utils/cubit/home/home_cubit.dart';
import 'package:ripple/core/utils/cubit/home/home_state.dart';
import 'package:ripple/core/utils/cubit/theme/theme_cubit.dart';
import 'package:ripple/core/utils/cubit/theme/theme_state.dart';
import 'package:ripple/core/utils/extensions/context_extension.dart';
import 'package:ripple/features/home/presentation/widgets/home_drawer_header.dart';
import 'package:ripple/features/home/presentation/widgets/home_drawer_tile.dart';

class HomeDrawer extends StatelessWidget {
  const HomeDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeState>(
      builder: (context, state) {
        return BlocBuilder<HomeCubit, HomeStates>(
          buildWhen: (previous, current) =>
              current is HomeGetUserSuccessState ||
              current is HomeGetUserErrorState,
          builder: (context, state) {
            final user = homeCubit.userModel;
            final isDark = themeCubit.isDarkMode;
            final isArabic = themeCubit.isArabicLang;
            return Drawer(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  HomeDrawerHeader(user: user),
                  verticalSpace8,
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          HomeDrawerTile(
                            title: appTranslation().get('home'),
                            icon: Icons.home_rounded,
                            onTap: () => context.pop,
                          ),
                          HomeDrawerTile(
                            title: appTranslation().get('profile'),
                            icon: Icons.person_rounded,
                            onTap: () {
                              context.pop;
                              context.push<Object>(Routes.profile);
                            },
                          ),
                          HomeDrawerTile(
                            title: appTranslation().get('notifications'),
                            icon: Icons.notifications_rounded,
                            onTap: () {
                              context.pop;
                              context.push<Object>(Routes.notifications);
                            },
                          ),
                          HomeDrawerTile(
                            title: appTranslation().get('about_ripple'),
                            icon: Icons.info_rounded,
                            onTap: () {
                              context.pop;
                              context.push<Object>(Routes.about);
                            },
                          ),
                          HomeDrawerTile(
                            title: appTranslation().get('dark_mode'),
                            icon: isDark
                                ? Icons.dark_mode_rounded
                                : Icons.light_mode_rounded,
                            trailing: Switch(
                              value: isDark,
                              activeThumbColor: ColorsManager.primary,
                              onChanged: (val) => themeCubit.changeTheme(),
                              materialTapTargetSize: .shrinkWrap,
                            ),
                          ),
                          HomeDrawerTile(
                            title: appTranslation().get('language'),
                            icon: Icons.language_rounded,
                            trailing: Switch(
                              value: isArabic,
                              activeThumbColor: ColorsManager.primary,
                              onChanged: (val) => themeCubit.toggleLanguage(),
                              materialTapTargetSize: .shrinkWrap,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Divider(height: 1),
                  HomeDrawerTile(
                    title: appTranslation().get('logout'),
                    icon: Icons.logout_rounded,
                    onTap: () => homeCubit.logout(context),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Center(
                      child: Text(
                        "Ripple v1.0.0",
                        style: TextStylesManager.regular12.copyWith(
                          color: Colors.grey.withValues(alpha: 0.6),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
