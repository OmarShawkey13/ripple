import 'package:flutter/material.dart';
import 'package:ripple/core/theme/colors.dart';

class CommentTreeLines extends StatelessWidget {
  final bool isLast;

  const CommentTreeLines({super.key, required this.isLast});

  @override
  Widget build(BuildContext context) {
    final lineColor = ColorsManager.dividerColor.withValues(alpha: 0.2);

    return SizedBox(
      width: 32,
      child: Stack(
        children: [
          Positioned(
            left: 0,
            top: 0,
            bottom: isLast ? 24 : 0,
            child: Container(
              width: 1.5,
              decoration: BoxDecoration(
                color: lineColor,
                borderRadius: BorderRadius.circular(1),
              ),
            ),
          ),
          Positioned(
            left: 0,
            top: 24,
            child: Container(
              width: 18,
              height: 1.5,
              decoration: BoxDecoration(
                color: lineColor,
                borderRadius: BorderRadius.circular(1),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
