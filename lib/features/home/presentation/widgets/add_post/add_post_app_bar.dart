import 'package:flutter/material.dart';
import 'package:ripple/core/theme/colors.dart';
import 'package:ripple/core/theme/text_styles.dart';
import 'package:ripple/core/utils/constants/constants.dart';
import 'package:ripple/core/utils/cubit/home_cubit.dart';
import 'package:ripple/core/utils/extensions/context_extension.dart';

class AddPostAppBar extends StatelessWidget implements PreferredSizeWidget {
  const AddPostAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new),
        onPressed: () => context.pop,
      ),
      title: Text(appTranslation().get("add_post")),
      centerTitle: true,
      actions: [
        TextButton(
          onPressed: () {
            homeCubit.addPost(homeCubit.postTextController.text);
          },
          child: Text(
            appTranslation().get("post"),
            style: TextStylesManager.regular14.copyWith(
              color: ColorsManager.primary,
            ),
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
