import 'package:flutter/material.dart';
import 'package:ripple/core/theme/colors.dart';

class CommentTreeLines extends StatelessWidget {
  final bool isLast;

  const CommentTreeLines({super.key, required this.isLast});

  @override
  Widget build(BuildContext context) {
    final lineColor = ColorsManager.outline.withValues(alpha: 0.2);

    return SizedBox(
      width: 24,
      height:
          double.infinity, // سيتم تقييده بواسطة IntrinsicHeight في المكون الأب
      child: Stack(
        children: [
          Positioned(
            left: 12,
            top: 0,
            bottom: isLast ? 22 : 0, // يتوقف الخط عند مستوى الرد الأخير
            child: Container(
              width: 1,
              color: lineColor,
            ),
          ),
          Positioned(
            left: 12,
            top: 22, // محاذاة مع منتصف الصورة الرمزية تقريباً
            child: Container(
              width: 12,
              height: 1,
              color: lineColor,
            ),
          ),
        ],
      ),
    );
  }
}
