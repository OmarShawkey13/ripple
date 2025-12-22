import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ripple/core/models/comment_model.dart';
import 'package:ripple/core/theme/colors.dart';
import 'package:ripple/core/theme/emoji_text.dart';
import 'package:ripple/core/theme/text_styles.dart';
import 'package:ripple/core/utils/constants/spacing.dart';
import 'package:ripple/core/utils/cubit/home_cubit.dart';
import 'package:ripple/features/home/presentation/widgets/commnet/comment_context_menu.dart';

class CommentItem extends StatelessWidget {
  final String postId;
  final CommentModel comment;

  const CommentItem({
    super.key,
    required this.postId,
    required this.comment,
  });

  @override
  Widget build(BuildContext context) {
    final isMe = homeCubit.userModel?.uid == comment.userId;

    final card = Card(
      elevation: 0.2,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      color: ColorsManager.cardColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            CircleAvatar(
              radius: 18,
              backgroundImage: comment.userProfilePic.isNotEmpty
                  ? CachedNetworkImageProvider(comment.userProfilePic)
                  : null,
              child: comment.userProfilePic.isEmpty
                  ? const Icon(Icons.person, size: 18)
                  : null,
            ),
            horizontalSpace12,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  EmojiText(
                    text: comment.username,
                    style: TextStylesManager.bold14,
                  ),
                  verticalSpace4,
                  EmojiText(
                    text: comment.text,
                    style: TextStylesManager.regular14,
                  ),
                  verticalSpace4,
                  Text(
                    DateFormat.yMMMd()
                        .add_jm()
                        .format(comment.timestamp.toDate()),
                    style: TextStylesManager.regular12.copyWith(
                      color: ColorsManager.textSecondaryColor,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );

    return CommentContextMenu(
      isMe: isMe,
      postId: postId,
      comment: comment,
      child: card,
    );
  }
}
