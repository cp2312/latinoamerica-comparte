// lib/services/dashboard_service.dart
//
// Obtiene métricas del backend.
// El superadmin llama a /dashboard/metricas → globales.
// El admin_pais llama a /dashboard/metricas?pais=Colombia → solo su país.
// El backend ya filtra por JWT; el parámetro es solo para mostrar
// la sección correcta en el dashboard.

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mobile/constants/api_constants.dart';

// ── Modelos ───────────────────────────────────────────────────────────────────

class PaisResumen {
  final String pais;
  final int solicitudesPendientes;
  final int solicitudesTotal;
  final int noticiasActivas;

  const PaisResumen({
    required this.pais,
    required this.solicitudesPendientes,
    required this.solicitudesTotal,
    required this.noticiasActivas,
  });
}

class DashboardMetrics {
  final int totalNoticias;
  final int noticiasActivas;
  final int totalTestimonios;
  final int testimoniosPublicados;
  final int totalSolicitudes;
  final int solicitudesPendientes;
  final List<PaisResumen> porPais;

  const DashboardMetrics({
    required this.totalNoticias,
    required this.noticiasActivas,
    required this.totalTestimonios,
    required this.testimoniosPublicados,
    required this.totalSolicitudes,
    required this.solicitudesPendientes,
    required this.porPais,
  });

  factory DashboardMetrics.fromJson(Map<String, dynamic> j) {
    final g = j['globales'] as Map<String, dynamic>;

    final solicList = (j['solicitudesPorPais'] as List? ?? []);
    final noticList = (j['noticiasPorPais'] as List? ?? []);

    final pendMap = <String, int>{
      for (final e in solicList)
        e['pais'] as String: (e['pendientes'] as num).toInt(),
    };
    final totalSol = <String, int>{
      for (final e in solicList)
        e['pais'] as String: (e['total'] as num).toInt(),
    };
    final activasMap = <String, int>{
      for (final e in noticList)
        e['pais'] as String: (e['activas'] as num).toInt(),
    };

    const paises = ['Colombia', 'Chile', 'Ecuador', 'Argentina'];
    final porPais = paises
        .map(
          (p) => PaisResumen(
            pais: p,
            solicitudesPendientes: pendMap[p] ?? 0,
            solicitudesTotal: totalSol[p] ?? 0,
            noticiasActivas: activasMap[p] ?? 0,
          ),
        )
        .toList();

    return DashboardMetrics(
      totalNoticias: (g['totalNoticias'] as num).toInt(),
      noticiasActivas: (g['noticiasActivas'] as num).toInt(),
      totalTestimonios: (g['totalTestimonios'] as num).toInt(),
      testimoniosPublicados: (g['testimoniosPublicados'] as num).toInt(),
      totalSolicitudes: (g['totalSolicitudes'] as num).toInt(),
      solicitudesPendientes: (g['solicitudesPendientes'] as num).toInt(),
      porPais: porPais,
    );
  }

  /// Retorna el resumen de un país específico.
  PaisResumen? resumenDePais(String pais) {
    try {
      return porPais.firstWhere(
        (p) => p.pais.toLowerCase() == pais.toLowerCase(),
      );
    } catch (_) {
      return null;
    }
  }
}

// ── Servicio ──────────────────────────────────────────────────────────────────

class DashboardService {
  static const String _baseUrl = ApiConstants.baseUrl;

  Future<Map<String, String>> _headers() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  Future<DashboardMetrics?> getMetricas() async {
    try {
      final res = await http.get(
        Uri.parse('$_baseUrl/dashboard/metricas'),
        headers: await _headers(),
      );
      if (res.statusCode == 200) {
        return DashboardMetrics.fromJson(
          jsonDecode(res.body) as Map<String, dynamic>,
        );
      }
      return null;
    } catch (_) {
      return null;
    }
  }

  // GET /dashboard/metricas-pais — solo para admin_pais
  Future<Map<String, dynamic>?> getMetricasPais() async {
    try {
      final res = await http.get(
        Uri.parse('$_baseUrl/dashboard/metricas-pais'),
        headers: await _headers(),
      );
      if (res.statusCode == 200) {
        return jsonDecode(res.body) as Map<String, dynamic>;
      }
      return null;
    } catch (_) {
      return null;
    }
  }
}