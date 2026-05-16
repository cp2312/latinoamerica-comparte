import 'package:flutter/material.dart';
import 'package:mobile/login_screen.dart';
import 'package:mobile/services/news_service.dart';
import 'package:mobile/screens/models/news_model.dart';
import 'package:mobile/screens/widgets/home/home_hero.dart';
import 'package:mobile/screens/widgets/home/home_news_card.dart';
import 'package:mobile/screens/widgets/home/home_section_title.dart';
import 'package:mobile/screens/widgets/home/home_testimonial_card.dart';
import 'package:mobile/screens/widgets/home/home_contact_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F0FA),
      appBar: AppBar(
        backgroundColor: const Color(0xFF6A0080),
        elevation: 0,
        title: Row(
          children: [
            Image.asset('assets/images/logo_latam1.png', height: 32, fit: BoxFit.contain),
            const SizedBox(width: 10),
            const Text(
              'Latinoamérica Comparte',
              style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w600),
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: TextButton.icon(
              onPressed: () => Navigator.push(
                context, MaterialPageRoute(builder: (_) => const LoginScreen())),
              icon: const Icon(Icons.lock_outline, color: Colors.white, size: 18),
              label: const Text('Iniciar sesión', style: TextStyle(color: Colors.white, fontSize: 13)),
              style: TextButton.styleFrom(
                backgroundColor: Colors.white.withOpacity(0.15),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const HomeHero(),
            const SizedBox(height: 32),
            const _QuienesSomosSection(),
            const SizedBox(height: 32),
            const _ImpactoSection(),
            const SizedBox(height: 32),
            const HomeSectionTitle(titulo: 'Últimas noticias', icono: Icons.article_outlined),
            const SizedBox(height: 12),
            _NewsSection(),
            const SizedBox(height: 32),
            const HomeSectionTitle(titulo: 'Testimonios de éxito', icono: Icons.format_quote_rounded),
            const SizedBox(height: 12),
            _TestimonialsSection(),
            const SizedBox(height: 32),
            const _EquipoSection(),
            const SizedBox(height: 32),
            const HomeSectionTitle(titulo: 'Contáctanos', icono: Icons.mail_outline),
            const SizedBox(height: 12),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: HomeContactCard(),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// QUIÉNES SOMOS
// ═══════════════════════════════════════════════════════════════════════════════

class _QuienesSomosSection extends StatelessWidget {
  const _QuienesSomosSection();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const HomeSectionTitle(titulo: 'Quiénes somos', icono: Icons.info_outline),
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 16, offset: const Offset(0, 4)),
              ],
            ),
            child: Column(
              children: [
                Image.asset('assets/images/logo_latam.png', height: 70, fit: BoxFit.contain),
                const SizedBox(height: 20),
                const Text(
                  'En Latinoamérica Comparte creemos que transformar personas es transformar empresas.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF2E2E2E), height: 1.4),
                ),
                const SizedBox(height: 14),
                const Text(
                  'Nacimos de una historia real de pérdida, fe y propósito.\n\nLo que comenzó en Colombia como un movimiento para ayudar a familias a reconstruir su productividad, hoy se ha convertido en una red continental que promueve el bienestar, la cultura organizacional y el emprendimiento con propósito.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 13, color: Colors.black54, height: 1.7),
                ),
                const SizedBox(height: 14),
                const Text(
                  'En cada país acompañamos a personas, familias y empresas a reencontrar su propósito productivo y a construir un futuro sostenible. Porque cuando un país comparte, Latinoamérica avanza.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 13, color: Colors.black54, height: 1.7),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _LogoPais('assets/images/logo_colombia.png', 'Colombia'),
                    _LogoPais('assets/images/logo_ecuador.png', 'Ecuador'),
                    _LogoPais('assets/images/logo_chile.png', 'Chile'),
                    _LogoPais('assets/images/logo_argentina.png', 'Argentina'),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _LogoPais extends StatelessWidget {
  final String asset;
  final String nombre;
  const _LogoPais(this.asset, this.nombre);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Image.asset(asset, height: 44, width: 44, fit: BoxFit.contain),
        const SizedBox(height: 4),
        Text(nombre, style: const TextStyle(fontSize: 9, color: Colors.black45)),
      ],
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// NUESTRO IMPACTO + EMPRESAS ALIADAS (carrusel)
// ═══════════════════════════════════════════════════════════════════════════════

class _ImpactoSection extends StatelessWidget {
  const _ImpactoSection();

  static const _cifras = [
    {'numero': '10+',    'label': 'Años de impacto\nsocial y empresarial', 'icono': Icons.calendar_today_outlined},
    {'numero': '5.000+', 'label': 'Familias\ntransformadas',               'icono': Icons.family_restroom_outlined},
    {'numero': '2.000+', 'label': 'Emprendimientos\ncreados',               'icono': Icons.storefront_outlined},
    {'numero': '50+',    'label': 'Empresas\naliadas',                      'icono': Icons.business_outlined},
  ];

  // Logo URL → nombre para mostrar debajo si la imagen falla
  static const _empresas = [
    {'asset': 'assets/images/empresas/alpina.png',       'nombre': 'Alpina'},
    {'asset': 'assets/images/empresas/amcor.png',        'nombre': 'AMCOR'},
    {'asset': 'assets/images/empresas/boehringer.png',   'nombre': 'Boehringer'},
    {'asset': 'assets/images/empresas/brinks.png',       'nombre': 'Brinks'},
    {'asset': 'assets/images/empresas/cencosud.png',     'nombre': 'Cencosud'},
    {'asset': 'assets/images/empresas/grupo_exito.png',  'nombre': 'Grupo Éxito'},
    {'asset': 'assets/images/empresas/grupo_nutresa.png','nombre': 'Grupo Nutresa'},
    {'asset': 'assets/images/empresas/sodimac.png',      'nombre': 'Sodimac'},
    {'asset': 'assets/images/empresas/jm_tracking.png',  'nombre': 'JM Tracking'},
    {'asset': 'assets/images/empresas/soenergy.png',     'nombre': 'SoEnergy'},
    {'asset': 'assets/images/empresas/olimpia_it.png',   'nombre': 'Olimpia IT'},
    {'asset': 'assets/images/empresas/sanfer.png',       'nombre': 'Sanfer'},
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const HomeSectionTitle(titulo: 'Nuestro impacto', icono: Icons.bar_chart_outlined),
        const SizedBox(height: 16),

        // ── Cifras ────────────────────────────────────────────────────────
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.6,
            children: _cifras.map((c) => _CifraCard(
              numero: c['numero']! as String,
              label:  c['label']!  as String,
              icono:  c['icono']!  as IconData,
            )).toList(),
          ),
        ),

        const SizedBox(height: 28),

        // ── Empresas que comparten — carrusel ─────────────────────────────
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Empresas que comparten',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF2E2E2E)),
              ),
              const SizedBox(height: 6),
              const Text(
                'Las empresas que creen en el bienestar y la productividad con propósito hacen parte de esta red. Gracias a ellas, más familias en Latinoamérica vuelven a creer, crear y prosperar.',
                style: TextStyle(fontSize: 12, color: Colors.black45, height: 1.5),
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        // Carrusel horizontal de logos
        SizedBox(
          height: 110,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: _empresas.length,
            itemBuilder: (context, index) {
              final e = _empresas[index];
              return _EmpresaCard(
                asset:  e['asset']!,
                nombre: e['nombre']!,
              );
            },
          ),
        ),
      ],
    );
  }
}

class _EmpresaCard extends StatelessWidget {
  final String asset;
  final String nombre;
  const _EmpresaCard({required this.asset, required this.nombre});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 120,
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.07),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Image.asset(
              asset,
              fit: BoxFit.contain,
              errorBuilder: (_, __, ___) => Text(
                nombre,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: Color(0xFF6A0080)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CifraCard extends StatelessWidget {
  final String   numero;
  final String   label;
  final IconData icono;
  const _CifraCard({required this.numero, required this.label, required this.icono});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF6A0080), Color(0xFF9C27B0)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: const Color(0xFF6A0080).withOpacity(0.3), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icono, color: Colors.white70, size: 20),
          const SizedBox(height: 6),
          Text(numero, style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
          const SizedBox(height: 2),
          Text(label, style: const TextStyle(color: Colors.white70, fontSize: 10, height: 1.3)),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// NUESTRO EQUIPO
// ═══════════════════════════════════════════════════════════════════════════════

class _EquipoSection extends StatelessWidget {
  const _EquipoSection();

  static const _equipo = [
    {'nombre': 'Carolina Ruiz',        'cargo': 'Cofundadora y CEO'},
    {'nombre': 'Eduardo Del Castillo', 'cargo': 'Cofundador y VP Comercial'},
    {'nombre': 'Marcela Moreno',       'cargo': 'Directora de Relacionamiento'},
    {'nombre': 'Angie Castañeda',      'cargo': 'Coordinadora Académica Edifica'},
    {'nombre': 'Mariana Gomez',        'cargo': 'Directora de Mercadeo'},
    {'nombre': 'Nancy Vivas',          'cargo': 'Directora de Comunicación Digital'},
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const HomeSectionTitle(titulo: 'Nuestro equipo', icono: Icons.people_outline),
        const SizedBox(height: 8),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            'El corazón de Latinoamérica Comparte está en las personas que día a día trabajan por transformar vidas.',
            style: TextStyle(fontSize: 13, color: Colors.black45, height: 1.5),
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 160,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: _equipo.length,
            itemBuilder: (context, index) {
              final p = _equipo[index];
              return _IntegranteCard(nombre: p['nombre']!, cargo: p['cargo']!);
            },
          ),
        ),
      ],
    );
  }
}

