// lib/dashboard_admin_pais_screen.dart

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mobile/constants/app_colors.dart';
import 'package:mobile/login_screen.dart';
import 'package:mobile/news_screen.dart';
import 'package:mobile/screens/models/dashboard_item.dart';
import 'package:mobile/screens/models/user_model.dart';
import 'package:mobile/screens/models/testimonio_model.dart';
import 'package:mobile/screens/widgets/dashboard_screen/dashboard_card.dart';
import 'package:mobile/screens/widgets/dashboard_screen/activity_feed.dart';
import 'package:mobile/screens/widgets/dashboard_screen/country_card.dart';
import 'package:mobile/screens/widgets/solicitudes/solicitudes_screen.dart';
import 'package:mobile/screens/widgets/testimonios/testimonios_screen.dart';
import 'package:mobile/services/dashboard_service.dart';
import 'package:mobile/services/testimonios_service.dart';

// ── Actividad filtrada por país ───────────────────────────────────────────────

class _ActividadService {
  static const String _base = 'http://localhost:3000/dashboard';

  Future<List<ActivityEntry>> getActividad(String pais) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';
    try {
      final uri = Uri.parse(
          '$_base/actividad?pais=${Uri.encodeQueryComponent(pais)}');
      final res = await http.get(uri, headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      });
      if (res.statusCode == 200) {
        final List data = jsonDecode(res.body);
        return data.map<ActivityEntry>((a) {
          final tipo  = a['tipo']  ?? '';
          final texto = a['texto'] ?? '';

          ActivityType type;
          switch (tipo) {
            case 'solicitud':
              type = ActivityType.pending;
              break;
            case 'testimonio':
              type = ActivityType.testimonial;
              break;
            default:
              type = ActivityType.published;
          }

          final fecha = DateTime.tryParse(a['fecha'] ?? '') ?? DateTime.now();
          final diff  = DateTime.now().difference(fecha);
          String tiempo;
          if (diff.inMinutes < 1)       tiempo = 'ahora';
          else if (diff.inMinutes < 60) tiempo = 'hace ${diff.inMinutes} min';
          else if (diff.inHours < 24)   tiempo = 'hace ${diff.inHours} h';
          else                          tiempo = 'hace ${diff.inDays} días';

          return ActivityEntry(text: texto, time: tiempo, type: type);
        }).toList();
      }
      return [];
    } catch (_) {
      return [];
    }
  }
}

// ── Pantalla ──────────────────────────────────────────────────────────────────

class DashboardAdminPaisScreen extends StatefulWidget {
  final UserModel usuario;
  const DashboardAdminPaisScreen({super.key, required this.usuario});

  @override
  State<DashboardAdminPaisScreen> createState() =>
      _DashboardAdminPaisScreenState();
}

