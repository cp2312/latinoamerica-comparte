import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mobile/login_screen.dart';
import 'package:mobile/news_screen.dart';
import 'package:mobile/screens/models/dashboard_item.dart';
import 'package:mobile/screens/models/user_model.dart';
import 'package:mobile/screens/widgets/dashboard_admin_pais_screen/dashboard_admin_card.dart';
import 'package:mobile/screens/widgets/dashboard_admin_pais_screen/dashboard_admin_header.dart';

class DashboardAdminPaisScreen extends StatelessWidget {
  final UserModel usuario;

  const DashboardAdminPaisScreen({super.key, required this.usuario});

  // ── Logout ──────────────────────────────────────────────────────────────────

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

  // ── Items del grid según rol ─────────────────────────────────────────────────

  List<DashboardItem> _dashboardItems(BuildContext context) {
    final pais = usuario.paisDisplay;

    final items = <DashboardItem>[
      DashboardItem(
        title:    'Noticias',
        subtitle: 'Gestiona noticias de $pais',
        icon:     Icons.article_outlined,
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const NewsScreen()),
        ),
      ),
      DashboardItem(
        title:    'Testimonios',
        subtitle: 'Testimonios de $pais',
        icon:     Icons.record_voice_over_outlined,
        onTap:    () {}, // TODO: Fase 3
      ),
      DashboardItem(
        title:    'Solicitudes',
        subtitle: 'Formularios de $pais',
        icon:     Icons.mail_outline,
        onTap:    () {}, // TODO: Fase 4
      ),
    ];

    // El editor NO ve gestión de perfil/usuarios
    if (!usuario.esEditor) {
      items.add(
        DashboardItem(
          title:    'Mi Perfil',
          subtitle: 'Ver mi cuenta',
          icon:     Icons.manage_accounts_outlined,
          onTap:    () {}, // TODO: Fase 5
        ),
      );
    }

    return items;
  }

  // ── Build ────────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final items = _dashboardItems(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),

      appBar: AppBar(
        title: Text('${usuario.bandera} Portal ${usuario.paisDisplay}'),
        centerTitle: true,
        elevation: 0,
      ),

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              // ── Header con nombre, rol y país ───────────────────────────
              DashboardAdminHeader(
                nombre:  usuario.nombre,
                rol:     usuario.rolDisplay,
                pais:    usuario.paisDisplay,
                bandera: usuario.bandera,
              ),

              const SizedBox(height: 24),

              // ── Grid de módulos ──────────────────────────────────────────
              Expanded(
                child: GridView.builder(
                  itemCount: items.length,
                  gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount:  2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing:  16,
                    childAspectRatio: 1.05,
                  ),
                  itemBuilder: (context, index) {
                    return DashboardAdminCard(item: items[index]);
                  },
                ),
              ),

              const SizedBox(height: 8),

              // ── Botón cerrar sesión ──────────────────────────────────────
              SizedBox(
                width:  double.infinity,
                height: 54,
                child: ElevatedButton.icon(
                  onPressed: () => _logout(context),
                  icon:  const Icon(Icons.logout),
                  label: const Text(
                    'Cerrar sesión',
                    style: TextStyle(
                      fontSize:   16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}