class _IntegranteCard extends StatelessWidget {
  final String nombre;
  final String cargo;
  const _IntegranteCard({required this.nombre, required this.cargo});

  String get _iniciales {
    final partes = nombre.trim().split(' ');
    if (partes.length >= 2) return '${partes[0][0]}${partes[1][0]}';
    return partes[0][0];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 130,
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 12, offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [Color(0xFF6A0080), Color(0xFF9C27B0)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Center(
              child: Text(
                _iniciales,
                style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            nombre,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF2E2E2E), height: 1.3),
          ),
          const SizedBox(height: 4),
          Text(
            cargo,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 10, color: Colors.black45, height: 1.3),
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// NOTICIAS
// ═══════════════════════════════════════════════════════════════════════════════

class _NewsSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<NewsModel>>(
      future: NewsService().getPublicNews(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(32),
              child: CircularProgressIndicator(color: Color(0xFF6A0080)),
            ),
          );
        }
        if (snapshot.hasError || snapshot.data == null) {
          return const _EmptyState(mensaje: 'No se pudieron cargar las noticias');
        }
        final noticias = snapshot.data!;
        if (noticias.isEmpty) {
          return const _EmptyState(mensaje: 'No hay noticias publicadas aún');
        }
        return SizedBox(
          height: 220,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: noticias.length,
            itemBuilder: (context, index) => HomeNewsCard(noticia: noticias[index]),
          ),
        );
      },
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// TESTIMONIOS
// ═══════════════════════════════════════════════════════════════════════════════

class _TestimonialsSection extends StatelessWidget {
  static const _testimonios = [
    {'nombre': 'María González', 'pais': 'Colombia', 'texto': 'Gracias al programa Edifica pude emprender mi negocio y recuperar la estabilidad de mi familia.'},
    {'nombre': 'Carlos Rojas',   'pais': 'Chile',    'texto': 'El programa Nodus me dio las herramientas para liderar mi empresa con visión y propósito.'},
    {'nombre': 'Ana Torres',     'pais': 'Ecuador',  'texto': 'No imaginé que en tan poco tiempo lograría estabilizar mis ingresos. Latinoamérica Comparte cambió mi vida.'},
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 190,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: _testimonios.length,
        itemBuilder: (context, index) {
          final t = _testimonios[index];
          return HomeTestimonialCard(nombre: t['nombre']!, pais: t['pais']!, texto: t['texto']!);
        },
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// EMPTY STATE
// ═══════════════════════════════════════════════════════════════════════════════

class _EmptyState extends StatelessWidget {
  final String mensaje;
  const _EmptyState({required this.mensaje});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Text(mensaje, style: const TextStyle(color: Colors.black45, fontSize: 13)),
    );
  }
}