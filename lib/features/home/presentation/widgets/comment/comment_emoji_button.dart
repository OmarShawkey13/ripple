import 'package:flutter/material.dart';
import 'package:ripple/core/theme/colors.dart';

class CommentEmojiButton extends StatelessWidget {
  final bool isEmojiVisible;
  final VoidCallback onTap;

  const CommentEmojiButton({
    super.key,
    required this.isEmojiVisible,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        isEmojiVisible ? Icons.keyboard_rounded : Icons.emoji_emotions_outlined,
        size: 24,
      ),
      color: ColorsManager.primary,
      onPressed: onTap,
    );
  }
}
