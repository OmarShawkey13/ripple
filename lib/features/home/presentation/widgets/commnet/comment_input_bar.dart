import 'package:flutter/material.dart';
import 'package:ripple/core/models/post_model.dart';
import 'package:ripple/core/theme/colors.dart';
import 'package:ripple/core/utils/constants/constants.dart';
import 'package:ripple/core/utils/constants/spacing.dart';
import 'package:ripple/core/utils/cubit/home_cubit.dart';

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
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          IconButton(
            icon: Icon(
              isEmojiVisible ? Icons.keyboard : Icons.emoji_emotions_outlined,
            ),
            color: ColorsManager.primary,
            onPressed: () {
              onEmojiToggle();
              isEmojiVisible
                  ? focusNode.unfocus()
                  : FocusScope.of(context).requestFocus(focusNode);
            },
          ),
          Expanded(
            child: TextFormField(
              focusNode: focusNode,
              controller: homeCubit.commentController,
              decoration: InputDecoration(
                hintText: appTranslation().get('add_comment'),
                border: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                ),
              ),
            ),
          ),
          horizontalSpace8,
          IconButton(
            icon: const Icon(Icons.send),
            color: ColorsManager.primary,
            onPressed: () {
              if (homeCubit.commentController.text.isNotEmpty) {
                homeCubit.addComment(post.postId, post.userId);
              }
            },
          ),
        ],
      ),
    );
  }
}
