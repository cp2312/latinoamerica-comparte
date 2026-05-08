import 'package:flutter/material.dart';
import 'package:mobile/constants/app_colors.dart';
import 'login_text_field.dart';
import 'login_button.dart';

/// Card glassmorphism que contiene el formulario de login.
class FormCard extends StatelessWidget {
  const FormCard({
    super.key,
    required this.emailController,
    required this.passwordController,
    required this.obscurePassword,
    required this.isLoading,
    required this.onTogglePassword,
    required this.onLogin,
    required this.onForgotPassword,
  });

  final TextEditingController emailController;
  final TextEditingController passwordController;
  final bool obscurePassword;
  final bool isLoading;
  final VoidCallback onTogglePassword;
  final VoidCallback onLogin;
  final VoidCallback onForgotPassword;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(14, 0, 14, 14),
      padding: const EdgeInsets.fromLTRB(18, 24, 18, 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        color: AppColors.white.withOpacity(0.05),
        border: Border.all(
          color: AppColors.white.withOpacity(0.1),
          width: 1,
        ),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.white.withOpacity(0.06),
            Colors.transparent,
          ],
          stops: const [0.0, 0.6],
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          LoginTextField(
            controller: emailController,
            label: 'Correo electrónico',
            icon: Icons.mail_outline_rounded,
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 16),
          LoginTextField(
            controller: passwordController,
            label: 'Contraseña',
            icon: Icons.lock_outline_rounded,
            obscureText: obscurePassword,
            suffixIcon: GestureDetector(
              onTap: onTogglePassword,
              child: Icon(
                obscurePassword
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined,
                color: AppColors.white.withOpacity(0.3),
                size: 18,
              ),
            ),
          ),
          const SizedBox(height: 20),
          LoginButton(
            isLoading: isLoading,
            onPressed: onLogin,
          ),
          const SizedBox(height: 14),
          GestureDetector(
            onTap: onForgotPassword,
            child: Text(
              '¿Olvidaste tu contraseña?',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.white.withOpacity(0.3),
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }
}