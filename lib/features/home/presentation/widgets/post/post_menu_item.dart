import 'package:flutter/material.dart';
import 'package:ripple/core/theme/colors.dart';
import 'package:ripple/core/theme/text_styles.dart';
import 'package:ripple/core/utils/constants/spacing.dart';

class PostMenuItem extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color? color;

  const PostMenuItem({
    super.key,
    required this.icon,
    required this.text,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 20, color: color ?? ColorsManager.textColor),
        horizontalSpace12,
        Text(
          text,
          style: TextStylesManager.medium14.copyWith(
            color: color ?? ColorsManager.textColor,
            fontSize: 13,
          ),
        ),
      ],
    );
  }
}
