import 'package:flutter/material.dart';
import 'package:ripple/core/theme/colors.dart';
import 'package:ripple/core/theme/text_styles.dart';
import 'package:ripple/core/utils/constants/constants.dart';

class CommentInputField extends StatelessWidget {
  final FocusNode focusNode;
  final TextEditingController controller;

  const CommentInputField({
    super.key,
    required this.focusNode,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      focusNode: focusNode,
      controller: controller,
      style: TextStylesManager.regular14,
      maxLines: 4,
      minLines: 1,
      decoration: InputDecoration(
        hintText: appTranslation().get('add_comment'),
        hintStyle: TextStylesManager.regular14.copyWith(
          color: ColorsManager.textSecondaryColor.withValues(alpha: 0.5),
        ),
        border: InputBorder.none,
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(vertical: 10),
      ),
    );
  }
}
