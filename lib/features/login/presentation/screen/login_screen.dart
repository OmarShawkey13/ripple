import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ripple/core/theme/colors.dart';
import 'package:ripple/core/theme/text_styles.dart';
import 'package:ripple/core/utils/constants/constants.dart';
import 'package:ripple/core/utils/constants/routes.dart';
import 'package:ripple/core/utils/constants/spacing.dart';
import 'package:ripple/core/utils/cubit/home_cubit.dart';
import 'package:ripple/core/utils/cubit/home_state.dart';
import 'package:ripple/core/utils/extensions/context_extension.dart';
import 'package:ripple/features/login/presentation/widgets/login_email_field.dart';
import 'package:ripple/features/login/presentation/widgets/login_button.dart';
import 'package:ripple/features/login/presentation/widgets/login_header.dart';
import 'package:ripple/features/login/presentation/widgets/login_password_field.dart';

class LoginScreen extends StatelessWidget {
  final formKey = GlobalKey<FormState>();

  LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeCubit, HomeStates>(
      buildWhen: (_, state) =>
          state is HomeShowPasswordUpdatedState ||
          state is HomeLoginLoadingState ||
          state is HomeLoginSuccessState ||
          state is HomeLoginErrorState,
      listener: (context, state) {
        if (state is HomeLoginSuccessState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                appTranslation().get('login_success'),
              ),
              backgroundColor: ColorsManager.success,
              duration: const Duration(seconds: 2),
              behavior: SnackBarBehavior.floating,
            ),
          );
          context.pushReplacement<Object>(Routes.home);
          homeCubit.loginEmailController.clear();
          homeCubit.loginPasswordController.clear();
        } else if (state is HomeLoginErrorState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.error),
              backgroundColor: ColorsManager.error,
              duration: const Duration(seconds: 2),
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      },
      builder: (context, state) {
        final isDark = homeCubit.isDarkMode;
        return AnnotatedRegion<SystemUiOverlayStyle>(
          value: isDark
              ? SystemUiOverlayStyle.light
              : SystemUiOverlayStyle.dark,
          child: Scaffold(
            body: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 28),
                child: Form(
                  key: formKey,
                  child: Column(
                    children: [
                      const LoginHeader(),
                      verticalSpace40,
                      const LoginEmailField(),
                      verticalSpace20,
                      const LoginPasswordField(),
                      verticalSpace30,
                      LoginButton(
                        formKey: formKey,
                        isLoading: state is HomeLoginLoadingState,
                      ),
                      verticalSpace20,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            appTranslation().get('dont_have_account'),
                            style: TextStylesManager.regular14.copyWith(
                              color: ColorsManager.textSecondaryColor,
                            ),
                          ),
                          horizontalSpace6,
                          GestureDetector(
                            onTap: () {
                              context.push<Object>(Routes.register);
                            },
                            child: Text(
                              appTranslation().get('create_account'),
                              style: TextStylesManager.medium14.copyWith(
                                color: ColorsManager.primary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
