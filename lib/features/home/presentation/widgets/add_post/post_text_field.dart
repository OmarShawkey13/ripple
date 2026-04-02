import 'package:flutter/material.dart';
import 'package:ripple/core/theme/colors.dart';
import 'package:ripple/core/theme/text_styles.dart';
import 'package:ripple/core/utils/constants/constants.dart';
import 'package:ripple/core/utils/cubit/home/home_cubit.dart';

class PostTextField extends StatelessWidget {
  final FocusNode? focusNode;

  const PostTextField({super.key, this.focusNode});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: homeCubit.postTextController,
      focusNode: focusNode,
      maxLines: null,
      style: TextStylesManager.regular16.copyWith(
        height: 1.5,
      ),
      keyboardType: TextInputType.multiline,
      decoration: InputDecoration(
        hintText: appTranslation().get("what_on_your_mind"),
        hintStyle: TextStylesManager.regular16.copyWith(
          color: ColorsManager.textSecondaryColor.withValues(alpha: 0.5),
        ),
        border: InputBorder.none,
        contentPadding: const EdgeInsets.symmetric(vertical: 16),
      ),
    );
  }
}
