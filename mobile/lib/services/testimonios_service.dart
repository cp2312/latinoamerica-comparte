// lib/services/testimonios_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mobile/screens/models/testimonio_model.dart';

class TestimoniosService {
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

  // ── GET /testimonios — con JWT (admin) ─────────────────────────────────────
  Future<List<TestimonioModel>> getTestimonios({
    String? pais,
    String? estado,
  }) async {
    try {
      final params = <String>[];
      if (pais   != null && pais.isNotEmpty)   params.add('pais=$pais');
      if (estado != null && estado.isNotEmpty) params.add('estado=$estado');
      final qs   = params.isEmpty ? '' : '?${params.join('&')}';
      final uri  = Uri.parse('$_baseUrl/testimonios$qs');

      final res = await http.get(uri, headers: await _authHeaders());
      if (res.statusCode == 200) {
        final List data = jsonDecode(res.body);
        return data.map((e) => TestimonioModel.fromJson(e)).toList();
      }
      return [];
    } catch (_) {
      return [];
    }
  }

  // ── GET /testimonios/publicos — sin JWT, solo publicados ──────────────────
  Future<List<TestimonioModel>> getTestimoniosPublicos({String? pais}) async {
    try {
      final params = <String>[];
      if (pais != null && pais.isNotEmpty) params.add('pais=$pais');
      final qs  = params.isEmpty ? '' : '?${params.join('&')}';
      final uri = Uri.parse('$_baseUrl/testimonios/public$qs');

      final res = await http.get(uri, headers: {'Content-Type': 'application/json'});
      if (res.statusCode == 200) {
        final List data = jsonDecode(res.body);
        return data.map((e) => TestimonioModel.fromJson(e)).toList();
      }
      return [];
    } catch (_) {
      return [];
    }
  }

  // ── POST /testimonios ──────────────────────────────────────────────────────
  Future<bool> crearTestimonio({
    required String nombre,
    required String testimonio,
    required String pais,
    String? fotoUrl,
    String? instagramUrl,
    String? facebookUrl,
    String  estado = 'borrador',
  }) async {
    try {
      final body = <String, dynamic>{
        'nombre':     nombre,
        'testimonio': testimonio,
        'pais':       pais,
        'estado':     estado,
        if (fotoUrl      != null && fotoUrl.isNotEmpty)      'foto_url':      fotoUrl,
        if (instagramUrl != null && instagramUrl.isNotEmpty) 'instagram_url': instagramUrl,
        if (facebookUrl  != null && facebookUrl.isNotEmpty)  'facebook_url':  facebookUrl,
      };
      final res = await http.post(
        Uri.parse('$_baseUrl/testimonios'),
        headers: await _authHeaders(),
        body: jsonEncode(body),
      );
      return res.statusCode == 201;
    } catch (_) {
      return false;
    }
  }

  // ── PUT /testimonios/:id ───────────────────────────────────────────────────
  Future<bool> actualizarTestimonio({
    required String id,
    required String nombre,
    required String testimonio,
    required String pais,
    String? fotoUrl,
    String? instagramUrl,
    String? facebookUrl,
    String  estado = 'borrador',
  }) async {
    try {
      final body = <String, dynamic>{
        'nombre':        nombre,
        'testimonio':    testimonio,
        'pais':          pais,
        'estado':        estado,
        'foto_url':      fotoUrl      ?? '',
        'instagram_url': instagramUrl ?? '',
        'facebook_url':  facebookUrl  ?? '',
      };
      final res = await http.put(
        Uri.parse('$_baseUrl/testimonios/$id'),
        headers: await _authHeaders(),
        body: jsonEncode(body),
      );
      return res.statusCode == 200;
    } catch (_) {
      return false;
    }
  }

  // ── PATCH /testimonios/:id/estado ──────────────────────────────────────────
  Future<bool> cambiarEstado(String id, String estado) async {
    try {
      final res = await http.patch(
        Uri.parse('$_baseUrl/testimonios/$id/estado'),
        headers: await _authHeaders(),
        body: jsonEncode({'estado': estado}),
      );
      return res.statusCode == 200;
    } catch (_) {
      return false;
    }
  }

  // ── DELETE /testimonios/:id ────────────────────────────────────────────────
  Future<bool> eliminarTestimonio(String id) async {
    try {
      final res = await http.delete(
        Uri.parse('$_baseUrl/testimonios/$id'),
        headers: await _authHeaders(),
      );
      return res.statusCode == 200;
    } catch (_) {
      return false;
    }
  }
}