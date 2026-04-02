import 'package:flutter/material.dart';
import 'package:ripple/core/theme/colors.dart';
import 'package:ripple/core/theme/text_styles.dart';

class HomeDrawerTile extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback? onTap;
  final Widget? trailing;

  const HomeDrawerTile({
    super.key,
    required this.title,
    required this.icon,
    this.onTap,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: ColorsManager.primary.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(
          icon,
          size: 22,
          color: ColorsManager.primary,
        ),
      ),
      title: Text(
        title,
        style: TextStylesManager.medium16.copyWith(
          color: ColorsManager.textColor,
        ),
      ),
      trailing:
          trailing ??
          Icon(
            Icons.arrow_forward_ios_rounded,
            size: 14,
            color: ColorsManager.textSecondaryColor.withValues(alpha: 0.5),
          ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }
}
