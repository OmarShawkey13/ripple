import 'package:flutter/material.dart';
import 'package:ripple/core/theme/colors.dart';

class EditProfileCircleIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const EditProfileCircleIconButton({
    super.key,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: ColorsManager.primary,
          shape: BoxShape.circle,
          border: Border.all(
            color: ColorsManager.backgroundColor,
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.2),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Icon(
          icon,
          size: 20,
          color: Colors.white,
        ),
      ),
    );
  }
}
