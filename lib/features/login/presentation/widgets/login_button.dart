import 'package:flutter/material.dart';
import 'package:ripple/core/utils/constants/constants.dart';
import 'package:ripple/core/utils/constants/primary/primary_button.dart';
import 'package:ripple/core/utils/cubit/auth/auth_cubit.dart';

class LoginButton extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final bool isLoading;

  const LoginButton({
    super.key,
    required this.formKey,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    return PrimaryButton(
      text: appTranslation().get('login'),
      isLoading: isLoading,
      onPressed: () {
        if (formKey.currentState!.validate()) {
          authCubit.login();
        }
      },
    );
  }
}
