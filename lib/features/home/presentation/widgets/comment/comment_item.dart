import 'package:flutter/material.dart';
import 'package:ripple/core/models/comment_model.dart';
import 'package:ripple/core/utils/constants/spacing.dart';
import 'package:ripple/core/utils/cubit/home/home_cubit.dart';
import 'package:ripple/features/home/presentation/widgets/comment/comment_action_buttons.dart';
import 'package:ripple/features/home/presentation/widgets/comment/comment_avatar.dart';
import 'package:ripple/features/home/presentation/widgets/comment/comment_bubble.dart';
import 'package:ripple/features/home/presentation/widgets/comment/comment_reply_input.dart';
import 'package:ripple/features/home/presentation/widgets/comment/comment_tree_lines.dart';

class CommentItem extends StatefulWidget {
  final String postId;
  final String postOwnerId;
  final CommentModel comment;
  final bool isReply;

  final bool isLast;

  const CommentItem({
    super.key,
    required this.postId,
    required this.postOwnerId,
    required this.comment,
    this.isReply = false,
    this.isLast = false,
  });

  @override
  State<CommentItem> createState() => _CommentItemState();
}

class _CommentItemState extends State<CommentItem> {
  bool isReplying = false;

  void toggleReplying() => setState(() => isReplying = !isReplying);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: widget.isReply ? 48.0 : 16.0,
        right: 16.0,
        top: 12.0,
        bottom: 4.0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (widget.isReply) CommentTreeLines(isLast: widget.isLast),
                CommentAvatar(
                  imageUrl: widget.comment.userProfilePic,
                  isReply: widget.isReply,
                  radius: widget.isReply ? 14 : 18,
                ),
                horizontalSpace12,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CommentBubble(
                        postId: widget.postId,
                        comment: widget.comment,
                        isMe: widget.comment.userId == homeCubit.userModel?.uid,
                        isReply: widget.isReply,
                      ),
                      verticalSpace4,
                      CommentActionButtons(
                        timestamp: widget.comment.timestamp.toDate(),
                        isReply: widget.isReply,
                        isReplying: isReplying,
                        onReplyTap: toggleReplying,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (isReplying)
            Padding(
              padding: const EdgeInsets.only(left: 48, top: 8),
              child: CommentReplyInput(
                postId: widget.postId,
                commentId: widget.comment.commentId,
                commentOwnerId: widget.comment.userId,
                onCancel: toggleReplying,
                onSuccess: () => setState(() => isReplying = false),
              ),
            ),
          _buildRepliesStream(),
        ],
      ),
    );
  }

  Widget _buildRepliesStream() {
    if (widget.isReply) return const SizedBox.shrink();

    return StreamBuilder<List<CommentModel>>(
      stream: homeCubit.postRepo.getRepliesStream(
        widget.postId,
        widget.comment.commentId,
      ),
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const SizedBox.shrink();
        }

        final replies = snapshot.data!;
        return Column(
          children: replies.asMap().entries.map((entry) {
            final index = entry.key;
            final reply = entry.value;
            final isLast = index == replies.length - 1;

            return CommentItem(
              postId: widget.postId,
              postOwnerId: widget.postOwnerId,
              comment: reply,
              isReply: true,
              isLast: isLast,
            );
          }).toList(),
        );
      },
    );
  }
}
