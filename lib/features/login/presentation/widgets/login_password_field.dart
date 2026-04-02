import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ripple/core/utils/constants/constants.dart';
import 'package:ripple/core/utils/constants/primary/primary_text_field.dart';
import 'package:ripple/core/utils/cubit/auth/auth_cubit.dart';
import 'package:ripple/core/utils/cubit/auth/auth_state.dart';

class LoginPasswordField extends StatelessWidget {
  const LoginPasswordField({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthStates>(
      buildWhen: (_, state) => state is AuthShowPasswordUpdatedState,
      builder: (context, state) {
        return PrimaryTextField(
          controller: authCubit.loginPasswordController,
          hintText: appTranslation().get('password'),
          prefixIcon: Icons.lock_outline,
          isPassword: true,
          obscureText: !authCubit.passwordVisibility['login']!,
          onSuffixIconPressed: () =>
              authCubit.togglePasswordVisibility('login'),
          validator: (value) {
            const pattern = r'^(?=.*[A-Za-z])(?=.*\d).{8,}$';
            if (!RegExp(pattern).hasMatch(value ?? "")) {
              return appTranslation().get('please_enter_password');
            }
            return null;
          },
        );
      },
    );
  }
}
