import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ripple/core/theme/colors.dart';
import 'package:ripple/core/theme/text_styles.dart';
import 'package:ripple/core/utils/constants/constants.dart';
import 'package:ripple/core/utils/constants/routes.dart';
import 'package:ripple/core/utils/constants/spacing.dart';
import 'package:ripple/core/utils/cubit/home/home_cubit.dart';
import 'package:ripple/core/utils/cubit/home/home_state.dart';
import 'package:ripple/core/utils/extensions/context_extension.dart';
import 'package:ripple/features/home/presentation/widgets/post/post_avatar.dart';

class WhatsNewWidget extends StatelessWidget {
  const WhatsNewWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: () => context.push<Object>(Routes.addPost),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 16.0,
            ),
            child: Row(
              children: [
                BlocBuilder<HomeCubit, HomeStates>(
                  buildWhen: (previous, current) =>
                      current is HomeGetCurrentUserSuccessState,
                  builder: (context, state) {
                    final user = homeCubit.userModel;
                    return PostAvatar(
                      userProfilePic: user?.photoUrl,
                      userId: user?.uid ?? '',
                    );
                  },
                ),
                horizontalSpace12,
                Expanded(
                  child: Text(
                    appTranslation().get("what_on_your_mind"),
                    style: TextStylesManager.regular14.copyWith(
                      color: ColorsManager.textSecondaryColor.withValues(
                        alpha: 0.7,
                      ),
                    ),
                  ),
                ),
                _PostActionSmallButton(),
              ],
            ),
          ),
        ),
        Divider(
          height: 1,
          thickness: 0.5,
          color: ColorsManager.outline.withValues(alpha: 0.2),
        ),
      ],
    );
  }
}

class _PostActionSmallButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: ColorsManager.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        appTranslation().get("post"),
        style: TextStylesManager.bold12.copyWith(
          color: ColorsManager.primary,
        ),
      ),
    );
  }
}
