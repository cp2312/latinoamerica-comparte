import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class ResetPasswordScreen extends StatefulWidget {
  final String token;

  const ResetPasswordScreen({
    super.key,
    required this.token,
  });

  @override
  State<ResetPasswordScreen> createState() =>
      _ResetPasswordScreenState();
}

class _ResetPasswordScreenState
    extends State<ResetPasswordScreen> {
  final passwordController =
      TextEditingController();

  bool isLoading = false;

  Future<void> _resetPassword() async {
    final password =
        passwordController.text.trim();

    if (password.isEmpty) return;

    setState(() {
      isLoading = true;
    });

    final result =
        await AuthService().resetPassword(
      token: widget.token,
      password: password,
    );

    if (!mounted) return;

    setState(() {
      isLoading = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(result['message']),
      ),
    );

    if (result['error'] == false) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            const Text('Nueva contraseña'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller:
                  passwordController,
              obscureText: true,
              decoration:
                  const InputDecoration(
                labelText:
                    'Nueva contraseña',
              ),
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: isLoading
                  ? null
                  : _resetPassword,
              child: isLoading
                  ? const CircularProgressIndicator()
                  : const Text(
                      'Cambiar contraseña',
                    ),
            ),
          ],
        ),
      ),
    );
  }
}