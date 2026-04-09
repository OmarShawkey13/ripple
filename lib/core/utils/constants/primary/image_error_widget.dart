import 'package:flutter/material.dart';
import 'package:ripple/core/theme/colors.dart';

class ImageErrorWidget extends StatelessWidget {
  const ImageErrorWidget({super.key});

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
