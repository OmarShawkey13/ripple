import 'package:flutter/material.dart';
import 'package:ripple/core/models/post_model.dart';
import 'package:ripple/core/theme/colors.dart';
import 'package:ripple/core/utils/constants/spacing.dart';
import 'package:ripple/core/utils/cubit/home/home_cubit.dart';
import 'package:ripple/features/home/presentation/widgets/post/post_avatar.dart';
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
      padding: EdgeInsets.fromLTRB(
        16,
        8,
        16,
        MediaQuery.of(context).viewInsets.bottom + 12,
      ),
      decoration: BoxDecoration(
        color: ColorsManager.cardColor,
        boxShadow: [
          BoxShadow(
            color: ColorsManager.shadowColor,
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            PostAvatar(
              userProfilePic: homeCubit.userModel?.photoUrl,
              userId: homeCubit.userModel?.uid ?? '',
              radius: 18,
            ),
            horizontalSpace12,
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: ColorsManager.surfaceContainer,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: ColorsManager.outline.withValues(alpha: 0.5),
                    width: 0.5,
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: CommentInputField(
                        focusNode: focusNode,
                        controller: homeCubit.commentController,
                      ),
                    ),
                    CommentEmojiButton(
                      isEmojiVisible: isEmojiVisible,
                      onTap: onEmojiToggle,
                    ),
                  ],
                ),
              ),
            ),
            horizontalSpace12,
            CommentSendButton(
              onSend: () => homeCubit.addComment(post.postId, post.userId),
            ),
          ],
        ),
      ),
    );
  }
}
