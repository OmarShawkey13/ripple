import 'package:flutter/material.dart';
import 'package:ripple/core/utils/constants/constants.dart';
import 'package:ripple/core/utils/constants/primary/primary_text_field.dart';
import 'package:ripple/core/utils/cubit/auth/auth_cubit.dart';

class LoginEmailField extends StatelessWidget {
  const LoginEmailField({super.key});

  @override
  Widget build(BuildContext context) {
    return PrimaryTextField(
      controller: authCubit.loginEmailController,
      hintText: appTranslation().get('email_address'),
      prefixIcon: Icons.email_rounded,
      keyboardType: TextInputType.emailAddress,
      validator: (value) =>
          value!.isEmpty ? appTranslation().get('please_enter_email') : null,
    );
  }
}
