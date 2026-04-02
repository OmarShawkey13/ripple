import 'package:flutter/material.dart';
import 'package:ripple/core/models/comment_model.dart';
import 'package:ripple/core/theme/colors.dart';
import 'package:ripple/core/theme/emoji_text.dart';
import 'package:ripple/core/theme/text_styles.dart';
import 'package:ripple/core/utils/constants/spacing.dart';
import 'package:ripple/features/home/presentation/widgets/comment/comment_context_menu.dart';

class CommentBubble extends StatelessWidget {
  final String postId;
  final CommentModel comment;
  final bool isMe;
  final bool isReply;

  const CommentBubble({
    super.key,
    required this.postId,
    required this.comment,
    required this.isMe,
    required this.isReply,
  });

  @override
  Widget build(BuildContext context) {
    return CommentContextMenu(
      isMe: isMe,
      postId: postId,
      comment: comment,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          EmojiText(
            text: comment.username,
            style: TextStylesManager.bold14.copyWith(
              color: ColorsManager.textColor,
            ),
          ),
          verticalSpace4,
          EmojiText(
            text: comment.text,
            style: TextStylesManager.regular14.copyWith(
              height: 1.4,
              color: ColorsManager.textColor,
            ),
          ),
        ],
      ),
    );
  }
}
