import 'package:flutter/material.dart';
import 'package:mobile/constants/app_colors.dart';
 
/// Campo de texto reutilizable con estética rosada.
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
        const SizedBox(height: 5),
        _buildField(),
      ],
    );
  }
 
  Widget _buildLabel() {
    return Text(
      label.toUpperCase(),
      style: const TextStyle(
        color: AppColors.fieldLabel,
        fontSize: 10,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.8,
      ),
    );
  }
 
  Widget _buildField() {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      style: const TextStyle(
        color: AppColors.fieldText,
        fontSize: 14,
      ),
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: AppColors.fieldIcon, size: 20),
        suffixIcon: suffixIcon,
        hintText: label,
        hintStyle: TextStyle(
          color: AppColors.fieldText.withOpacity(0.35),
          fontSize: 14,
        ),
        filled: true,
        fillColor: AppColors.fieldBg,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 13,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(
            color: AppColors.fieldBorder,
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(
            color: AppColors.fieldFocused,
            width: 1.5,
          ),
        ),
      ),
    );
  }
}
 