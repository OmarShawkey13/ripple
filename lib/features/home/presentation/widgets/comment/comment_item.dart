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
  final CommentModel comment;
  final bool isReply;
  final bool isLast;

  const CommentItem({
    super.key,
    required this.postId,
    required this.comment,
    this.isReply = false,
    this.isLast = false,
  });

  @override
  State<CommentItem> createState() => _CommentItemState();
}

class _CommentItemState extends State<CommentItem> {
  bool isReplying = false;
  final TextEditingController replyController = TextEditingController();

  @override
  void dispose() {
    replyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isMe = homeCubit.userModel?.uid == widget.comment.userId;

    return RepaintBoundary(
      child: Container(
        padding: EdgeInsets.only(
          left: widget.isReply ? 0 : 16,
          right: 16,
          top: 4,
          bottom: 4,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (widget.isReply)
                  SizedBox(
                    height: 40, // Height matching avatar area for tree lines
                    child: CommentTreeLines(isLast: widget.isLast),
                  ),
                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CommentAvatar(
                        imageUrl: widget.comment.userProfilePic,
                        isReply: widget.isReply,
                      ),
                      horizontalSpace12,
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CommentBubble(
                              postId: widget.postId,
                              comment: widget.comment,
                              isMe: isMe,
                              isReply: widget.isReply,
                            ),
                            CommentActionButtons(
                              timestamp: widget.comment.timestamp.toDate(),
                              isReply: widget.isReply,
                              isReplying: isReplying,
                              onReplyTap: () =>
                                  setState(() => isReplying = !isReplying),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            if (isReplying)
              Padding(
                padding: EdgeInsets.only(left: widget.isReply ? 44 : 44),
                child: CommentReplyInput(
                  controller: replyController,
                  onSend: _handleSendReply,
                ),
              ),
            if (widget.comment.replies.isNotEmpty) _buildRepliesList(),
          ],
        ),
      ),
    );
  }

  Future<void> _handleSendReply() async {
    final text = replyController.text.trim();
    if (text.isNotEmpty) {
      await homeCubit.addReply(
        postId: widget.postId,
        commentId: widget.comment.commentId,
        commentOwnerId: widget.comment.userId,
        text: text,
      );
      replyController.clear();
      setState(() => isReplying = false);
    }
  }

  Widget _buildRepliesList() {
    return Padding(
      padding: const EdgeInsets.only(left: 8),
      child: Column(
        children: widget.comment.replies.asMap().entries.map((entry) {
          return CommentItem(
            postId: widget.postId,
            comment: entry.value,
            isReply: true,
            isLast: entry.key == widget.comment.replies.length - 1,
          );
        }).toList(),
      ),
    );
  }
}
