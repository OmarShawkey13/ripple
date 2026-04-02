import 'package:flutter/material.dart';
import 'package:ripple/core/theme/colors.dart';
import 'package:ripple/core/utils/constants/constants.dart';
import 'package:ripple/core/utils/constants/routes.dart';
import 'package:ripple/core/utils/cubit/home/home_cubit.dart';
import 'package:ripple/core/utils/extensions/context_extension.dart';

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  const HomeAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: true,
      leading: IconButton(
        onPressed: () => Scaffold.of(context).openDrawer(),
        icon: const Icon(Icons.menu_rounded, size: 28),
      ),
      title: Text(
        appTranslation().get("app_name"),
        style: const TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          letterSpacing: -1,
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Stack(
            alignment: Alignment.center,
            children: [
              IconButton(
                onPressed: () => context.push<Object>(Routes.notifications),
                icon: const Icon(Icons.notifications_none_rounded, size: 28),
              ),
              if (homeCubit.unreadNotificationsCount > 0)
                Positioned(
                  top: 12,
                  right: 12,
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: ColorsManager.error,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
