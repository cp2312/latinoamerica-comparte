import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mobile/screens/models/pais_model.dart';
 
class PaisesService {
  // Flutter Web → localhost | Emulador Android → 10.0.2.2
  static const String _baseUrl = 'http://localhost:3000';
 
  // ── Headers con JWT ────────────────────────────────────────────────────────
  Future<Map<String, String>> _authHeaders() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';
    return {
      'Content-Type':  'application/json',
      'Authorization': 'Bearer $token',
    };
  }
 
  // ── GET /paises — público, lista todos ────────────────────────────────────
  /// [soloActivos] = true → GET /paises?estado=activo
  /// Usar en portales públicos para saber qué países están disponibles.
  Future<List<PaisModel>> getPaises({bool soloActivos = false}) async {
    try {
      final qs  = soloActivos ? '?estado=activo' : '';
      final res = await http.get(
        Uri.parse('$_baseUrl/paises$qs'),
        headers: {'Content-Type': 'application/json'},
      );
      if (res.statusCode == 200) {
        final List data = jsonDecode(res.body);
        return data.map((e) => PaisModel.fromJson(e)).toList();
      }
      return [];
    } catch (_) {
      return [];
    }
  }
 
  // ── POST /paises — crear país (superadmin) ─────────────────────────────────
  Future<bool> crearPais(String nombre) async {
    try {
      final res = await http.post(
        Uri.parse('$_baseUrl/paises'),
        headers: await _authHeaders(),
        body:    jsonEncode({'nombre': nombre}),
      );
      return res.statusCode == 201;
    } catch (_) {
      return false;
    }
  }
 
  // ── PUT /paises/:id — editar nombre (superadmin) ───────────────────────────
  Future<bool> editarPais(String id, String nuevoNombre) async {
    try {
      final res = await http.put(
        Uri.parse('$_baseUrl/paises/$id'),
        headers: await _authHeaders(),
        body:    jsonEncode({'nombre': nuevoNombre}),
      );
      return res.statusCode == 200;
    } catch (_) {
      return false;
    }
  }
 
  // ── PATCH /paises/:id/estado — activar / desactivar (superadmin) ───────────
  /// Llama al endpoint de mantenimiento. Cambia el portal a 'activo' o 'inactivo'.
  Future<bool> cambiarEstado(String id, String estado) async {
    try {
      final res = await http.patch(
        Uri.parse('$_baseUrl/paises/$id/estado'),
        headers: await _authHeaders(),
        body:    jsonEncode({'estado': estado}),
      );
      return res.statusCode == 200;
    } catch (_) {
      return false;
    }
  }
 
  // ── DELETE /paises/:id — eliminar país (superadmin) ────────────────────────
  Future<bool> eliminarPais(String id) async {
    try {
      final res = await http.delete(
        Uri.parse('$_baseUrl/paises/$id'),
        headers: await _authHeaders(),
      );
      return res.statusCode == 200;
    } catch (_) {
      return false;
    }
  }
}
