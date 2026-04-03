import 'package:flutter/material.dart';
import 'package:ripple/core/theme/colors.dart';

class CommentTreeLines extends StatelessWidget {
  final bool isLast;

  const CommentTreeLines({super.key, required this.isLast});

  @override
  Widget build(BuildContext context) {
    final lineColor = ColorsManager.dividerColor.withValues(alpha: 0.2);

    return SizedBox(
      width: 24, // Reduced width
      child: Stack(
        children: [
          Positioned(
            left: 8,
            top: 0,
            bottom: isLast
                ? 16
                : 0, // Adjust bottom to stop line for last reply
            child: Container(
              width: 1.5,
              color: lineColor,
            ),
          ),
          Positioned(
            left: 8,
            top: 16, // Align with avatar center
            child: Container(
              width: 12,
              height: 1.5,
              color: lineColor,
            ),
          ),
        ],
      ),
    );
  }
}
