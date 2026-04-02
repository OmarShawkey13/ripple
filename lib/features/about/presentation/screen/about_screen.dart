import 'package:flutter/material.dart';
import 'package:ripple/core/theme/colors.dart';
import 'package:ripple/core/theme/text_styles.dart';
import 'package:ripple/core/utils/constants/constants.dart';
import 'package:ripple/core/utils/constants/spacing.dart';
import 'package:ripple/core/utils/extensions/context_extension.dart';
import 'package:ripple/features/about/presentation/widgets/about_app_info.dart';
import 'package:ripple/features/about/presentation/widgets/about_footer.dart';
import 'package:ripple/features/about/presentation/widgets/about_section.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsManager.backgroundColor,
      appBar: AppBar(
        backgroundColor: ColorsManager.backgroundColor,
        elevation: 0,
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
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            children: [
              verticalSpace32,
              const AboutAppInfo(),
              verticalSpace40,
              AboutSection(
                title: appTranslation().get('our_mission'),
                content: appTranslation().get('mission_content'),
              ),
              verticalSpace24,
              AboutSection(
                title: appTranslation().get('developer'),
                content: "Omar Shawkey",
                isCenter: true,
              ),
              verticalSpace48,
              const AboutFooter(),
              verticalSpace32,
            ],
          ),
        ),
      ),
    );
  }
}
