import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:ripple/core/utils/constants/primary/image_error_widget.dart';
import 'package:ripple/core/utils/constants/primary/image_placeholder.dart';

class PostImage extends StatelessWidget {
  final String imageUrl;
  final String postId;
  final List<String> allImageUrls;
  final int index;

  const PostImage({
    super.key,
    required this.imageUrl,
    required this.postId,
    required this.allImageUrls,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: CachedNetworkImage(
        imageUrl: imageUrl,
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
        placeholder: (context, url) => const ImagePlaceholder(),
        errorWidget: (context, url, error) => const ImageErrorWidget(),
      ),
    );
  }
}
