import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:ripple/core/theme/colors.dart';
import 'package:ripple/core/utils/constants/primary/image_preview_page.dart';
import 'package:ripple/core/utils/constants/primary/loading_indicator.dart';

class PostImage extends StatelessWidget {
  final String imageUrl;
  final String postId;

  const PostImage({
    super.key,
    required this.imageUrl,
    required this.postId,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _navigateToPreview(context),
      child: Hero(
        tag: imageUrl,
        child: Container(
          width: double.infinity,
          constraints: const BoxConstraints(
            minHeight: 150,
            maxHeight: 320,
          ),
          decoration: BoxDecoration(
            color: ColorsManager.surfaceContainer,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: ColorsManager.outline.withValues(alpha: 0.2),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: CachedNetworkImage(
              imageUrl: imageUrl,
              fit: BoxFit.cover,
              placeholder: (context, url) => const _ImagePlaceholder(),
              errorWidget: (context, url, error) => const _ImageErrorWidget(),
            ),
          ),
        ),
      ),
    );
  }

  void _navigateToPreview(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute<Object>(
        builder: (context) => ImagePreviewPage(url: imageUrl),
      ),
    );
  }
}

class _ImagePlaceholder extends StatelessWidget {
  const _ImagePlaceholder();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: LoadingIndicator(strokeWidth: 1.5),
    );
  }
}

class _ImageErrorWidget extends StatelessWidget {
  const _ImageErrorWidget();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: ColorsManager.surfaceContainer,
      child: Icon(
        Icons.broken_image_rounded,
        size: 32,
        color: ColorsManager.textSecondaryColor.withValues(alpha: 0.5),
      ),
    );
  }
}
