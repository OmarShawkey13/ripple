import 'package:flutter/material.dart';
import 'package:ripple/core/theme/colors.dart';
import 'package:ripple/core/theme/text_styles.dart';
import 'package:ripple/core/utils/constants/spacing.dart';

class PostActionButton extends StatelessWidget {
  final IconData icon;
  final int count;
  final Color activeColor;
  final bool isActive;
  final VoidCallback onTap;

  const PostActionButton({
    super.key,
    required this.icon,
    required this.count,
    required this.activeColor,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = isActive ? activeColor : ColorsManager.textSecondaryColor;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isActive
              ? activeColor.withValues(alpha: 0.08)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 20,
              color: color.withValues(alpha: 0.8),
            ),
            if (count > 0) ...[
              horizontalSpace6,
              Text(
                count.toString(),
                style: TextStylesManager.medium14.copyWith(
                  color: color.withValues(alpha: 0.9),
                  fontSize: 13,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
