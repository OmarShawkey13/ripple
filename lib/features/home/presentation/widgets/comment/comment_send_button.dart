import 'package:flutter/material.dart';
import 'package:ripple/core/theme/colors.dart';

class CommentSendButton extends StatelessWidget {
  final VoidCallback onSend;

  const CommentSendButton({super.key, required this.onSend});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: ColorsManager.primary,
        shape: BoxShape.circle,
      ),
      child: IconButton(
        icon: const Icon(
          Icons.send_rounded,
          color: Colors.white,
          size: 20,
        ),
        onPressed: onSend,
        visualDensity: VisualDensity.compact,
      ),
    );
  }
}
