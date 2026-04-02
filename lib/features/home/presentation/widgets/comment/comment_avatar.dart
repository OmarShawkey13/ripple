import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:ripple/core/theme/colors.dart';

class CommentAvatar extends StatelessWidget {
  final String? imageUrl;
  final bool isReply;

  const CommentAvatar({
    super.key,
    required this.imageUrl,
    this.isReply = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: ColorsManager.primary.withValues(alpha: 0.1),
          width: 1,
        ),
      ),
      child: CircleAvatar(
        radius: isReply ? 16 : 20,
        backgroundColor: ColorsManager.primary.withValues(alpha: 0.1),
        backgroundImage: imageUrl != null && imageUrl!.isNotEmpty
            ? CachedNetworkImageProvider(imageUrl!)
            : null,
        child: imageUrl == null || imageUrl!.isEmpty
            ? Icon(
                Icons.person_outline,
                size: isReply ? 16 : 20,
                color: ColorsManager.primary,
              )
            : null,
      ),
    );
  }
}
