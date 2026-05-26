import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:mobile/country_home_screen.dart';
import 'package:mobile/mantenimiento_screen.dart';
import 'package:mobile/services/paises_services.dart';
import 'package:mobile/constants/app_colors.dart';


class HomeHero extends StatefulWidget {
  const HomeHero({super.key});

  @override
  State<HomeHero> createState() => _HomeHeroState();
}

class _HomeHeroState extends State<HomeHero> {
  static const _paises = [
    {'imagen': 'assets/images/logo_colombia.png',  'nombre': 'Colombia',      'ruta': 'colombia'},
    {'imagen': 'assets/images/logo_ecuador.png',   'nombre': 'Ecuador',       'ruta': 'ecuador'},
    {'imagen': 'assets/images/logo_latam.png',     'nombre': 'Latinoamérica', 'ruta': null},
    {'imagen': 'assets/images/logo_chile.png',     'nombre': 'Chile',         'ruta': 'chile'},
    {'imagen': 'assets/images/logo_argentina.png', 'nombre': 'Argentina',     'ruta': 'argentina'},
  ];

  final Set<String> _navegando = {}; // rutas con petición en curso

  // Valida el estado del país antes de navegar
  Future<void> _irAPortal(BuildContext context, String ruta) async {
    if (_navegando.contains(ruta)) return;
    setState(() => _navegando.add(ruta));

    try {
      final paises = await PaisesService().getPaises();
      final match = paises.where(
        (p) => p.nombre.toLowerCase() == ruta.toLowerCase(),
      ).toList();

      if (!mounted) return;

      // Si no se encontró o está inactivo → pantalla de mantenimiento
      final activo = match.isNotEmpty && match.first.estaActivo;

      if (activo) {
        Navigator.push(context,
          MaterialPageRoute(builder: (_) => CountryHomeScreen(pais: ruta)));
      } else {
        Navigator.push(context,
          MaterialPageRoute(builder: (_) => const MantenimientoScreen()));
      }
    } catch (_) {
      if (!mounted) return;
      // Si falla la red, deja pasar (fail-open)
      Navigator.push(context,
        MaterialPageRoute(builder: (_) => CountryHomeScreen(pais: ruta)));
    } finally {
      if (mounted) setState(() => _navegando.remove(ruta));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 24),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.heroTop,
            AppColors.heroMid1,
            AppColors.heroMid2,
            AppColors.heroBottom,
          ],
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: _paises.map((p) {
              final ruta   = p['ruta'] as String?;
              final grande = p['nombre'] == 'Latinoamérica';
              return _PaisCircle(
                imagen:    p['imagen']! as String,
                nombre:    p['nombre']! as String,
                grande:    grande,
                cargando:  ruta != null && _navegando.contains(ruta),
                onTap:     ruta != null
                    ? () => _irAPortal(context, ruta)
                    : null,
              );
            }).toList(),
          ),
          const SizedBox(height: 28),
          const Text(
            'Una red que une personas, empresas y comunidades, para construir una región más humana, productiva y consciente.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.heroText,
              fontSize: 15,
              height: 1.6,
              fontWeight: FontWeight.w300,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Icon(Icons.touch_app_outlined, color: AppColors.heroSubText, size: 14),
              SizedBox(width: 6),
              Text(
                'Toca un logo para explorar cada país',
                style: TextStyle(color: AppColors.heroSubText, fontSize: 11),
              ),
            ],
          ),
          const SizedBox(height: 20),
          OutlinedButton(
            onPressed: () => launchUrl(
              Uri.parse('https://www.instagram.com/latinoamericacomparte/'),
              mode: LaunchMode.externalApplication,
            ),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.heroText,
              side: const BorderSide(color: AppColors.heroSubText, width: 1.2),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
            ),
            child: const Text(
              'Conoce más',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }
}

class _PaisCircle extends StatelessWidget {
  final String        imagen;
  final String        nombre;
  final bool          grande;
  final bool          cargando;
  final VoidCallback? onTap;

  const _PaisCircle({
    required this.imagen,
    required this.nombre,
    this.grande   = false,
    this.cargando = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final size     = grande ? 72.0 : 58.0;
    final tappable = onTap != null;

    return Column(
      children: [
        GestureDetector(
          onTap: cargando ? null : onTap,
          child: Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.background,
              boxShadow: [
                BoxShadow(
                  color: AppColors.primaryDark.withOpacity(0.25),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Stack(
              children: [
                ClipOval(
                  child: Padding(
                    padding: const EdgeInsets.all(6),
                    child: Image.asset(
                      imagen,
                      width: size,
                      height: size,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                if (cargando)
                  Positioned.fill(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.25),
                        shape: BoxShape.circle,
                      ),
                      child: const Center(
                        child: SizedBox(
                          width: 22, height: 22,
                          child: CircularProgressIndicator(
                            strokeWidth: 2, color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                if (tappable && !cargando)
                  Positioned(
                    right: 2,
                    bottom: 2,
                    child: Container(
                      width: 14,
                      height: 14,
                      decoration: const BoxDecoration(
                        color: AppColors.activityPubIcon, // verde
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.arrow_forward, size: 9, color: AppColors.heroText),
                    ),
                  ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          nombre,
          style: TextStyle(
            color: tappable ? AppColors.heroText : AppColors.heroSubText,
            fontSize: 9,
            fontWeight: tappable ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
        if (tappable)
          const Text(
            'Ver portal',
            style: TextStyle(color: AppColors.heroSubText, fontSize: 8),
          ),
      ],
    );
  }
}