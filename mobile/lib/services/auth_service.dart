import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mobile/screens/models/user_model.dart';

class AuthService {
  // Flutter Web → localhost | Emulador Android Studio → 10.0.2.2
  static const String _baseUrl = 'http://localhost:3000';

  // ── Login ────────────────────────────────────────────────────────────────────

  /// Retorna [UserModel] si el login fue exitoso, o null si falló.
  Future<UserModel?> login({
    required String correo,
    required String password,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body:    jsonEncode({'correo': correo, 'password': password}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', data['token'] as String);

        final user = UserModel.fromJson(
          data['user'] as Map<String, dynamic>,
        );

        await prefs.setString('user_rol',    user.rol);
        await prefs.setString('user_nombre', user.nombre);
        if (user.pais != null) {
          await prefs.setString('user_pais', user.pais!);
        }

        return user;
      }

      return null;
    } catch (_) {
      return null;
    }
  }

  // ── Logout ───────────────────────────────────────────────────────────────────

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    await prefs.remove('user_rol');
    await prefs.remove('user_nombre');
    await prefs.remove('user_pais');
  }

  // ── Token ────────────────────────────────────────────────────────────────────

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }
}