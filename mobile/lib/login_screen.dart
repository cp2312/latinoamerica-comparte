import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../constants/app_colors.dart';
import '../screens/widgets/login/background_layer.dart';
import '../screens/widgets/login/hero_section.dart';
import '../screens/widgets/login/form_card.dart';
import 'package:mobile/dashboard_screen.dart';
import 'package:mobile/dashboard_admin_pais_screen.dart';

/// Pantalla de login conectada a [AuthService].
/// Redirige según el rol del usuario autenticado:
///   superadmin  → DashboardScreen
///   admin_pais  → DashboardAdminPaisScreen
///   editor      → DashboardAdminPaisScreen (con opciones limitadas)
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

  // ── Acciones ─────────────────────────────────────────────────────────────────

  Future<void> _onLogin() async {
    final email    = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      _showSnack('Todos los campos son obligatorios');
      return;
    }

    setState(() => _isLoading = true);

    final user = await AuthService().login(
      correo:   email,
      password: password,
    );

    if (!mounted) return;
    setState(() => _isLoading = false);

    if (user == null) {
      _showSnack('Credenciales incorrectas');
      return;
    }

    // ── Redirige según rol ───────────────────────────────────────────────────
    switch (user.rol) {
      case 'superadmin':
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const DashboardScreen()),
        );
        break;

      case 'admin_pais':
      case 'editor':
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => DashboardAdminPaisScreen(usuario: user),
          ),
        );
        break;

      default:
        _showSnack('Rol no reconocido: ${user.rol}');
    }
  }

  void _onTogglePassword() =>
      setState(() => _obscurePassword = !_obscurePassword);

  void _onForgotPassword() {
    // TODO: implementar recuperación de contraseña
  }

  void _showSnack(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content:         Text(message),
        backgroundColor: AppColors.primary,
        behavior:        SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  // ── Build ─────────────────────────────────────────────────────────────────────

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
              const SizedBox(height: 22),
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