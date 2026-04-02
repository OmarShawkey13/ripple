import 'package:flutter/material.dart';
import 'package:ripple/core/theme/colors.dart';
import 'package:ripple/core/theme/text_styles.dart';
import 'package:ripple/core/utils/constants/constants.dart';
import 'package:ripple/core/utils/cubit/home/home_cubit.dart';
import 'package:ripple/core/utils/extensions/context_extension.dart';

class AddPostAppBar extends StatelessWidget implements PreferredSizeWidget {
  const AddPostAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: ColorsManager.backgroundColor,
      elevation: 0,
      leadingWidth: 80,
      leading: TextButton(
        onPressed: () => context.pop,
        child: Text(
          appTranslation().get("cancel"),
          style: TextStylesManager.regular14.copyWith(
            color: ColorsManager.textSecondaryColor,
          ),
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 16, top: 8, bottom: 8),
          child: FilledButton(
            onPressed: () {
              if (homeCubit.postTextController.text.trim().isNotEmpty ||
                  homeCubit.postImage != null) {
                homeCubit.addPost(homeCubit.postTextController.text);
              }
            },
            style: FilledButton.styleFrom(
              backgroundColor: ColorsManager.primary,
              padding: const EdgeInsets.symmetric(horizontal: 24),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            child: Text(
              appTranslation().get("post"),
              style: TextStylesManager.bold14.copyWith(color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
