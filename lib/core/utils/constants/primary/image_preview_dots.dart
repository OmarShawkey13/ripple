import 'package:flutter/material.dart';
import 'package:ripple/core/theme/colors.dart';

class ImagePreviewDots extends StatelessWidget {
  final int currentIndex;
  final int totalCount;

  const ImagePreviewDots({
    super.key,
    required this.currentIndex,
    required this.totalCount,
  });

  @override
  Widget build(BuildContext context) {
    if (totalCount <= 1) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.only(bottom: 40),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(
          totalCount,
          (index) => AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            margin: const EdgeInsets.symmetric(horizontal: 4),
            height: 6,
            width: currentIndex == index ? 24 : 6,
            decoration: BoxDecoration(
              color: currentIndex == index
                  ? ColorsManager.primary
                  : Colors.white.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(10),
              boxShadow: currentIndex == index
                  ? [
                      BoxShadow(
                        color: ColorsManager.primary.withValues(alpha: 0.4),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ]
                  : null,
            ),
          ),
        ),
      ),
    );
  }
}
