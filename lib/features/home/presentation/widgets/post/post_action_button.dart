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

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Row(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: isActive
                  ? activeColor.withValues(alpha: 0.1)
                  : Colors.transparent,
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              size: 20,
              color: color.withValues(alpha: 0.8),
            ),
          ),
          if (count > 0) ...[
            horizontalSpace4,
            Text(
              count.toString(),
              style: TextStylesManager.medium12.copyWith(
                color: color.withValues(alpha: 0.9),
                fontSize: 12,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
