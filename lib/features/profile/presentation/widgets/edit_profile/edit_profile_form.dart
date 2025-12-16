import 'package:flutter/material.dart';
import 'package:ripple/core/theme/colors.dart';
import 'package:ripple/core/utils/constants/constants.dart';
import 'package:ripple/core/utils/constants/spacing.dart';
import 'package:ripple/core/utils/cubit/home_cubit.dart';

class EditProfileForm extends StatelessWidget {
  const EditProfileForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: ColorsManager.cardColor,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            TextFormField(
              controller: homeCubit.usernameController,
              decoration: InputDecoration(
                labelText: appTranslation().get('username'),
                border: const OutlineInputBorder(),
              ),
            ),
            verticalSpace16,
            TextFormField(
              controller: homeCubit.bioController,
              decoration: InputDecoration(
                labelText: appTranslation().get('bio'),
                border: const OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
          ],
        ),
      ),
    );
  }
}
