// lib/dashboard_screen.dart
// ─────────────────────────────────────────────────────────────────────────────
// REEMPLAZA COMPLETAMENTE el dashboard_screen.dart existente.
//
// Cambios respecto al original:
//   1. Import de SolicitudesScreen agregado.
//   2. onTap de 'Solicitudes' ahora navega a SolicitudesScreen.
//   3. Todo lo demás (visual, métricas, países, logout) queda idéntico.
// ─────────────────────────────────────────────────────────────────────────────

import 'package:flutter/material.dart';
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

// ─── Pantalla de solicitudes (nueva) ─────────────────────────────────────────
import 'package:mobile/screens/widgets/solicitudes/solicitudes_screen.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  // ── Logout ────────────────────────────────────────────────────────────────
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

  // ── Items del grid de acceso rápido ───────────────────────────────────────
  List<DashboardItem> _quickItems(BuildContext context) => [
        DashboardItem(
          title:      'Solicitudes',
          subtitle:   'Pendientes',
          icon:       Icons.mail_outline_rounded,
          badgeCount: 12,
          // ─── CONECTADO: navega a la lista real ───────────────────────────
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const SolicitudesScreen(),
            ),
          ),
        ),
        DashboardItem(
          title:    'Noticias',
          subtitle: '58 activas',
          icon:     Icons.article_outlined,
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const NewsScreen()),
          ),
        ),
        DashboardItem(
          title:    'Testimonios',
          subtitle: '34 publicados',
          icon:     Icons.star_border_rounded,
          onTap:    () {}, // se conectará en la siguiente fase
        ),
        DashboardItem(
          title:    'Países',
          subtitle: '3 portales',
          icon:     Icons.map_outlined,
          onTap:    () {}, // Fase 5
        ),
      ];

  // ── Datos estáticos del dashboard ─────────────────────────────────────────
  static const List<CountryData> _countries = [
    CountryData(
      flag:        '🇨🇴',
      name:        'Colombia',
      code:        'CO',
      pending:     6,
      news:        28,
      accentColor: AppColors.countryBorderCo,
    ),
    CountryData(
      flag:        '🇨🇱',
      name:        'Chile',
      code:        'CL',
      pending:     3,
      news:        17,
      accentColor: AppColors.countryBorderCl,
    ),
    CountryData(
      flag:        '🇪🇨',
      name:        'Ecuador',
      code:        'EC',
      pending:     3,
      news:        13,
      accentColor: AppColors.countryBorderEc,
    ),
  ];

  static const List<ActivityEntry> _activity = [
    ActivityEntry(
      text: 'Nueva solicitud de Juan Rodríguez · 🇨🇴',
      time: '5 min',
      type: ActivityType.pending,
    ),
    ActivityEntry(
      text: 'Noticia publicada "Edifica 2026" · 🇨🇴',
      time: '1 h',
      type: ActivityType.published,
    ),
    ActivityEntry(
      text: 'Testimonio aprobado · Claudia H. · 🇨🇱',
      time: '2 h',
      type: ActivityType.testimonial,
    ),
    ActivityEntry(
      text: 'Nueva solicitud de Ana Morales · 🇪🇨',
      time: '3 h',
      type: ActivityType.pending,
    ),
  ];

  // ── Build ─────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      body: Column(
        children: [
          const DashboardHeader(
            userRole: 'Superadmin',
            country:  'Global',
          ),
          Expanded(child: _buildScrollContent(context)),
        ],
      ),
    );
  }

  Widget _buildScrollContent(BuildContext context) {
    final items = _quickItems(context);
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
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
          ..._countries.map((c) => CountryCard(data: c)),
          const SizedBox(height: 8),

          _sectionLabel('Actividad reciente'),
          const SizedBox(height: 10),
          const ActivityFeed(entries: _activity),
          const SizedBox(height: 18),

          _buildLogoutButton(context),
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
            fontSize:    10,
            fontWeight:  FontWeight.w500,
            color:       AppColors.primary,
            letterSpacing: 1,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Container(height: 0.5, color: AppColors.fieldBorder),
        ),
      ],
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
        MetricTile(
          icon:  Icons.mail_outline_rounded,
          value: '12',
          label: 'Solicitudes pendientes',
          dark:  true,
        ),
        MetricTile(
          icon:  Icons.star_border_rounded,
          value: '34',
          label: 'Testimonios publicados',
        ),
        MetricTile(
          icon:  Icons.article_outlined,
          value: '58',
          label: 'Noticias activas',
        ),
        MetricTile(
          icon:  Icons.language_rounded,
          value: '3',
          label: 'Portales activos',
          dark:  true,
        ),
      ],
    );
  }

  Widget _buildQuickGrid(List<DashboardItem> items) {
    return GridView.builder(
      itemCount: items.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount:  2,
        crossAxisSpacing: 10,
        mainAxisSpacing:  10,
        childAspectRatio: 1.1,
      ),
      itemBuilder: (_, i) => DashboardCard(item: items[i]),
    );
  }

  Widget _buildLogoutButton(BuildContext context) {
    return SizedBox(
      width:  double.infinity,
      height: 52,
      child: OutlinedButton.icon(
        onPressed: () => _logout(context),
        icon: const Icon(
          Icons.logout_rounded,
          size:  18,
          color: AppColors.primary,
        ),
        label: const Text(
          'Cerrar sesión',
          style: TextStyle(
            fontSize:   14,
            fontWeight: FontWeight.w500,
            color:      AppColors.primary,
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