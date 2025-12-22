import 'package:flutter/material.dart';
import 'package:ripple/core/theme/colors.dart';
import 'package:ripple/core/utils/cubit/home_cubit.dart';

class AddPostActions extends StatelessWidget {
  final bool isEmojiVisible;
  final FocusNode focusNode;
  final VoidCallback onEmojiToggle;

  const AddPostActions({
    super.key,
    required this.isEmojiVisible,
    required this.focusNode,
    required this.onEmojiToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.photo_library),
            color: ColorsManager.primary,
            onPressed: homeCubit.pickPostImage,
          ),
          IconButton(
            icon: Icon(
              isEmojiVisible
                  ? Icons.keyboard
                  : Icons.emoji_emotions_outlined,
            ),
            color: ColorsManager.primary,
            onPressed: () {
              onEmojiToggle();
              isEmojiVisible
                  ? focusNode.unfocus()
                  : FocusScope.of(context).requestFocus(focusNode);
            },
          ),
        ],
      ),
    );
  }
}
