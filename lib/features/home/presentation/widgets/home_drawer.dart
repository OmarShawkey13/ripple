import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ripple/core/theme/colors.dart';
import 'package:ripple/core/theme/text_styles.dart';
import 'package:ripple/core/utils/constants/constants.dart';
import 'package:ripple/core/utils/constants/routes.dart';
import 'package:ripple/core/utils/constants/spacing.dart';
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
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.horizontal(
              right: Radius.circular(32),
            ),
          ),
          child: Column(
            children: [
              const HomeDrawerHeader(),
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 20,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildSectionHeader(appTranslation().get('home')),
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
                        verticalSpace24,
                        _buildSectionHeader(appTranslation().get('settings')),
                        HomeDrawerTile(
                          title: appTranslation().get('dark_mode'),
                          icon: isDark
                              ? Icons.dark_mode_rounded
                              : Icons.light_mode_rounded,
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
                        verticalSpace24,
                        _buildSectionHeader(
                          appTranslation().get('about_ripple'),
                        ),
                        HomeDrawerTile(
                          title: appTranslation().get('about_ripple'),
                          icon: Icons.info_rounded,
                          onTap: () {
                            context.pop;
                            context.push<Object>(Routes.about);
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              _buildLogoutButton(),
              Padding(
                padding: const EdgeInsets.only(bottom: 20, top: 10),
                child: Text(
                  appTranslation().get('ripple_version'),
                  style: TextStylesManager.medium12.copyWith(
                    color: ColorsManager.textSecondaryColor.withValues(
                      alpha: 0.4,
                    ),
                    letterSpacing: 1.2,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 12, bottom: 12, right: 12),
      child: Text(
        title.toUpperCase(),
        style: TextStylesManager.bold12.copyWith(
          color: ColorsManager.primary,
          letterSpacing: 1.1,
        ),
      ),
    );
  }

  Widget _buildLogoutButton() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: InkWell(
        onTap: () => homeCubit.logout(),
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
          decoration: BoxDecoration(
            color: ColorsManager.error.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: ColorsManager.error.withValues(alpha: 0.1),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.logout_rounded,
                color: ColorsManager.error,
                size: 20,
              ),
              horizontalSpace12,
              Text(
                appTranslation().get('logout'),
                style: TextStylesManager.bold14.copyWith(
                  color: ColorsManager.error,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
