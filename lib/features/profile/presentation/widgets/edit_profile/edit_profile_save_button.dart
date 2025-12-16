import 'package:flutter/material.dart';
import 'package:ripple/core/utils/cubit/home_cubit.dart';
import 'package:ripple/features/profile/presentation/widgets/edit_profile/edit_profile_circle_icon_button.dart';

class EditProfileSaveButton extends StatelessWidget {
  const EditProfileSaveButton({super.key});

  @override
  Widget build(BuildContext context) {
    return PositionedDirectional(
      top: MediaQuery.of(context).padding.top + 8,
      end: 12,
      child: EditProfileCircleIconButton(
        icon: Icons.check,
        onTap: () {
          homeCubit.updateProfile();
        },
      ),
    );
  }
}
