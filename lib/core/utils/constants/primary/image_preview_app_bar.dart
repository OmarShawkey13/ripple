import 'package:flutter/material.dart';
import 'package:ripple/core/theme/text_styles.dart';

class ImagePreviewAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  final int currentIndex;
  final int totalCount;
  final VoidCallback onClose;

  const ImagePreviewAppBar({
    super.key,
    required this.currentIndex,
    required this.totalCount,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.black.withValues(alpha: 0.7),
            Colors.transparent,
          ],
        ),
      ),
      child: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.3),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.close, color: Colors.white, size: 20),
          ),
          onPressed: onClose,
        ),
        title: totalCount > 1
            ? Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  "${currentIndex + 1} / $totalCount",
                  style: TextStylesManager.medium14.copyWith(
                    color: Colors.white,
                  ),
                ),
              )
            : null,
        centerTitle: true,
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
