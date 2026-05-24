import 'package:flutter/material.dart';

import 'home_screen.dart';
import 'login_screen.dart';
import 'reset_password_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Latinoamérica Comparte',

      // Ruta inicial
      initialRoute: '/',

      onGenerateRoute: (settings) {

        // HOME
        if (settings.name == '/') {
          return MaterialPageRoute(
            builder: (_) => const HomeScreen(),
          );
        }

        // LOGIN
        if (settings.name == '/login') {
          return MaterialPageRoute(
            builder: (_) => const LoginScreen(),
          );
        }

        // RESET PASSWORD
        if (settings.name != null &&
            settings.name!.startsWith('/reset-password/')) {

          final token =
              settings.name!
                  .split('/reset-password/')[1];

          return MaterialPageRoute(
            builder: (_) => ResetPasswordScreen(
              token: token,
            ),
          );
        }

        return null;
      },
    );
  }
}