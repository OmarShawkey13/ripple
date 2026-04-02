import 'package:flutter/material.dart';
import 'package:ripple/core/theme/colors.dart';
import 'package:ripple/core/theme/text_styles.dart';
import 'package:ripple/core/utils/constants/constants.dart';

class EmptyUsersState extends StatelessWidget {
  const EmptyUsersState({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        appTranslation().get('no_users_found'),
        style: TextStylesManager.medium14.copyWith(
          color: ColorsManager.textSecondaryColor,
        ),
      ),
    );
  }
}
