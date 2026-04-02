import 'package:flutter/material.dart';
import 'package:ripple/core/utils/constants/constants.dart';
import 'package:ripple/core/utils/constants/primary/primary_text_field.dart';
import 'package:ripple/core/utils/cubit/home/home_cubit.dart';

class PostTextField extends StatelessWidget {
  final FocusNode? focusNode;

  const PostTextField({super.key, this.focusNode});

  @override
  Widget build(BuildContext context) {
    return PrimaryTextField(
      controller: homeCubit.postTextController,
      focusNode: focusNode,
      hintText: appTranslation().get("what_on_your_mind"),
      maxLines: null,
      useCardDecoration: false,
      keyboardType: TextInputType.multiline,
    );
  }
}