class _DashboardAdminPaisScreenState
    extends State<DashboardAdminPaisScreen> {

  late Future<Map<String, dynamic>?> _metricasFuture;
  late Future<List<TestimonioModel>> _testimoniosFuture;
  late Future<List<ActivityEntry>>   _actividadFuture;

  String get _pais => widget.usuario.paisDisplay;

  // País en minúscula para filtros del backend
  String get _paisLower => _pais.toLowerCase();

  @override
  void initState() {
    super.initState();
    _refresh();
  }

  void _refresh() {
    setState(() {
      _metricasFuture = DashboardService().getMetricasPais();

      // ✅ CORRECCIÓN: se pasa en minúscula para que coincida con el backend
      _testimoniosFuture = TestimoniosService().getTestimonios(
        pais: _paisLower,
      );

      // ✅ CORRECCIÓN: se pasa en minúscula para que coincida con el backend
      _actividadFuture = _ActividadService().getActividad(_paisLower);
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

  // ── Items del grid ────────────────────────────────────────────────────────
  List<DashboardItem> _quickItems(BuildContext context) => [
        DashboardItem(
          title:    'Solicitudes',
          subtitle: 'De $_pais',
          icon:     Icons.mail_outline_rounded,
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => SolicitudesScreen(filtroPais: _pais),
            ),
          ).then((_) => _refresh()),
        ),
        DashboardItem(
          title:    'Noticias',
          subtitle: 'De $_pais',
          icon:     Icons.article_outlined,
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const NewsScreen()),
          ).then((_) => _refresh()),
        ),
        DashboardItem(
          title:    'Testimonios',
          subtitle: 'De $_pais',
          icon:     Icons.star_border_rounded,
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => TestimoniosScreen(filtroPais: _pais),
            ),
          ).then((_) => _refresh()),
        ),
        DashboardItem(
          title:    'Mi Perfil',
          subtitle: widget.usuario.rolDisplay,
          icon:     Icons.manage_accounts_outlined,
          onTap:    () {}, // Fase 5
        ),
      ];

  // ── Build ─────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      body: Column(
        children: [
          _buildHeader(),
          Expanded(child: _buildScroll(context)),
        ],
      ),
    );
  }

  // ── Header con ola ────────────────────────────────────────────────────────
  Widget _buildHeader() {
    final top    = MediaQuery.of(context).padding.top;
    final partes = widget.usuario.nombre.trim().split(' ');

    return ClipPath(
      clipper: _WaveClipper(),
      child: Container(
        color: AppColors.heroBottom,
        padding: EdgeInsets.fromLTRB(20, top + 14, 20, 36),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'PANEL ADMINISTRATIVO',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.50),
                    fontSize: 10,
                    letterSpacing: 1.8,
                  ),
                ),
                Row(children: [
                  Icon(Icons.wifi,
                      size: 13, color: Colors.white.withOpacity(0.70)),
                  const SizedBox(width: 4),
                  Icon(Icons.battery_full_rounded,
                      size: 13, color: Colors.white.withOpacity(0.70)),
                ]),
              ],
            ),
            const SizedBox(height: 14),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Hola, ${partes.first} 👋',
                        style: const TextStyle(
                          color: Colors.white, fontSize: 20,
                          fontWeight: FontWeight.w500, letterSpacing: -0.3,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(children: [
                        _chip(Icons.verified_user_outlined,
                            widget.usuario.rolDisplay),
                        const SizedBox(width: 8),
                        _chip(Icons.public_outlined,
                            '${widget.usuario.bandera} $_pais'),
                      ]),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                GestureDetector(
                  onTap: () => _logout(context),
                  child: Container(
                    width: 44, height: 44,
                    decoration: BoxDecoration(
                      shape:  BoxShape.circle,
                      color:  Colors.white.withOpacity(0.20),
                      border: Border.all(
                          color: Colors.white.withOpacity(0.40), width: 1.5),
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.logout_rounded,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _chip(IconData icon, String label) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.15),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
              color: Colors.white.withOpacity(0.25), width: 0.5),
        ),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          Icon(icon, size: 11, color: Colors.white.withOpacity(0.75)),
          const SizedBox(width: 5),
          Text(label,
              style: const TextStyle(
                  color: Colors.white, fontSize: 11,
                  fontWeight: FontWeight.w500)),
        ]),
      );

  // ── Scroll ────────────────────────────────────────────────────────────────
  Widget _buildScroll(BuildContext context) {
    final items = _quickItems(context);
    return RefreshIndicator(
      color:     AppColors.primary,
      onRefresh: () async => _refresh(),
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(16, 6, 16, 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _label('Acceso rápido'),
            const SizedBox(height: 10),
            _buildGrid(items),
            const SizedBox(height: 18),

            _label('Últimos testimonios'),
            const SizedBox(height: 10),
            _buildTestimonios(),
            const SizedBox(height: 18),

            _label('Por país'),
            const SizedBox(height: 10),
            _buildPorPais(),
            const SizedBox(height: 8),

            _label('Actividad reciente'),
            const SizedBox(height: 10),
            _buildActividad(),
            const SizedBox(height: 18),

          ],
        ),
      ),
    );
  }

  Widget _label(String text) => Row(children: [
        Text(
          text.toUpperCase(),
          style: const TextStyle(
            fontSize: 10, fontWeight: FontWeight.w500,
            color: AppColors.primary, letterSpacing: 1,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(child: Container(height: 0.5, color: AppColors.fieldBorder)),
      ]);

  Widget _buildGrid(List<DashboardItem> items) => GridView.builder(
        itemCount: items.length,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, crossAxisSpacing: 10,
          mainAxisSpacing: 10, childAspectRatio: 1.1,
        ),
        itemBuilder: (_, i) => DashboardCard(item: items[i]),
      );

  // ── Últimos 3 testimonios ─────────────────────────────────────────────────
  Widget _buildTestimonios() {
    return FutureBuilder<List<TestimonioModel>>(
      future: _testimoniosFuture,
      builder: (context, snap) {
        if (snap.connectionState == ConnectionState.waiting) {
          return _loadingCard();
        }
        final lista     = snap.data ?? [];
        final recientes = lista.take(3).toList();
        if (recientes.isEmpty) {
          return _emptyCard(
              Icons.record_voice_over_outlined, 'No hay testimonios aún');
        }
        return Column(
          children: recientes.map((t) => _TestimonioMiniCard(t: t)).toList(),
        );
      },
    );
  }

  // ── Card del país ─────────────────────────────────────────────────────────
  Widget _buildPorPais() {
    return FutureBuilder<Map<String, dynamic>?>(
      future: _metricasFuture,
      builder: (context, snap) {
        if (snap.connectionState == ConnectionState.waiting) {
          return _loadingCard();
        }
        int pendientes = 0;
        int noticias   = 0;
        if (snap.hasData && snap.data != null) {
          pendientes = (snap.data!['pendientes'] as num?)?.toInt() ?? 0;
          noticias   = (snap.data!['noticiasActivas'] as num?)?.toInt() ?? 0;
        }

        String bandera;
        Color  accent;
        String code;
        switch (_paisLower) {
          case 'colombia':
            bandera = '🇨🇴'; accent = AppColors.countryBorderCo; code = 'CO';
          case 'chile':
            bandera = '🇨🇱'; accent = AppColors.countryBorderCl; code = 'CL';
          case 'ecuador':
            bandera = '🇪🇨'; accent = AppColors.countryBorderEc; code = 'EC';
          default:
            bandera = '🌎'; accent = AppColors.primary; code = '--';
        }

        return CountryCard(
          data: CountryData(
            flag: bandera, name: _pais, code: code,
            pending: pendientes, news: noticias, accentColor: accent,
          ),
        );
      },
    );
  }

  // ── Actividad ─────────────────────────────────────────────────────────────
  Widget _buildActividad() {
    return FutureBuilder<List<ActivityEntry>>(
      future: _actividadFuture,
      builder: (context, snap) {
        if (snap.connectionState == ConnectionState.waiting) {
          return _loadingCard();
        }
        final entries = snap.data ?? [];
        if (entries.isEmpty) {
          return _emptyCard(Icons.history, 'Sin actividad reciente');
        }
        return ActivityFeed(entries: entries);
      },
    );
  }

  Widget _loadingCard() => Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: AppColors.fieldBorder, width: 0.5),
        ),
        child: const Center(
            child: CircularProgressIndicator(color: AppColors.primary)),
      );

  Widget _emptyCard(IconData icon, String mensaje) => Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: AppColors.fieldBorder, width: 0.5),
        ),
        child: Row(children: [
          Icon(icon, color: AppColors.fieldBorder, size: 20),
          const SizedBox(width: 10),
          Text(mensaje,
              style: const TextStyle(color: Colors.black45, fontSize: 13)),
        ]),
      );

  Widget _buildLogout(BuildContext context) => SizedBox(
        width:  double.infinity,
        height: 52,
        child: OutlinedButton.icon(
          onPressed: () => _logout(context),
          icon: const Icon(Icons.logout_rounded,
              size: 18, color: AppColors.primary),
          label: const Text('Cerrar sesión',
              style: TextStyle(
                  fontSize: 14, fontWeight: FontWeight.w500,
                  color: AppColors.primary)),
          style: OutlinedButton.styleFrom(
            side: const BorderSide(color: AppColors.fieldBorder, width: 1),
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16)),
          ),
        ),
      );
}

