import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mobile/constants/app_colors.dart';
import 'package:mobile/login_screen.dart';
import 'package:mobile/news_screen.dart';
import 'package:mobile/screens/models/dashboard_item.dart';
import 'package:mobile/screens/widgets/dashboard_screen/dashboard_card.dart';
import 'package:mobile/screens/widgets/dashboard_screen/dashboard_header.dart';
import 'package:mobile/screens/widgets/dashboard_screen/metric_tile.dart';
import 'package:mobile/screens/widgets/dashboard_screen/country_card.dart';
import 'package:mobile/screens/widgets/dashboard_screen/activity_feed.dart';
import 'package:mobile/screens/widgets/solicitudes/solicitudes_screen.dart';
import 'package:mobile/screens/widgets/testimonios/testimonios_screen.dart';

// ── Modelo de actividad ───────────────────────────────────────────────────────

class _ActividadItem {
  final String tipo;
  final String accion;
  final String texto;
  final String pais;
  final DateTime fecha;

  _ActividadItem.fromJson(Map<String, dynamic> j)
      : tipo   = j['tipo']   ?? '',
        accion = j['accion'] ?? '',
        texto  = j['texto']  ?? '',
        pais   = j['pais']   ?? '',
        fecha  = DateTime.tryParse(j['fecha'] ?? '') ?? DateTime.now();

  String get bandera {
    switch (pais.toLowerCase()) {
      case 'colombia':  return '🇨🇴';
      case 'chile':     return '🇨🇱';
      case 'ecuador':   return '🇪🇨';
      case 'argentina': return '🇦🇷';
      default:          return '🌎';
    }
  }

  String get tiempoRelativo {
    final diff = DateTime.now().difference(fecha);
    if (diff.inMinutes < 1)  return 'ahora';
    if (diff.inMinutes < 60) return 'hace ${diff.inMinutes} min';
    if (diff.inHours   < 24) return 'hace ${diff.inHours} h';
    return 'hace ${diff.inDays} días';
  }

  ActivityType get activityType {
    switch (tipo) {
      case 'solicitud':  return ActivityType.pending;
      case 'testimonio': return ActivityType.testimonial;
      default:           return ActivityType.published;
    }
  }
}

// ── Servicio de actividad ─────────────────────────────────────────────────────

class _ActividadService {
  static const String _base = 'http://localhost:3000/dashboard';

  Future<List<_ActividadItem>> getActividad() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';

    final response = await http.get(
      Uri.parse('$_base/actividad'),
      headers: {
        'Content-Type':  'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((e) => _ActividadItem.fromJson(e)).toList();
    }
    throw Exception('Error ${response.statusCode}');
  }
}

// ── Modelo de métricas por país ──────────────────────────────────────────────

class _PaisMetrics {
  final String pais;
  final int    pendientes;
  final int    noticias;

  _PaisMetrics.fromJson(Map<String, dynamic> j)
      : pais       = j['pais']      ?? '',
        pendientes = j['pendientes'] ?? 0,
        noticias   = j['activas']    ?? 0;

  String get bandera {
    switch (pais.toLowerCase()) {
      case 'colombia':  return '🇨🇴';
      case 'chile':     return '🇨🇱';
      case 'ecuador':   return '🇪🇨';
      case 'argentina': return '🇦🇷';
      default:          return '🌎';
    }
  }

  String get code {
    switch (pais.toLowerCase()) {
      case 'colombia':  return 'CO';
      case 'chile':     return 'CL';
      case 'ecuador':   return 'EC';
      case 'argentina': return 'AR';
      default:          return '--';
    }
  }

  Color get accentColor {
    switch (pais.toLowerCase()) {
      case 'colombia':  return AppColors.countryBorderCo;
      case 'chile':     return AppColors.countryBorderCl;
      case 'ecuador':   return AppColors.countryBorderEc;
      case 'argentina': return const Color(0xFF74ACDF);
      default:          return AppColors.primary;
    }
  }
}

// ── Servicio de métricas ──────────────────────────────────────────────────────

class _MetricasService {
  static const String _base = 'http://localhost:3000/dashboard';

  Future<List<_PaisMetrics>> getPorPais() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';

    final response = await http.get(
      Uri.parse('$_base/metricas'),
      headers: {
        'Content-Type':  'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final json   = jsonDecode(response.body);
      final List solicitudes = json['solicitudesPorPais'] ?? [];
      final List noticias    = json['noticiasPorPais']    ?? [];

      return solicitudes.map<_PaisMetrics>((s) {
        final n = (noticias as List).firstWhere(
          (n) => n['pais'] == s['pais'],
          orElse: () => {'pais': s['pais'], 'activas': 0},
        );
        return _PaisMetrics.fromJson({
          'pais':       s['pais'],
          'pendientes': s['pendientes'],
          'activas':    n['activas'],
        });
      }).toList();
    }
    throw Exception('Error ${response.statusCode}');
  }
}

