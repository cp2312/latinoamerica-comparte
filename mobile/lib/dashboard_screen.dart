import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mobile/constants/app_colors.dart';
import 'package:mobile/login_screen.dart';
import 'package:mobile/news_screen.dart';
import 'package:mobile/screens/models/dashboard_item.dart';
import 'package:mobile/screens/models/testimonio_model.dart';
import 'package:mobile/screens/widgets/dashboard_screen/dashboard_card.dart';
import 'package:mobile/screens/widgets/dashboard_screen/dashboard_header.dart';
import 'package:mobile/screens/widgets/dashboard_screen/country_card.dart';
import 'package:mobile/screens/widgets/dashboard_screen/activity_feed.dart';
import 'package:mobile/screens/widgets/solicitudes/solicitudes_screen.dart';
import 'package:mobile/screens/widgets/testimonios/testimonios_screen.dart';
import 'package:mobile/services/testimonios_service.dart';
import 'package:mobile/screens/widgets/pais/pais_screen.dart';

// ── Modelo de actividad ───────────────────────────────────────────────────────

class _ActividadItem {
  final String tipo;
  final String accion;
  final String texto;
  final String pais;
  final DateTime fecha;

  _ActividadItem.fromJson(Map<String, dynamic> j)
    : tipo = j['tipo'] ?? '',
      accion = j['accion'] ?? '',
      texto = j['texto'] ?? '',
      pais = j['pais'] ?? '',
      fecha = DateTime.tryParse(j['fecha'] ?? '') ?? DateTime.now();

  String get bandera {
    switch (pais.toLowerCase()) {
      case 'colombia': return '🇨🇴';
      case 'chile':    return '🇨🇱';
      case 'ecuador':  return '🇪🇨';
      case 'argentina':return '🇦🇷';
      default:         return '🌎';
    }
  }

