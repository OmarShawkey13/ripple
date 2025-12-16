import 'package:flutter/material.dart';
import 'package:ripple/core/theme/colors.dart';
import 'package:ripple/core/utils/constants/constants.dart';
import 'package:ripple/core/utils/cubit/home_cubit.dart';

class RegisterPasswordField extends StatelessWidget {
  const RegisterPasswordField({super.key});

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
        controller: homeCubit.registerPasswordController,
        obscureText: !homeCubit.passwordVisibility['register']!,
        obscuringCharacter: "*",
        keyboardType: TextInputType.visiblePassword,
        validator: (value) {
          const pattern = r'^(?=.*[A-Za-z])(?=.*\d).{8,}$';
          if (!RegExp(pattern).hasMatch(value ?? "")) {
            return appTranslation().get('please_enter_password');
          }
          return null;
        },
        decoration: InputDecoration(
          hintText: appTranslation().get('password'),
          prefixIcon: const Icon(
            Icons.lock_outline,
            color: ColorsManager.primary,
          ),
          suffixIcon: IconButton(
            icon: Icon(
              homeCubit.passwordVisibility['register']!
                  ? Icons.visibility_off_outlined
                  : Icons.visibility_outlined,
              color: ColorsManager.primary,
            ),
            onPressed: () => homeCubit.togglePasswordVisibility('register'),
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
