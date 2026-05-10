import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mobile/login_screen.dart';
import 'package:mobile/news_screen.dart';
import 'package:mobile/screens/models/dashboard_item.dart';
import 'package:mobile/screens/widgets/dashboard_screen/dashboard_card.dart';
import 'package:mobile/screens/widgets/dashboard_screen/dashboard_header.dart';



class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  Future<void> _logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');

    if (!context.mounted) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => const LoginScreen(),
      ),
    );
  }

  List<DashboardItem> _dashboardItems(BuildContext context) {
    return [
      DashboardItem(
        title: 'Noticias',
        subtitle: 'Gestiona noticias del CMS',
        icon: Icons.article_outlined,
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const NewsScreen(),
            ),
          );
        },
      ),

      DashboardItem(
        title: 'Testimonios',
        subtitle: 'Administrar testimonios',
        icon: Icons.record_voice_over_outlined,
        onTap: () {},
      ),

      DashboardItem(
        title: 'Solicitudes',
        subtitle: 'Revisar formularios',
        icon: Icons.mail_outline,
        onTap: () {},
      ),

      DashboardItem(
        title: 'Usuarios',
        subtitle: 'Control de usuarios',
        icon: Icons.people_outline,
        onTap: () {},
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final items = _dashboardItems(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),

      appBar: AppBar(
        title: const Text('Dashboard CMS'),
        centerTitle: true,
        elevation: 0,
      ),

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const DashboardHeader(
                userRole: 'Superadmin',
                country: 'Global',
              ),

              const SizedBox(height: 24),

              Expanded(
                child: GridView.builder(
                  itemCount: items.length,
                  gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 1.05,
                  ),
                  itemBuilder: (context, index) {
                    return DashboardCard(
                      item: items[index],
                    );
                  },
                ),
              ),

              const SizedBox(height: 8),

              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton.icon(
                  onPressed: () => _logout(context),
                  icon: const Icon(Icons.logout),
                  label: const Text(
                    'Cerrar sesión',
                    style: TextStyle(
                      fontSize: 16,
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