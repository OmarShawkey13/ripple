import 'package:flutter/material.dart';
import 'package:ripple/core/theme/colors.dart';
import 'package:ripple/core/theme/text_styles.dart';
import 'package:ripple/core/utils/constants/spacing.dart';
import 'package:ripple/features/on_boarding/data/models/onboarding_item.dart';

class OnBoardingPageItem extends StatelessWidget {
  final OnBoardingItem item;

  const OnBoardingPageItem({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(
                item.image,
              ),
              fit: BoxFit.cover,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          width: 260,
          height: 260,
        ),
        verticalSpace30,
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            item.title,
            textAlign: TextAlign.center,
            style: TextStylesManager.bold22.copyWith(
              color: ColorsManager.primary,
            ),
          ),
        ),
        verticalSpace16,
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Text(
            item.subtitle,
            textAlign: TextAlign.center,
            style: TextStylesManager.regular14.copyWith(
              color: ColorsManager.textSecondaryColor,
            ),
          ),
        ),
      ],
    );
  }
}
