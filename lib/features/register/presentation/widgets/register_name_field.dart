import 'package:flutter/material.dart';
import 'package:ripple/core/utils/constants/constants.dart';
import 'package:ripple/core/utils/constants/primary/primary_text_field.dart';
import 'package:ripple/core/utils/cubit/auth/auth_cubit.dart';

class RegisterNameField extends StatelessWidget {
  const RegisterNameField({super.key});

  @override
  Widget build(BuildContext context) {
    return PrimaryTextField(
      controller: authCubit.registerNameController,
      hintText: appTranslation().get('name'),
      prefixIcon: Icons.person_outline,
      keyboardType: TextInputType.name,
      validator: (value) => value == null || value.trim().isEmpty
          ? appTranslation().get('please_enter_name')
          : null,
    );
  }
}
