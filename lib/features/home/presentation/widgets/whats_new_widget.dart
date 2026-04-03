import 'package:cached_network_image/cached_network_image.dart';
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

class WhatsNewWidget extends StatelessWidget {
  const WhatsNewWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeState>(
      builder: (context, state) {
        return Column(
          children: [
            InkWell(
              onTap: () => context.push<Object>(Routes.addPost),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 12.0,
                ),
                child: Row(
                  children: [
                    BlocBuilder<HomeCubit, HomeStates>(
                      buildWhen: (previous, current) =>
                          current is HomeGetCurrentUserSuccessState,
                      builder: (context, state) {
                        final user = homeCubit.userModel;
                        return Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: ColorsManager.outline.withValues(
                                alpha: 0.5,
                              ),
                              width: 1,
                            ),
                          ),
                          child: CircleAvatar(
                            radius: 18,
                            backgroundColor: ColorsManager.surfaceContainer,
                            backgroundImage:
                                user?.photoUrl != null &&
                                    user!.photoUrl!.isNotEmpty
                                ? CachedNetworkImageProvider(user.photoUrl!)
                                : null,
                            child:
                                user?.photoUrl == null ||
                                    user!.photoUrl!.isEmpty
                                ? Icon(
                                    Icons.person_outline,
                                    size: 20,
                                    color: ColorsManager.textSecondaryColor,
                                  )
                                : null,
                          ),
                        );
                      },
                    ),
                    horizontalSpace12,
                    Expanded(
                      child: Text(
                        appTranslation().get("what_on_your_mind"),
                        style: TextStylesManager.regular14.copyWith(
                          color: ColorsManager.textSecondaryColor,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: ColorsManager.outline.withValues(alpha: 0.8),
                        ),
                      ),
                      child: Text(
                        appTranslation().get("post"),
                        style: TextStylesManager.bold12.copyWith(
                          color: ColorsManager.textSecondaryColor.withValues(
                            alpha: 0.7,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Divider(
              height: 1,
              thickness: 0.5,
              color: ColorsManager.outline.withValues(alpha: 0.5),
            ),
          ],
        );
      },
    );
  }
}
