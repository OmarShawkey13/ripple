import 'package:flutter/material.dart';
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
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildFieldLabel(appTranslation().get('username')),
          verticalSpace8,
          PrimaryTextField(
            controller: homeCubit.usernameController,
            hintText: appTranslation().get('enter_username'),
            prefixIcon: Icons.person_outline_rounded,
          ),
          verticalSpace20,
          _buildFieldLabel(appTranslation().get('bio')),
          verticalSpace8,
          PrimaryTextField(
            controller: homeCubit.bioController,
            hintText: appTranslation().get('write_something_about_yourself'),
            prefixIcon: Icons.info_outline_rounded,
            maxLines: 4,
            keyboardType: TextInputType.multiline,
          ),
          verticalSpace24,
        ],
      ),
    );
  }

  Widget _buildFieldLabel(String label) {
    return Padding(
      padding: const EdgeInsetsDirectional.only(start: 4),
      child: Text(
        label,
        style: TextStylesManager.bold14.copyWith(
          color: Colors.grey[600],
        ),
      ),
    );
  }
}
