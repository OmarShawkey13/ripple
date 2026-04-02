import 'package:flutter/material.dart';
import 'package:ripple/core/theme/colors.dart';

class UserListTileLoading extends StatelessWidget {
  const UserListTileLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 64,
      decoration: BoxDecoration(
        color: ColorsManager.surfaceContainer.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }
}
