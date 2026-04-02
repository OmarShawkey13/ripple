import 'package:flutter/material.dart';
import 'package:ripple/core/theme/colors.dart';
import 'package:ripple/core/theme/text_styles.dart';
import 'package:ripple/core/utils/constants/constants.dart';

class CommentReplyInput extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onSend;

  const CommentReplyInput({
    super.key,
    required this.controller,
    required this.onSend,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 44, top: 8, bottom: 8),
      child: Container(
        decoration: BoxDecoration(
          color: ColorsManager.surfaceContainer.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: ColorsManager.primary.withValues(alpha: 0.1),
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: controller,
                style: TextStylesManager.regular14,
                decoration: InputDecoration(
                  hintText: '${appTranslation().get('add_reply')}...',
                  hintStyle: TextStyle(
                    color: ColorsManager.primary.withValues(alpha: 0.4),
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  isDense: true,
                ),
              ),
            ),
            IconButton(
              onPressed: onSend,
              icon: const Icon(
                Icons.send_rounded,
                color: ColorsManager.primary,
                size: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
