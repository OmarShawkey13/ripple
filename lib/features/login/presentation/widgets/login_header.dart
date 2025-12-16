import 'package:flutter/material.dart';
import 'package:ripple/core/theme/colors.dart';
import 'package:ripple/core/theme/text_styles.dart';
import 'package:ripple/core/utils/constants/assets_helper.dart';
import 'package:ripple/core/utils/constants/constants.dart';

class LoginHeader extends StatelessWidget {
  const LoginHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Image.asset(
          AssetsHelper.logo,
          height: 200,
          width: 200,
        ),
        Text(
          appTranslation().get('welcome_to_ripple'),
          style: TextStylesManager.bold26.copyWith(
            color: ColorsManager.textColor,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
