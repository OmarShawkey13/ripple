import 'package:flutter/material.dart';
import 'package:ripple/core/theme/colors.dart';
import 'package:ripple/core/theme/text_styles.dart';
import 'package:ripple/core/utils/constants/constants.dart';
import 'package:ripple/core/utils/constants/primary/conditional_builder.dart';
import 'package:ripple/core/utils/constants/routes.dart';
import 'package:ripple/core/utils/cubit/home/home_cubit.dart';
import 'package:ripple/core/utils/extensions/context_extension.dart';

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  const HomeAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        appTranslation().get("app_name"),
      ),
      actions: [
        Stack(
          alignment: Alignment.center,
          children: [
            IconButton(
              onPressed: () => context.push<Object>(Routes.notifications),
              icon: const Icon(Icons.notifications),
            ),
            ConditionalBuilder(
              loadingState: homeCubit.unreadNotificationsCount > 0,
              successBuilder: (context) => Positioned(
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
                    style: TextStylesManager.bold12.copyWith(
                      color: ColorsManager.lightCard,
                      fontSize: 10,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              loadingBuilder: (context) => const SizedBox.shrink(),
            ),
          ],
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
