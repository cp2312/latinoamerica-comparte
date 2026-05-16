import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:mobile/country_home_screen.dart';

class HomeHero extends StatelessWidget {
  const HomeHero({super.key});

  static const _paises = [
    {'imagen': 'assets/images/logo_colombia.png',  'nombre': 'Colombia',      'ruta': 'colombia'},
    {'imagen': 'assets/images/logo_ecuador.png',   'nombre': 'Ecuador',       'ruta': 'ecuador'},
    {'imagen': 'assets/images/logo_latam.png',     'nombre': 'Latinoamérica', 'ruta': null},
    {'imagen': 'assets/images/logo_chile.png',     'nombre': 'Chile',         'ruta': 'chile'},
    {'imagen': 'assets/images/logo_argentina.png', 'nombre': 'Argentina',     'ruta': 'argentina'},
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 24),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF6A0080), Color(0xFF9C27B0), Color(0xFF7B1FA2)],
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
                imagen: p['imagen']! as String,
                nombre: p['nombre']! as String,
                grande: grande,
                onTap: ruta != null
                    ? () => Navigator.push(context,
                          MaterialPageRoute(builder: (_) => CountryHomeScreen(pais: ruta)))
                    : null,
              );
            }).toList(),
          ),
          const SizedBox(height: 28),
          const Text(
            'Una red que une personas, empresas y comunidades, para construir una región más humana, productiva y consciente.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white, fontSize: 15, height: 1.6, fontWeight: FontWeight.w300),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Icon(Icons.touch_app_outlined, color: Colors.white54, size: 14),
              SizedBox(width: 6),
              Text('Toca un logo para explorar cada país',
                  style: TextStyle(color: Colors.white54, fontSize: 11)),
            ],
          ),
          const SizedBox(height: 20),
          OutlinedButton(
            onPressed: () => launchUrl(
              Uri.parse('https://www.instagram.com/latinoamericacomparte/'),
              mode: LaunchMode.externalApplication,
            ),
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.white,
              side: const BorderSide(color: Colors.white54, width: 1.2),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
            ),
            child: const Text('Conoce más',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
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
  final VoidCallback? onTap;

  const _PaisCircle({
    required this.imagen,
    required this.nombre,
    this.grande = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final size     = grande ? 72.0 : 58.0;
    final tappable = onTap != null;

    return Column(
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.15),
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
                if (tappable)
                  Positioned(
                    right: 2,
                    bottom: 2,
                    child: Container(
                      width: 14,
                      height: 14,
                      decoration: const BoxDecoration(
                        color: Color(0xFF4CAF50),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.arrow_forward, size: 9, color: Colors.white),
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
            color: tappable ? Colors.white : Colors.white54,
            fontSize: 9,
            fontWeight: tappable ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
        if (tappable)
          const Text('Ver portal',
              style: TextStyle(color: Colors.white38, fontSize: 8)),
      ],
    );
  }
}