  String get tiempoRelativo {
    final diff = DateTime.now().difference(fecha);
    if (diff.inMinutes < 1)  return 'ahora';
    if (diff.inMinutes < 60) return 'hace ${diff.inMinutes} min';
    if (diff.inHours < 24)   return 'hace ${diff.inHours} h';
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
        'Content-Type': 'application/json',
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

// ── Modelo de métricas por país ───────────────────────────────────────────────

class _PaisMetrics {
  final String pais;
  final int pendientes;
  final int noticias;

  _PaisMetrics.fromJson(Map<String, dynamic> j)
    : pais = j['pais'] ?? '',
      pendientes = j['pendientes'] ?? 0,
      noticias = j['activas'] ?? 0;

  String get bandera {
    switch (pais.toLowerCase()) {
      case 'colombia': return '🇨🇴';
      case 'chile':    return '🇨🇱';
      case 'ecuador':  return '🇪🇨';
      case 'argentina':return '🇦🇷';
      default:         return '🌎';
    }
  }

  String get code {
    switch (pais.toLowerCase()) {
      case 'colombia': return 'CO';
      case 'chile':    return 'CL';
      case 'ecuador':  return 'EC';
      case 'argentina':return 'AR';
      default:         return '--';
    }
  }

  Color get accentColor {
    switch (pais.toLowerCase()) {
      case 'colombia': return AppColors.countryBorderCo;
      case 'chile':    return AppColors.countryBorderCl;
      case 'ecuador':  return AppColors.countryBorderEc;
      case 'argentina':return const Color(0xFF74ACDF);
      default:         return AppColors.primary;
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
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      final List solicitudes = json['solicitudesPorPais'] ?? [];
      final List noticias    = json['noticiasPorPais'] ?? [];
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
  late Future<List<_ActividadItem>>   _actividadFuture;
  late Future<List<_PaisMetrics>>     _metricasFuture;
  late Future<List<TestimonioModel>>  _testimoniosFuture;

  @override
  void initState() {
    super.initState();
    _refresh();
  }

  void _refresh() {
    setState(() {
      _actividadFuture   = _ActividadService().getActividad();
      _metricasFuture    = _MetricasService().getPorPais();
      _testimoniosFuture = TestimoniosService().getTestimonios();
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
      title: 'Solicitudes',
      subtitle: 'Pendientes',
      icon: Icons.mail_outline_rounded,
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const SolicitudesScreen()),
      ).then((_) => _refresh()),
    ),
    DashboardItem(
      title: 'Noticias',
      subtitle: 'Gestionar',
      icon: Icons.article_outlined,
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const NewsScreen()),
      ).then((_) => _refresh()),
    ),
    DashboardItem(
      title: 'Testimonios',
      subtitle: 'Gestionar',
      icon: Icons.star_border_rounded,
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const TestimoniosScreen()),
      ).then((_) => _refresh()),
    ),
    DashboardItem(
      title: 'Países',
      subtitle: 'Activar / desactivar portales',
      icon: Icons.public_rounded,
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const PaisesScreen()),
      ).then((_) => _refresh()),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      body: Column(
        children: [
          DashboardHeader(userRole: 'Superadmin', country: 'Global', onLogout: () => _logout(context)),
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
            _sectionLabel('Acceso rápido'),
            const SizedBox(height: 10),
            _buildQuickGrid(items),
            const SizedBox(height: 20),
            _sectionLabel('Testimonios'),
            const SizedBox(height: 10),
            _buildTestimonios(),
            const SizedBox(height: 20),
            _sectionLabel('Por país'),
            const SizedBox(height: 10),
            _buildPorPais(),
            const SizedBox(height: 20),
            _sectionLabel('Actividad reciente'),
            const SizedBox(height: 10),
            _buildActivityFeed(),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  // ── Quick grid ────────────────────────────────────────────────────────────

  Widget _buildQuickGrid(List<DashboardItem> items) {
    return GridView.builder(
      itemCount: items.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 1.1,
      ),
      itemBuilder: (_, i) => DashboardCard(item: items[i]),
    );
  }

  // ── Testimonios ───────────────────────────────────────────────────────────

  Widget _buildTestimonios() {
    return FutureBuilder<List<TestimonioModel>>(
      future: _testimoniosFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _loadingCard();
        }
        final testimonios = snapshot.data ?? [];
        if (testimonios.isEmpty) {
          return _emptyCard(
            icon: Icons.star_border_rounded,
            label: 'No hay testimonios aún',
          );
        }
        return Column(
          children: testimonios.map((t) => _TestimonioCard(t: t)).toList(),
        );
      },
    );
  }

  // ── Por país ──────────────────────────────────────────────────────────────

  Widget _buildPorPais() {
    return FutureBuilder<List<_PaisMetrics>>(
      future: _metricasFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _loadingCard();
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

  // ── Actividad ─────────────────────────────────────────────────────────────

  Widget _buildActivityFeed() {
    return FutureBuilder<List<_ActividadItem>>(
      future: _actividadFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _loadingCard();
        }
        final actividad = snapshot.data ?? [];
        if (actividad.isEmpty) {
          return _emptyCard(
            icon: Icons.history,
            label: 'Sin actividad reciente',
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

  // ── Helpers de UI ─────────────────────────────────────────────────────────

  Widget _loadingCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.fieldBorder, width: 0.5),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.05),
            blurRadius: 12,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: const Center(
        child: CircularProgressIndicator(color: AppColors.primary),
      ),
    );
  }

  Widget _emptyCard({required IconData icon, required String label}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.fieldBorder, width: 0.5),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.05),
            blurRadius: 12,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: AppColors.fieldBg,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: AppColors.primary, size: 18),
          ),
          const SizedBox(width: 12),
          Text(
            label,
            style: const TextStyle(
              color: AppColors.fieldLabel,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionLabel(String text) {
    return Row(
      children: [
        Text(
          text.toUpperCase(),
          style: const TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w600,
            color: AppColors.primary,
            letterSpacing: 1.5,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Container(
            height: 0.5,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.fieldBorder, Colors.transparent],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLogoutButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: OutlinedButton.icon(
        onPressed: () => _logout(context),
        icon: const Icon(
          Icons.logout_rounded,
          size: 18,
          color: AppColors.primary,
        ),
        label: const Text(
          'Cerrar sesión',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppColors.primary,
          ),
        ),
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: AppColors.fieldBorder, width: 1),
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
    );
  }
}

// ── Card de testimonio ────────────────────────────────────────────────────────

class _TestimonioCard extends StatelessWidget {
  final TestimonioModel t;
  const _TestimonioCard({required this.t});

  Color get _colorEstado => switch (t.estado) {
    'publicado'    => const Color(0xFF7B3FA0),
    'despublicado' => const Color(0xFFE91E63),
    _              => const Color(0xFF9CA3AF),
  };

  Color get _bgEstado => switch (t.estado) {
    'publicado'    => const Color(0xFFEDE7F6),
    'despublicado' => const Color(0xFFFCE4EC),
    _              => const Color(0xFFF3F4F6),
  };

  Color get _accentColor => switch (t.pais.toLowerCase()) {
    'colombia'  => AppColors.countryBorderCo,
    'chile'     => AppColors.countryBorderCl,
    'ecuador'   => AppColors.countryBorderEc,
    'argentina' => const Color(0xFF74ACDF),
    _           => AppColors.primary,
  };

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.fieldBorder, width: 0.5),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.06),
            blurRadius: 14,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: IntrinsicHeight(
          child: Row(
            children: [
              // Barra lateral con gradiente
              Container(
                width: 4,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      _accentColor,
                      _accentColor.withOpacity(0.5),
                    ],
                  ),
                ),
              ),
              // Avatar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
                child: _avatar(),
              ),
              // Info
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 11),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        t.nombre,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppColors.fieldText,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        '${t.bandera}  ${t.pais}',
                        style: const TextStyle(
                          fontSize: 10,
                          color: AppColors.primary,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 7,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: _bgEstado,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          t.estado.toUpperCase(),
                          style: TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.w700,
                            color: _colorEstado,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Fecha + chevron
              Padding(
                padding: const EdgeInsets.only(right: 12),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.fieldBg,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: AppColors.fieldBorder,
                          width: 0.5,
                        ),
                      ),
                      child: Text(
                        t.fechaFormateada,
                        style: const TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.w500,
                          color: AppColors.primaryDark,
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Icon(
                      Icons.chevron_right_rounded,
                      size: 16,
                      color: AppColors.primary.withOpacity(0.4),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _avatar() {
    final tieneUrl = t.fotoUrl != null && t.fotoUrl!.isNotEmpty;
    if (tieneUrl) {
      return CircleAvatar(
        radius: 20,
        backgroundColor: AppColors.fieldBg,
        backgroundImage: NetworkImage(t.fotoUrl!),
        onBackgroundImageError: (_, __) {},
      );
    }
    return CircleAvatar(
      radius: 20,
      backgroundColor: AppColors.fieldBg,
      child: Text(
        t.nombre.isNotEmpty ? t.nombre[0].toUpperCase() : '?',
        style: const TextStyle(
          color: AppColors.primary,
          fontWeight: FontWeight.w800,
          fontSize: 16,
        ),
      ),
    );
  }
}