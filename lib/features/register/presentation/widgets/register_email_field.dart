import 'package:flutter/material.dart';
import 'package:ripple/core/theme/colors.dart';
import 'package:ripple/core/utils/constants/constants.dart';
import 'package:ripple/core/utils/cubit/home_cubit.dart';

class RegisterEmailField extends StatelessWidget {
  const RegisterEmailField({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = homeCubit.isDarkMode;
    return Container(
      decoration: BoxDecoration(
        color: ColorsManager.cardColor,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          if (!isDark)
            BoxShadow(
              color: Colors.black.withValues(alpha: .05),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
        ],
      ),
      child: TextFormField(
        controller: homeCubit.registerEmailController,
        keyboardType: TextInputType.emailAddress,
        validator: (value) =>
            value!.isEmpty ? appTranslation().get('please_enter_email') : null,
        decoration: InputDecoration(
          hintText: appTranslation().get('email_address'),
          prefixIcon: const Icon(
            Icons.email_rounded,
            color: ColorsManager.primary,
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 18,
          ),
        ),
      ),
    );
  }
}
