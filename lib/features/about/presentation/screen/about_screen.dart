import 'package:flutter/material.dart';
import 'package:ripple/core/theme/colors.dart';
import 'package:ripple/core/theme/text_styles.dart';
import 'package:ripple/core/utils/constants/assets_helper.dart';
import 'package:ripple/core/utils/constants/constants.dart';
import 'package:ripple/core/utils/constants/spacing.dart';
import 'package:ripple/core/utils/cubit/theme/theme_cubit.dart';
import 'package:ripple/core/utils/extensions/context_extension.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: ColorsManager.textColor),
          onPressed: () => context.pop,
        ),
        title: Text(
          appTranslation().get('about_ripple'),
          style: TextStylesManager.bold18.copyWith(
            color: ColorsManager.textColor,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              verticalSpace24,
              // App Logo & Name
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: ColorsManager.primary.withValues(alpha: 0.1),
                ),
                child: Image.asset(
                  AssetsHelper.logo,
                  height: 80,
                  width: 80,
                ),
              ),
              verticalSpace16,
              Text(
                "Ripple",
                style: TextStylesManager.bold24.copyWith(
                  color: ColorsManager.primary,
                  letterSpacing: 1.2,
                ),
              ),
              Text(
                "${appTranslation().get('version')} 1.0.0",
                style: TextStylesManager.regular14.copyWith(color: Colors.grey),
              ),
              verticalSpace32,

              // Mission Section
              _buildSection(
                context,
                title: appTranslation().get('our_mission'),
                content: appTranslation().get('mission_content'),
              ),
              verticalSpace24,

              // Developer Section
              _buildSection(
                context,
                title: appTranslation().get('developer'),
                content: "Omar Shawkey",
                isCenter: true,
              ),
              verticalSpace40,

              // Footer
              Text(
                appTranslation().get('made_with_love'),
                style: TextStylesManager.regular14.copyWith(
                  color: ColorsManager.textColor.withValues(alpha: 0.6),
                ),
              ),
              verticalSpace24,
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSection(
    BuildContext context, {
    required String title,
    required String content,
    bool isCenter = false,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: themeCubit.isDarkMode
            ? Colors.white.withValues(alpha: 0.05)
            : Colors.grey.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: ColorsManager.primary.withValues(alpha: 0.1),
        ),
      ),
      child: Column(
        crossAxisAlignment: isCenter
            ? CrossAxisAlignment.center
            : CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStylesManager.bold16.copyWith(
              color: ColorsManager.primary,
            ),
          ),
          verticalSpace8,
          Text(
            content,
            textAlign: isCenter ? TextAlign.center : TextAlign.start,
            style: TextStylesManager.regular14.copyWith(
              color: ColorsManager.textColor.withValues(alpha: 0.8),
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
