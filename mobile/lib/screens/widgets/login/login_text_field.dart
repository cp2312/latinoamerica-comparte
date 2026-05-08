import 'package:flutter/material.dart';
import 'package:mobile/constants/app_colors.dart';

/// Campo de texto reutilizable con estética dark mode.
class LoginTextField extends StatelessWidget {
  const LoginTextField({
    super.key,
    required this.controller,
    required this.label,
    required this.icon,
    this.obscureText = false,
    this.keyboardType,
    this.suffixIcon,
  });

  final TextEditingController controller;
  final String label;
  final IconData icon;
  final bool obscureText;
  final TextInputType? keyboardType;
  final Widget? suffixIcon;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel(),
        const SizedBox(height: 6),
        _buildField(),
      ],
    );
  }

  Widget _buildLabel() {
    return Text(
      label.toUpperCase(),
      style: TextStyle(
        color: AppColors.white.withOpacity(0.4),
        fontSize: 10,
        fontWeight: FontWeight.w500,
        letterSpacing: 1.0,
      ),
    );
  }

  Widget _buildField() {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      style: const TextStyle(color: AppColors.white, fontSize: 14),
      decoration: InputDecoration(
        prefixIcon: Icon(icon,
            color: AppColors.white.withOpacity(0.35), size: 20),
        suffixIcon: suffixIcon,
        hintText: label,
        hintStyle: TextStyle(
          color: AppColors.white.withOpacity(0.25),
          fontSize: 14,
        ),
        filled: true,
        fillColor: AppColors.white.withOpacity(0.06),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 14,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(
            color: AppColors.white.withOpacity(0.09),
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(
            color: AppColors.purpleGlow.withOpacity(0.5),
            width: 1,
          ),
        ),
      ),
    );
  }
}