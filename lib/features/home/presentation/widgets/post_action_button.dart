import 'package:flutter/material.dart';
import 'package:ripple/core/theme/text_styles.dart';
import 'package:ripple/core/utils/constants/spacing.dart';

class PostActionButton extends StatelessWidget {
  final IconData icon;
  final Color? color;
  final int count;
  final VoidCallback onTap;

  const PostActionButton({
    super.key,
    required this.icon,
    required this.count,
    required this.onTap,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(24),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
        child: Row(
          children: [
            Icon(icon, size: 20, color: color),
            horizontalSpace4,
            Text(
              count.toString(),
              style: TextStylesManager.regular12,
            ),
          ],
        ),
      ),
    );
  }
}
