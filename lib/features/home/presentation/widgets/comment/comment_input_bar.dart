import 'package:flutter/material.dart';
import 'package:ripple/core/models/post_model.dart';
import 'package:ripple/core/theme/colors.dart';
import 'package:ripple/core/utils/cubit/home/home_cubit.dart';
import 'package:ripple/features/home/presentation/widgets/comment/comment_emoji_button.dart';
import 'package:ripple/features/home/presentation/widgets/comment/comment_input_field.dart';
import 'package:ripple/features/home/presentation/widgets/comment/comment_send_button.dart';

class CommentInputBar extends StatelessWidget {
  final bool isEmojiVisible;
  final FocusNode focusNode;
  final VoidCallback onEmojiToggle;
  final PostModel post;

  const CommentInputBar({
    super.key,
    required this.isEmojiVisible,
    required this.focusNode,
    required this.onEmojiToggle,
    required this.post,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: ColorsManager.cardColor,
        border: Border(
          top: BorderSide(
            color: ColorsManager.dividerColor.withValues(alpha: 0.1),
          ),
        ),
      ),
      child: SafeArea(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            CommentEmojiButton(
              isEmojiVisible: isEmojiVisible,
              onTap: () {
                onEmojiToggle();
                if (isEmojiVisible) {
                  focusNode.unfocus();
                } else {
                  focusNode.requestFocus();
                }
              },
            ),
            Expanded(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 4),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: ColorsManager.surfaceContainer,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: CommentInputField(
                  focusNode: focusNode,
                  controller: homeCubit.commentController,
                ),
              ),
            ),
            CommentSendButton(
              onSend: () {
                if (homeCubit.commentController.text.trim().isNotEmpty) {
                  homeCubit.addComment(post.postId, post.userId);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
