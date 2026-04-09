import 'package:flutter/material.dart';
import 'package:ripple/core/models/post_model.dart';
import 'package:ripple/features/home/presentation/widgets/post/post_images_list.dart';
import 'package:ripple/features/home/presentation/widgets/post/post_text.dart';

class PostContent extends StatelessWidget {
  final PostModel post;

  const PostContent({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    final hasText = post.text != null && post.text!.trim().isNotEmpty;
    final hasImages = post.imageUrls != null && post.imageUrls!.isNotEmpty;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (hasText)
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: PostText(text: post.text!),
          ),
        if (hasImages)
          PostImagesList(
            imageUrls: post.imageUrls!,
            postId: post.postId,
          ),
      ],
    );
  }
}
