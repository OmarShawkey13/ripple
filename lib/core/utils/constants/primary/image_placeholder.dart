import 'package:flutter/material.dart';
import 'package:ripple/core/utils/constants/primary/loading_indicator.dart';

class ImagePlaceholder extends StatelessWidget {
  const ImagePlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: LoadingIndicator(strokeWidth: 1.5),
    );
  }
}