// ── Ola del header ────────────────────────────────────────────────────────────

class _WaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path()
      ..lineTo(0, size.height - 22)
      ..quadraticBezierTo(
          size.width / 2, size.height + 12, size.width, size.height - 22)
      ..lineTo(size.width, 0)
      ..close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> old) => false;
}

// ── Mini card de testimonio ───────────────────────────────────────────────────

class _TestimonioMiniCard extends StatelessWidget {
  final TestimonioModel t;
  const _TestimonioMiniCard({required this.t});

  Color get _colorEstado => switch (t.estado) {
        'publicado'    => const Color(0xFF10B981),
        'despublicado' => const Color(0xFFEF4444),
        _              => const Color(0xFF9CA3AF),
      };

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.fieldBorder, width: 0.5),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: IntrinsicHeight(
          child: Row(children: [
            Container(width: 4, color: _colorEstado),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
              child: CircleAvatar(
                radius: 20,
                backgroundColor: AppColors.fieldBg,
                backgroundImage: (t.fotoUrl != null && t.fotoUrl!.isNotEmpty)
                    ? NetworkImage(t.fotoUrl!) as ImageProvider
                    : null,
                child: (t.fotoUrl == null || t.fotoUrl!.isEmpty)
                    ? Text(
                        t.nombre.isNotEmpty ? t.nombre[0].toUpperCase() : '?',
                        style: const TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w800,
                          fontSize: 16,
                        ),
                      )
                    : null,
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 11),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(t.nombre,
                        style: const TextStyle(
                            fontSize: 13, fontWeight: FontWeight.w500,
                            color: AppColors.fieldText)),
                    const SizedBox(height: 3),
                    Text('${t.bandera}  ${t.pais}',
                        style: const TextStyle(
                            fontSize: 10, color: AppColors.primary)),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 7, vertical: 2),
                      decoration: BoxDecoration(
                        color: _colorEstado.withOpacity(0.10),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(t.estado.toUpperCase(),
                          style: TextStyle(
                              fontSize: 9, fontWeight: FontWeight.w700,
                              color: _colorEstado)),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 12),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  if (t.fechaFormateada.isNotEmpty)
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: AppColors.fieldBg,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                            color: AppColors.fieldBorder, width: 0.5),
                      ),
                      child: Text(t.fechaFormateada,
                          style: const TextStyle(
                              fontSize: 9, fontWeight: FontWeight.w500,
                              color: AppColors.primaryDark)),
                    ),
                  const SizedBox(height: 4),
                  const Icon(Icons.chevron_right_rounded,
                      size: 16, color: AppColors.fieldBorder),
                ],
              ),
            ),
          ]),
        ),
      ),
    );
  }
}