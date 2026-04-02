import 'package:flutter/material.dart';
import 'package:ripple/core/theme/colors.dart';
import 'package:ripple/core/theme/text_styles.dart';
import 'package:ripple/core/utils/constants/constants.dart';
import 'package:ripple/core/utils/extensions/context_extension.dart';

class EditProfileAppBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback onSave;
  final bool isLoading;

  const EditProfileAppBar({
    super.key,
    required this.onSave,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: ColorsManager.backgroundColor,
      elevation: 0,
      centerTitle: true,
      leading: IconButton(
        icon: Icon(Icons.close_rounded, color: ColorsManager.textColor),
        onPressed: () => context.pop,
      ),
      title: Text(
        appTranslation().get('edit_profile'),
        style: TextStylesManager.bold18,
      ),
      actions: [
        if (!isLoading)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: TextButton(
              onPressed: onSave,
              child: Text(
                appTranslation().get('save'),
                style: TextStylesManager.bold16.copyWith(
                  color: ColorsManager.primary,
                ),
              ),
            ),
          ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
