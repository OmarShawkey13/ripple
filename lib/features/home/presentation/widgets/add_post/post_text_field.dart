import 'package:flutter/material.dart';
import 'package:ripple/core/utils/constants/constants.dart';
import 'package:ripple/core/utils/cubit/home_cubit.dart';

class PostTextField extends StatelessWidget {
  const PostTextField({super.key});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: homeCubit.postTextController,
      decoration: InputDecoration(
        hintText: appTranslation().get("what_on_your_mind"),
        border: InputBorder.none,
      ),
      maxLines: null,
    );
  }
}
