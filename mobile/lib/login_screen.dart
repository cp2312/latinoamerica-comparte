import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../constants/app_colors.dart';
import '../screens/widgets/login/background_layer.dart';
import '../screens/widgets/login/hero_section.dart';
import '../screens/widgets/login/form_card.dart';

/// Pantalla de login — conectada a [AuthService].
/// Mantiene únicamente el estado de UI:
/// loading, visibilidad de contraseña y controllers.
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController    = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isLoading       = false;
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // ── Acciones ────────────────────────────────

  Future<void> _onLogin() async {
    final email    = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      _showSnack('Todos los campos son obligatorios');
      return;
    }

    setState(() => _isLoading = true);

    final success = await AuthService().login(
      correo: email,
      password: password,
    );

    if (!mounted) return;
    setState(() => _isLoading = false);

    if (success) {
      _showSnack('Login exitoso');
      // TODO: Navigator.pushReplacementNamed(context, '/dashboard');
    } else {
      _showSnack('Credenciales incorrectas');
    }
  }

  void _onTogglePassword() =>
      setState(() => _obscurePassword = !_obscurePassword);

  void _onForgotPassword() {
    // TODO: Navigator.pushNamed(context, '/forgot-password');
  }

  void _showSnack(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.purpleAccent,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  // ── Build ────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          const BackgroundLayer(),
          SafeArea(child: _buildScrollContent(context)),
        ],
      ),
    );
  }

  Widget _buildScrollContent(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.zero,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minHeight: MediaQuery.of(context).size.height -
              MediaQuery.of(context).padding.top -
              MediaQuery.of(context).padding.bottom,
        ),
        child: IntrinsicHeight(
          child: Column(
            children: [
              const HeroSection(),
              const SizedBox(height: 26),
              Expanded(
                child: FormCard(
                  emailController:    _emailController,
                  passwordController: _passwordController,
                  obscurePassword:    _obscurePassword,
                  isLoading:          _isLoading,
                  onTogglePassword:   _onTogglePassword,
                  onLogin:            _onLogin,
                  onForgotPassword:   _onForgotPassword,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}