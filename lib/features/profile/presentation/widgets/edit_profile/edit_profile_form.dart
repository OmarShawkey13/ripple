import 'package:flutter/material.dart';
import 'package:ripple/core/theme/colors.dart';
import 'package:ripple/core/theme/text_styles.dart';
import 'package:ripple/core/utils/constants/constants.dart';
import 'package:ripple/core/utils/constants/primary/primary_text_field.dart';
import 'package:ripple/core/utils/constants/spacing.dart';
import 'package:ripple/core/utils/cubit/home/home_cubit.dart';

class EditProfileForm extends StatelessWidget {
  const EditProfileForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _EditFieldLabel(label: appTranslation().get('username')),
          verticalSpace8,
          PrimaryTextField(
            controller: homeCubit.usernameController,
            hintText: appTranslation().get('username'),
            prefixIcon: Icons.person_outline_rounded,
          ),
          verticalSpace24,
          _EditFieldLabel(label: appTranslation().get('bio')),
          verticalSpace8,
          PrimaryTextField(
            controller: homeCubit.bioController,
            hintText: appTranslation().get('bio'),
            prefixIcon: Icons.info_outline_rounded,
            maxLines: 4,
            keyboardType: TextInputType.multiline,
          ),
          verticalSpace32,
        ],
      ),
    );
  }
}

class _EditFieldLabel extends StatelessWidget {
  final String label;

  const _EditFieldLabel({required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.only(start: 4),
      child: Text(
        label,
        style: TextStylesManager.bold14.copyWith(
          color: ColorsManager.primary,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}
