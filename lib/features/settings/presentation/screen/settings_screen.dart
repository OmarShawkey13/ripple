import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ripple/core/network/local/cache_helper.dart';
import 'package:ripple/core/theme/colors.dart';
import 'package:ripple/core/utils/constants/constants.dart';
import 'package:ripple/core/utils/constants/spacing.dart';
import 'package:ripple/core/utils/cubit/home_cubit.dart';
import 'package:ripple/core/utils/cubit/home_state.dart';
import 'package:ripple/core/utils/extensions/context_extension.dart';
import 'package:ripple/features/settings/presentation/widgets/settings_tile.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeStates>(
      buildWhen: (previous, current) =>
          current is HomeChangeThemeState ||
          current is HomeLanguageUpdatedState ||
          current is HomeLanguageLoadedState,
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new),
              onPressed: () => context.pop,
            ),
            title: Text(appTranslation().get('settings')),
            centerTitle: true,
          ),
          body: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                SettingsTile(
                  icon: homeCubit.isDarkMode
                      ? Icons.dark_mode
                      : Icons.light_mode,
                  title: appTranslation().get('app_theme'),
                  subtitle: homeCubit.isDarkMode
                      ? appTranslation().get('dark_mode')
                      : appTranslation().get('light_mode'),
                  trailing: Switch(
                    value: homeCubit.isDarkMode,
                    activeThumbColor: ColorsManager.primary,
                    onChanged: (_) => homeCubit.changeTheme(),
                  ),
                ),
                verticalSpace12,
                SettingsTile(
                  icon: Icons.language,
                  title: appTranslation().get('language'),
                  subtitle: homeCubit.isArabicLang ? 'العربية' : 'English',
                  trailing: Switch(
                    value: homeCubit.isArabicLang,
                    activeThumbColor: ColorsManager.primary,
                    onChanged: (_) async {
                      final isArabic = !homeCubit.isArabicLang;
                      final jsonString = await rootBundle.loadString(
                        'assets/translations/${isArabic ? 'ar' : 'en'}.json',
                      );
                      homeCubit.changeLanguage(
                        isArabic: isArabic,
                        translations: jsonString,
                      );
                      CacheHelper.saveData(
                        key: 'isArabicLang',
                        value: isArabic,
                      );
                    },
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
