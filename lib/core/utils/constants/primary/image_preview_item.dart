import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:ripple/core/utils/constants/primary/image_error_widget.dart';
import 'package:ripple/core/utils/constants/primary/image_placeholder.dart';

class ImagePreviewItem extends StatelessWidget {
  final String imageUrl;

  const ImagePreviewItem({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: InteractiveViewer(
        maxScale: 5.0,
        minScale: 1.0,
        child: CachedNetworkImage(
          imageUrl: imageUrl,
          fit: BoxFit.contain,
          width: double.infinity,
          height: double.infinity,
          placeholder: (context, url) => const ImagePlaceholder(),
          errorWidget: (context, url, error) => const ImageErrorWidget(),
        ),
      ),
    );
  }
}
