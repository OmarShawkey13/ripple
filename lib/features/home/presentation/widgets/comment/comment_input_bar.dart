import 'package:flutter/material.dart';
import 'package:ripple/core/models/post_model.dart';
import 'package:ripple/core/theme/colors.dart';
import 'package:ripple/core/utils/constants/spacing.dart';
import 'package:ripple/core/utils/cubit/home/home_cubit.dart';
import 'package:ripple/features/home/presentation/widgets/comment/comment_avatar.dart';
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
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      decoration: BoxDecoration(
        color: ColorsManager.cardColor,
        border: Border(
          top: BorderSide(
            color: ColorsManager.outline.withValues(alpha: 0.1),
            width: 0.5,
          ),
        ),
      ),
      child: SafeArea(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: CommentAvatar(
                imageUrl: homeCubit.userModel?.photoUrl,
                isReply: true,
              ),
            ),
            horizontalSpace12,
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: ColorsManager.surfaceContainer.withValues(alpha: 0.7),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: ColorsManager.outline.withValues(alpha: 0.2),
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    horizontalSpace4,
                    CommentEmojiButton(
                      isEmojiVisible: isEmojiVisible,
                      onTap: onEmojiToggle,
                    ),
                    Expanded(
                      child: CommentInputField(
                        focusNode: focusNode,
                        controller: homeCubit.commentController,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            horizontalSpace8,
            Padding(
              padding: const EdgeInsets.only(bottom: 2),
              child: CommentSendButton(
                onSend: () {
                  if (homeCubit.commentController.text.trim().isNotEmpty) {
                    homeCubit.addComment(post.postId, post.userId);
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
