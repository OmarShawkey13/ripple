import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ripple/core/theme/colors.dart';
import 'package:ripple/core/theme/text_styles.dart';
import 'package:ripple/core/utils/constants/constants.dart';
import 'package:ripple/core/utils/constants/routes.dart';
import 'package:ripple/core/utils/cubit/home/home_cubit.dart';
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
        final isDark = themeCubit.isDarkMode;
        final isArabic = themeCubit.isArabicLang;
        return Drawer(
          backgroundColor: ColorsManager.backgroundColor,
          child: Column(
            children: [
              const HomeDrawerHeader(),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  children: [
                    HomeDrawerTile(
                      title: appTranslation().get('home'),
                      icon: Icons.home_outlined,
                      onTap: () => context.pop,
                    ),
                    HomeDrawerTile(
                      title: appTranslation().get('profile'),
                      icon: Icons.person_outline_rounded,
                      onTap: () {
                        context.pop;
                        context.push<Object>(Routes.profile);
                      },
                    ),
                    HomeDrawerTile(
                      title: appTranslation().get('notifications'),
                      icon: Icons.notifications_none_rounded,
                      onTap: () {
                        context.pop;
                        context.push<Object>(Routes.notifications);
                      },
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 8,
                      ),
                      child: Divider(),
                    ),
                    HomeDrawerTile(
                      title: appTranslation().get('dark_mode'),
                      icon: isDark
                          ? Icons.dark_mode_outlined
                          : Icons.light_mode_outlined,
                      trailing: Switch.adaptive(
                        value: isDark,
                        activeThumbColor: ColorsManager.primary,
                        onChanged: (val) => themeCubit.changeTheme(),
                      ),
                    ),
                    HomeDrawerTile(
                      title: appTranslation().get('language'),
                      icon: Icons.translate_rounded,
                      trailing: Switch.adaptive(
                        value: isArabic,
                        activeThumbColor: ColorsManager.primary,
                        onChanged: (val) => themeCubit.toggleLanguage(),
                      ),
                    ),
                    HomeDrawerTile(
                      title: appTranslation().get('about_ripple'),
                      icon: Icons.info_outline_rounded,
                      onTap: () {
                        context.pop;
                        context.push<Object>(Routes.about);
                      },
                    ),
                  ],
                ),
              ),
              const Divider(height: 1),
              HomeDrawerTile(
                title: appTranslation().get('logout'),
                icon: Icons.logout_rounded,
                onTap: () => homeCubit.logout(),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Text(
                  "Ripple v1.0.0",
                  style: TextStylesManager.regular12.copyWith(
                    color: ColorsManager.textSecondaryColor.withValues(
                      alpha: 0.5,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
