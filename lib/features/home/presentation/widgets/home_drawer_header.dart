import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ripple/core/theme/colors.dart';
import 'package:ripple/core/theme/emoji_text.dart';
import 'package:ripple/core/theme/text_styles.dart';
import 'package:ripple/core/utils/constants/assets_helper.dart';
import 'package:ripple/core/utils/constants/spacing.dart';
import 'package:ripple/core/utils/cubit/home/home_cubit.dart';
import 'package:ripple/core/utils/cubit/home/home_state.dart';

class HomeDrawerHeader extends StatelessWidget {
  const HomeDrawerHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeStates>(
      buildWhen: (previous, current) =>
          current is HomeUpdateProfileSuccessState ||
          current is HomeGetCurrentUserSuccessState,
      builder: (context, state) {
        final user = homeCubit.userModel;
        return Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: ColorsManager.surfaceContainer,
            image: user?.coverUrl != null && user!.coverUrl!.isNotEmpty
                ? DecorationImage(
                    image: CachedNetworkImageProvider(user.coverUrl!),
                    fit: BoxFit.cover,
                    colorFilter: ColorFilter.mode(
                      Colors.black.withValues(alpha: 0.4),
                      BlendMode.darken,
                    ),
                  )
                : null,
          ),
          child: SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: ColorsManager.primary.withValues(alpha: 0.2),
                        width: 2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: CircleAvatar(
                      radius: 40,
                      backgroundColor: ColorsManager.cardColor,
                      backgroundImage:
                          user?.photoUrl != null && user!.photoUrl!.isNotEmpty
                          ? CachedNetworkImageProvider(user.photoUrl!)
                          : const AssetImage(AssetsHelper.logo),
                    ),
                  ),
                  verticalSpace16,
                  EmojiText(
                    text: user?.username ?? 'Ripple User',
                    style: TextStylesManager.bold20.copyWith(
                      color:
                          user?.coverUrl != null && user!.coverUrl!.isNotEmpty
                          ? Colors.white
                          : ColorsManager.textColor,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  verticalSpace4,
                  EmojiText(
                    text: user?.bio ?? 'ripple social app',
                    style: TextStylesManager.regular14.copyWith(
                      color:
                          user?.coverUrl != null && user!.coverUrl!.isNotEmpty
                          ? Colors.white.withValues(alpha: 0.8)
                          : ColorsManager.textSecondaryColor,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
