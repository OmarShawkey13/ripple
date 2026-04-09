import 'package:flutter/material.dart';
import 'package:ripple/core/theme/colors.dart';

class CommentSendButton extends StatelessWidget {
  final VoidCallback onSend;

  const CommentSendButton({super.key, required this.onSend});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onSend,
        borderRadius: BorderRadius.circular(24),
        child: Container(
          height: 44,
          width: 44,
          decoration: BoxDecoration(
            color: ColorsManager.primary,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: ColorsManager.primary.withValues(alpha: 0.3),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: const Icon(
            Icons.send_rounded,
            color: Colors.white,
            size: 20,
          ),
        ),
      ),
    );
  }
}
