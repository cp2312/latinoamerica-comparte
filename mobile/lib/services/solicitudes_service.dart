import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

// ── Clase resultado de envío ──────────────────────────────────────────────────

class RespuestaEnvio {
  final bool   ok;
  final String mensaje;
  RespuestaEnvio({required this.ok, required this.mensaje});
}


// ── Modelo ────────────────────────────────────────────────────────────────────

class SolicitudModel {
  final String  id;
  final String  nombre;
  final String  correo;
  final String  telefono;
  final String  finalidad;
  final String  pais;
  final String  estado;
  final String? createdAt;

  SolicitudModel.fromJson(Map<String, dynamic> j)
      : id        = j['_id']       ?? '',
        nombre    = j['nombre']    ?? '',
        correo    = j['correo']    ?? '',
        telefono  = j['telefono']  ?? '',
        finalidad = j['finalidad'] ?? '',
        pais      = j['pais']      ?? '',
        estado    = j['estado']    ?? 'pendiente',
        createdAt = j['createdAt'];

  String get bandera {
    switch (pais.toLowerCase()) {
      case 'colombia':  return '🇨🇴';
      case 'chile':     return '🇨🇱';
      case 'ecuador':   return '🇪🇨';
      case 'argentina': return '🇦🇷';
      default:          return '🌎';
    }
  }

  String get fechaFormateada {
    if (createdAt == null) return '';
    try { return createdAt!.substring(0, 10); } catch (_) { return ''; }
  }
}

// ── Servicio ──────────────────────────────────────────────────────────────────

class SolicitudesService {
  static const String _baseUrl = 'http://localhost:3000';

  Future<Map<String, String>> _authHeaders() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';
    return {
      'Content-Type':  'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  // POST /solicitudes/public
  Future<bool> enviarSolicitudPublica({
    required String nombre,
    required String correo,
    required String telefono,
    required String finalidad,
    required String pais,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/solicitudes/public'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'nombre': nombre, 'correo': correo, 'telefono': telefono,
          'finalidad': finalidad, 'pais': pais,
        }),
      );
      return response.statusCode == 201;
    } catch (_) { return false; }
  }

  // GET /solicitudes
  Future<List<SolicitudModel>> getSolicitudes({
    String? pais, String? estado,
  }) async {
    try {
      String path = '/solicitudes';
      final params = <String>[];
      if (pais   != null) params.add('pais=$pais');
      if (estado != null) params.add('estado=$estado');
      if (params.isNotEmpty) path += '?${params.join('&')}';

      final response = await http.get(
        Uri.parse('$_baseUrl$path'),
        headers: await _authHeaders(),
      );

      if (response.statusCode == 200) {
        final List data = jsonDecode(response.body);
        return data.map((e) => SolicitudModel.fromJson(e)).toList();
      }
      return [];
    } catch (_) { return []; }
  }

  // PATCH /solicitudes/:id/estado
  Future<bool> cambiarEstado(String id, String estado) async {
    try {
      final response = await http.patch(
        Uri.parse('$_baseUrl/solicitudes/$id/estado'),
        headers: await _authHeaders(),
        body: jsonEncode({'estado': estado}),
      );
      return response.statusCode == 200;
    } catch (_) { return false; }
  }

  // POST /solicitudes/:id/responder — envía correo de respuesta
  Future<RespuestaEnvio> responder(String id, String mensaje) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/solicitudes/$id/responder'),
        headers: await _authHeaders(),
        body: jsonEncode({'mensaje': mensaje}),
      );
      if (response.statusCode == 200) {
        return RespuestaEnvio(ok: true, mensaje: 'Correo enviado correctamente');
      }
      final body = jsonDecode(response.body);
      return RespuestaEnvio(ok: false, mensaje: body['message'] ?? 'Error al enviar');
    } catch (e) {
      return RespuestaEnvio(ok: false, mensaje: 'Error de conexión: $e');
    }
  }

  // DELETE /solicitudes/:id
  Future<bool> eliminar(String id) async {
    try {
      final response = await http.delete(
        Uri.parse('$_baseUrl/solicitudes/$id'),
        headers: await _authHeaders(),
      );
      return response.statusCode == 200;
    } catch (_) { return false; }
  }
}