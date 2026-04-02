import 'package:flutter/material.dart';
import 'package:ripple/core/theme/colors.dart';
import 'package:ripple/core/utils/cubit/theme/theme_cubit.dart';

class PrimaryTextField extends StatelessWidget {
  final TextEditingController controller;
  final String? hintText;
  final String? labelText;
  final IconData? prefixIcon;
  final String? Function(String?)? validator;
  final bool isPassword;
  final bool obscureText;
  final VoidCallback? onSuffixIconPressed;
  final TextInputType keyboardType;
  final IconData? suffixIcon;
  final int? maxLines;
  final InputBorder? border;
  final FocusNode? focusNode;
  final bool useCardDecoration;

  const PrimaryTextField({
    super.key,
    required this.controller,
    this.hintText,
    this.labelText,
    this.prefixIcon,
    this.validator,
    this.isPassword = false,
    this.obscureText = false,
    this.onSuffixIconPressed,
    this.keyboardType = TextInputType.text,
    this.suffixIcon,
    this.maxLines = 1,
    this.border,
    this.focusNode,
    this.useCardDecoration = true,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = themeCubit.isDarkMode;
    return Container(
      decoration: useCardDecoration
          ? BoxDecoration(
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
            )
          : null,
      child: TextFormField(
        controller: controller,
        focusNode: focusNode,
        obscureText: obscureText,
        keyboardType: keyboardType,
        validator: validator,
        maxLines: maxLines,
        decoration: InputDecoration(
          hintText: hintText,
          labelText: labelText,
          prefixIcon: prefixIcon != null
              ? Icon(
                  prefixIcon,
                  color: ColorsManager.primary,
                )
              : null,
          suffixIcon: isPassword
              ? IconButton(
                  icon: Icon(
                    suffixIcon ??
                        (obscureText
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined),
                    color: ColorsManager.primary,
                  ),
                  onPressed: onSuffixIconPressed,
                )
              : null,
          border: border ?? InputBorder.none,
          contentPadding: EdgeInsets.symmetric(
            horizontal: useCardDecoration ? 16 : 0,
            vertical: useCardDecoration ? 18 : 12,
          ),
        ),
      ),
    );
  }
}