// ── Pantalla ──────────────────────────────────────────────────────────────────

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  late Future<List<_ActividadItem>> _actividadFuture;
  late Future<List<_PaisMetrics>>   _metricasFuture;

  @override
  void initState() {
    super.initState();
    _actividadFuture = _ActividadService().getActividad();
    _metricasFuture  = _MetricasService().getPorPais();
  }

  void _refresh() {
    setState(() {
      _actividadFuture = _ActividadService().getActividad();
      _metricasFuture  = _MetricasService().getPorPais();
    });
  }

  Future<void> _logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    await prefs.remove('user_rol');
    await prefs.remove('user_nombre');
    await prefs.remove('user_pais');
    if (!context.mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
    );
  }

  List<DashboardItem> _quickItems(BuildContext context) => [
    DashboardItem(
      title:    'Solicitudes',
      subtitle: 'Pendientes',
      icon:     Icons.mail_outline_rounded,
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const SolicitudesScreen()),
      ).then((_) => _refresh()),
    ),
    DashboardItem(
      title:    'Noticias',
      subtitle: 'Gestionar',
      icon:     Icons.article_outlined,
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const NewsScreen()),
      ).then((_) => _refresh()),
    ),
    DashboardItem(
      title:    'Testimonios',
      subtitle: 'Gestionar',
      icon:     Icons.star_border_rounded,
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const TestimoniosScreen()),
      ).then((_) => _refresh()),
    ),
    DashboardItem(
      title:    'Países',
      subtitle: '4 portales',
      icon:     Icons.map_outlined,
      onTap:    () {},
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      body: Column(
        children: [
          const DashboardHeader(userRole: 'Superadmin', country: 'Global'),
          Expanded(child: _buildScrollContent(context)),
        ],
      ),
    );
  }

  Widget _buildScrollContent(BuildContext context) {
    final items = _quickItems(context);
    return RefreshIndicator(
      color: AppColors.primary,
      onRefresh: () async => _refresh(),
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(16, 6, 16, 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _sectionLabel('Resumen global'),
            const SizedBox(height: 10),
            _buildMetrics(),
            const SizedBox(height: 18),

            _sectionLabel('Acceso rápido'),
            const SizedBox(height: 10),
            _buildQuickGrid(items),
            const SizedBox(height: 18),

            _sectionLabel('Por país'),
            const SizedBox(height: 10),
            _buildPorPais(),
            const SizedBox(height: 8),

            _sectionLabel('Actividad reciente'),
            const SizedBox(height: 10),
            _buildActivityFeed(),
            const SizedBox(height: 18),

            _buildLogoutButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildPorPais() {
    return FutureBuilder<List<_PaisMetrics>>(
      future: _metricasFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: CircularProgressIndicator(color: AppColors.primary),
            ),
          );
        }

        final paises = snapshot.data ?? [];
        if (paises.isEmpty) return const SizedBox.shrink();

        return Column(
          children: paises.map((p) => CountryCard(
            data: CountryData(
              flag:        p.bandera,
              name:        p.pais,
              code:        p.code,
              pending:     p.pendientes,
              news:        p.noticias,
              accentColor: p.accentColor,
            ),
          )).toList(),
        );
      },
    );
  }

  Widget _buildActivityFeed() {
    return FutureBuilder<List<_ActividadItem>>(
      future: _actividadFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: AppColors.fieldBorder, width: 0.5),
            ),
            child: const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            ),
          );
        }

        final actividad = snapshot.data ?? [];
        if (actividad.isEmpty) {
          return Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: AppColors.fieldBorder, width: 0.5),
            ),
            child: Row(
              children: const [
                Icon(Icons.history, color: AppColors.fieldBorder, size: 20),
                SizedBox(width: 10),
                Text('Sin actividad reciente',
                    style: TextStyle(color: Colors.black45, fontSize: 13)),
              ],
            ),
          );
        }

        final entries = actividad.map((a) => ActivityEntry(
          text: '${a.texto}${a.pais.isNotEmpty ? ' · ${a.bandera}' : ''}',
          time: a.tiempoRelativo,
          type: a.activityType,
        )).toList();

        return ActivityFeed(entries: entries);
      },
    );
  }

  Widget _buildMetrics() {
    return GridView.count(
      crossAxisCount: 2,
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      childAspectRatio: 1.1,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: const [
        MetricTile(icon: Icons.mail_outline_rounded, value: '—', label: 'Solicitudes pendientes', dark: true),
        MetricTile(icon: Icons.star_border_rounded,  value: '—', label: 'Testimonios publicados'),
        MetricTile(icon: Icons.article_outlined,     value: '—', label: 'Noticias activas'),
        MetricTile(icon: Icons.language_rounded,     value: '4', label: 'Portales activos', dark: true),
      ],
    );
  }

  Widget _buildQuickGrid(List<DashboardItem> items) {
    return GridView.builder(
      itemCount: items.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, crossAxisSpacing: 10,
        mainAxisSpacing: 10, childAspectRatio: 1.1,
      ),
      itemBuilder: (_, i) => DashboardCard(item: items[i]),
    );
  }

  Widget _sectionLabel(String text) {
    return Row(
      children: [
        Text(text.toUpperCase(),
            style: const TextStyle(
              fontSize: 10, fontWeight: FontWeight.w500,
              color: AppColors.primary, letterSpacing: 1,
            )),
        const SizedBox(width: 8),
        Expanded(child: Container(height: 0.5, color: AppColors.fieldBorder)),
      ],
    );
  }

  Widget _buildLogoutButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: OutlinedButton.icon(
        onPressed: () => _logout(context),
        icon: const Icon(Icons.logout_rounded, size: 18, color: AppColors.primary),
        label: const Text('Cerrar sesión',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.primary)),
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: AppColors.fieldBorder, width: 1),
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
      ),
    );
  }
}