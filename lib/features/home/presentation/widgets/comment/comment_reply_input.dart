import 'package:flutter/material.dart';
import 'package:ripple/core/theme/colors.dart';
import 'package:ripple/core/theme/text_styles.dart';
import 'package:ripple/core/utils/constants/constants.dart';
import 'package:ripple/core/utils/cubit/home/home_cubit.dart';

class CommentReplyInput extends StatefulWidget {
  final String postId;
  final String commentId;
  final String commentOwnerId;
  final VoidCallback onCancel;
  final VoidCallback onSuccess;

  const CommentReplyInput({
    super.key,
    required this.postId,
    required this.commentId,
    required this.commentOwnerId,
    required this.onCancel,
    required this.onSuccess,
  });

  @override
  State<CommentReplyInput> createState() => _CommentReplyInputState();
}

class _CommentReplyInputState extends State<CommentReplyInput> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleSend() async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    await homeCubit.addReply(
      postId: widget.postId,
      commentId: widget.commentId,
      commentOwnerId: widget.commentOwnerId,
      text: text,
    );
    _controller.clear();
    widget.onSuccess();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
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
                controller: _controller,
                autofocus: true,
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
              onPressed: widget.onCancel,
              icon: Icon(
                Icons.close_rounded,
                size: 20,
                color: ColorsManager.error.withValues(alpha: 0.5),
              ),
            ),
            IconButton(
              onPressed: _handleSend,
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
