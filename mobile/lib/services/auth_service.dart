import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mobile/screens/models/user_model.dart';

class AuthService {
  // Flutter Web → localhost | Emulador Android Studio → 10.0.2.2
  static const String _baseUrl = 'http://localhost:3000';

  // ── Login ────────────────────────────────────────────────────────────────────

  /// Retorna UserModel si el login fue exitoso.
  Future<Map<String, dynamic>> login({
    required String correo,
    required String password,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/auth/login'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'correo': correo,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        final data =
            jsonDecode(response.body) as Map<String, dynamic>;

        final prefs = await SharedPreferences.getInstance();

        await prefs.setString(
          'token',
          data['token'] as String,
        );

        final user = UserModel.fromJson(
          data['user'] as Map<String, dynamic>,
        );

        await prefs.setString('user_rol', user.rol);
        await prefs.setString('user_nombre', user.nombre);

        if (user.pais != null) {
          await prefs.setString(
            'user_pais',
            user.pais!,
          );
        }

        return {
          'error': false,
          'user': user,
        };
      }

      // País inactivo
      if (response.statusCode == 403) {
        final body =
            jsonDecode(response.body) as Map<String, dynamic>;

        return {
          'error': true,
          'message':
              body['message'] ?? 'Acceso denegado',
          'codigo': body['codigo'] ?? '',
        };
      }

      // Credenciales incorrectas
      return {
        'error': true,
        'message': 'Credenciales incorrectas',
        'codigo': '',
      };

    } catch (_) {
      return {
        'error': true,
        'message': 'Error de conexión',
        'codigo': '',
      };
    }
  }

 // ── RECUPERAR CONTRASEÑA ───────────────────────────────────────────────────

Future<Map<String, dynamic>> forgotPassword({
  required String correo,
}) async {
  try {
    final response = await http.post(
      Uri.parse(
        '$_baseUrl/auth/forgot-password',
      ),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'correo': correo,
      }),
    );

    final data =
        jsonDecode(response.body) as Map<String, dynamic>;

    if (response.statusCode == 200) {
      return {
        'error': false,
        'message':
            data['message'] ??
            'Correo enviado correctamente',
      };
    }

    return {
      'error': true,
      'message':
          data['message'] ??
          'Error al enviar correo',
    };

  } catch (e) {
    return {
      'error': true,
      'message': 'Error de conexión',
    };
  }
}

// ── RESET PASSWORD ─────────────────────────────────────────────────────────

Future<Map<String, dynamic>> resetPassword({
  required String token,
  required String password,
}) async {
  try {
    final response = await http.post(
      Uri.parse(
        '$_baseUrl/auth/reset-password',
      ),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'token': token,
        'password': password,
      }),
    );

    final data =
        jsonDecode(response.body) as Map<String, dynamic>;

    if (response.statusCode == 200) {
      return {
        'error': false,
        'message':
            data['message'] ??
            'Contraseña actualizada',
      };
    }

    return {
      'error': true,
      'message':
          data['message'] ??
          'No se pudo actualizar la contraseña',
    };

  } catch (e) {
    return {
      'error': true,
      'message': 'Error de conexión',
    };
  }
}

  // ── Logout ─────────────────────────────────────────────────────────────────

  Future<void> logout() async {
    final prefs =
        await SharedPreferences.getInstance();

    await prefs.remove('token');
    await prefs.remove('user_rol');
    await prefs.remove('user_nombre');
    await prefs.remove('user_pais');
  }

  // ── Token ──────────────────────────────────────────────────────────────────

  Future<String?> getToken() async {
    final prefs =
        await SharedPreferences.getInstance();

    return prefs.getString('token');
  }
}