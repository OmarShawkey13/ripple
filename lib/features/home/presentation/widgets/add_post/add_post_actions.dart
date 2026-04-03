import 'package:flutter/material.dart';
import 'package:ripple/core/theme/colors.dart';
import 'package:ripple/core/utils/constants/spacing.dart';

class AddPostActions extends StatelessWidget {
  final bool isEmojiVisible;
  final FocusNode focusNode;
  final VoidCallback onEmojiToggle;
  final void Function() onTapImage;

  const AddPostActions({
    super.key,
    required this.isEmojiVisible,
    required this.focusNode,
    required this.onEmojiToggle,
    required this.onTapImage,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: ColorsManager.backgroundColor,
        border: Border(
          top: BorderSide(
            color: ColorsManager.dividerColor.withValues(alpha: 0.1),
          ),
        ),
      ),
      child: Row(
        children: [
          _ActionButton(
            icon: Icons.image_outlined,
            label: 'Photo',
            color: Colors.green,
            onTap: onTapImage,
          ),
          horizontalSpace24,
          _ActionButton(
            icon: isEmojiVisible
                ? Icons.keyboard_outlined
                : Icons.emoji_emotions_outlined,
            label: 'Emoji',
            color: Colors.orange,
            onTap: () {
              onEmojiToggle();
              if (isEmojiVisible) {
                focusNode.unfocus();
              } else {
                focusNode.requestFocus();
              }
            },
          ),
          const Spacer(),
          IconButton(
            icon: const Icon(Icons.more_horiz),
            color: ColorsManager.textSecondaryColor,
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 22),
          horizontalSpace8,
          Text(
            label,
            style: TextStyle(
              color: ColorsManager.textSecondaryColor,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
