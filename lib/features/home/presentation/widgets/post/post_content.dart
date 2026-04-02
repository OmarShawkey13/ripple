import 'package:flutter/material.dart';
import 'package:ripple/core/models/post_model.dart';
import 'package:ripple/core/theme/colors.dart';
import 'package:ripple/core/theme/emoji_text.dart';
import 'package:ripple/core/theme/text_styles.dart';
import 'package:ripple/core/utils/constants/spacing.dart';
import 'package:ripple/features/home/presentation/widgets/post/post_image.dart';

class PostContent extends StatelessWidget {
  final PostModel post;

  const PostContent({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    final hasText = post.text != null && post.text!.trim().isNotEmpty;
    final hasImage = post.imageUrl != null && post.imageUrl!.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (hasText)
          Padding(
            padding: const EdgeInsets.only(top: 2, bottom: 8),
            child: EmojiText(
              text: post.text!,
              style: TextStylesManager.regular16.copyWith(
                height: 1.4,
                color: ColorsManager.textColor.withValues(alpha: 0.95),
                letterSpacing: 0.1,
              ),
            ),
          ),
        if (hasImage)
          Column(
            children: [
              if (!hasText) verticalSpace4,
              PostImage(
                imageUrl: post.imageUrl!,
                postId: post.postId,
              ),
              verticalSpace4,
            ],
          ),
      ],
    );
  }
}
