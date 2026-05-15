import 'package:flutter/material.dart';
import 'package:mobile/login_screen.dart';
import 'package:mobile/services/news_service.dart';
import 'package:mobile/screens/models/news_model.dart';
import 'package:mobile/screens/widgets/home/home_news_card.dart';
import 'package:mobile/screens/widgets/home/home_section_title.dart';
import 'package:mobile/screens/widgets/home/home_testimonial_card.dart';
import 'package:mobile/screens/widgets/home/home_contact_card.dart';

// ── Configuración visual por país ─────────────────────────────────────────────

class _PaisConfig {
  final String nombre;
  final String codigo;
  final String bandera;
  final List<Color> gradiente;
  final Color appBarColor;
  final Color accentColor;
  final String tagline;
  final String subtitulo;
  final String programaDestacado;
  final String descripcionPrograma;
  final IconData iconaPrograma;
  final List<Map<String, String>> testimonios;

  const _PaisConfig({
    required this.nombre,
    required this.codigo,
    required this.bandera,
    required this.gradiente,
    required this.appBarColor,
    required this.accentColor,
    required this.tagline,
    required this.subtitulo,
    required this.programaDestacado,
    required this.descripcionPrograma,
    required this.iconaPrograma,
    required this.testimonios,
  });
}

final _configs = <String, _PaisConfig>{
  // ── COLOMBIA ──────────────────────────────────────────────────────────────
  'colombia': _PaisConfig(
    nombre: 'Colombia',
    codigo: 'CO',
    bandera: '🇨🇴',
    gradiente: const [
      Color(0xFFFCD116), // amarillo bandera
      Color(0xFFCE1126), // rojo bandera
      Color(0xFF003893), // azul bandera
    ],
    appBarColor: const Color(0xFF003893),
    accentColor: const Color(0xFFCE1126),
    tagline: 'Transformando vidas en Colombia',
    subtitulo:
        'Acompañamos a familias y emprendedores colombianos para recuperar sus fuentes de ingreso con dignidad y propósito.',
    programaDestacado: 'Programa Edifica Colombia',
    descripcionPrograma:
        'Impulsamos el emprendimiento personal en ciudades como Bogotá, Medellín y Cali.',
    iconaPrograma: Icons.storefront_outlined,
    testimonios: [
      {
        'nombre': 'María González',
        'pais': 'Colombia',
        'texto':
            'Gracias al programa Edifica pude abrir mi tienda en Bogotá y recuperar la estabilidad de mi familia.',
      },
      {
        'nombre': 'Andrés Morales',
        'pais': 'Colombia',
        'texto':
            'El apoyo de Latinoamérica Comparte me ayudó a crecer mi negocio en Medellín. Hoy tengo 3 empleados.',
      },
      {
        'nombre': 'Luz Esperanza Ríos',
        'pais': 'Colombia',
        'texto':
            'Con el programa Nodus aprendí a liderar mi empresa con visión. Mis ingresos crecieron un 40% en seis meses.',
      },
    ],
  ),

  // ── CHILE ─────────────────────────────────────────────────────────────────
  'chile': _PaisConfig(
    nombre: 'Chile',
    codigo: 'CL',
    bandera: '🇨🇱',
    gradiente: const [
      Color(0xFFD52B1E), // rojo bandera
      Color(0xFFB71C1C),
      Color(0xFF1A237E), // azul bandera
    ],
    appBarColor: const Color(0xFF1A237E),
    accentColor: const Color(0xFFD52B1E),
    tagline: 'Construyendo el Chile que queremos',
    subtitulo:
        'Apoyamos a emprendedores y líderes empresariales chilenos en su camino hacia la prosperidad sostenible.',
    programaDestacado: 'Programa Nodus Chile',
    descripcionPrograma:
        'Formamos líderes empresariales en Santiago, Valparaíso y Concepción con herramientas de gestión real.',
    iconaPrograma: Icons.leaderboard_outlined,
    testimonios: [
      {
        'nombre': 'Carlos Rojas',
        'pais': 'Chile',
        'texto':
            'El programa Nodus me dio las herramientas para liderar mi empresa en Santiago con visión y propósito.',
      },
      {
        'nombre': 'Valentina Muñoz',
        'pais': 'Chile',
        'texto':
            'Gracias al acompañamiento de Latinoamérica Comparte pude escalar mi emprendimiento en Valparaíso.',
      },
      {
        'nombre': 'Diego Fuentes',
        'pais': 'Chile',
        'texto':
            'La formación empresarial que recibí cambió completamente mi forma de ver los negocios en Chile.',
      },
    ],
  ),

  // ── ARGENTINA ────────────────────────────────────────────────────────────
  'argentina': _PaisConfig(
    nombre: 'Argentina',
    codigo: 'AR',
    bandera: '🇦🇷',
    gradiente: const [
      Color(0xFF74ACDF), // celeste bandera
      Color(0xFF5B9DC9),
      Color(0xFFFFFFFF), // blanco bandera
    ],
    appBarColor: const Color(0xFF4A8DB5),
    accentColor: const Color(0xFF74ACDF),
    tagline: 'Emprendimiento con raíces argentinas',
    subtitulo:
        'Acompañamos a emprendedores y familias argentinas para reconstruir sus fuentes de ingreso con herramientas reales.',
    programaDestacado: 'Programa Edifica Argentina',
    descripcionPrograma:
        'Impulsamos emprendedores en Buenos Aires, Córdoba y Rosario con mentoría y planes de negocio personalizados.',
    iconaPrograma: Icons.emoji_people_outlined,
    testimonios: [
      {
        'nombre': 'Lucía Fernández',
        'pais': 'Argentina',
        'texto':
            'El programa Edifica me dio las herramientas para montar mi emprendimiento en Buenos Aires. Hoy tengo clientes en toda la ciudad.',
      },
      {
        'nombre': 'Martín Álvarez',
        'pais': 'Argentina',
        'texto':
            'Gracias al acompañamiento de Latinoamérica Comparte pude relanzar mi negocio en Córdoba después de la crisis.',
      },
      {
        'nombre': 'Sofía Pereyra',
        'pais': 'Argentina',
        'texto':
            'La mentoría personalizada que recibí en Rosario fue clave. En seis meses dupliqué mis ingresos.',
      },
    ],
  ),

  // ── ECUADOR ───────────────────────────────────────────────────────────────
  'ecuador': _PaisConfig(
    nombre: 'Ecuador',
    codigo: 'EC',
    bandera: '🇪🇨',
    gradiente: const [
      Color(0xFFFFD100), // amarillo bandera
      Color(0xFF006B3F), // verde bandera
      Color(0xFF003580), // azul bandera
    ],
    appBarColor: const Color(0xFF006B3F),
    accentColor: const Color(0xFF003580),
    tagline: 'El emprendimiento que mueve Ecuador',
    subtitulo:
        'Impulsamos a personas y familias ecuatorianas para que reinventen sus fuentes de ingreso con apoyo real.',
    programaDestacado: 'Programa Edifica Ecuador',
    descripcionPrograma:
        'Acompañamos emprendedores en Quito, Guayaquil y Cuenca con planes de negocio y mentorías personalizadas.',
    iconaPrograma: Icons.rocket_launch_outlined,
    testimonios: [
      {
        'nombre': 'Ana Torres',
        'pais': 'Ecuador',
        'texto':
            'No imaginé que en tan poco tiempo lograría estabilizar mis ingresos. Latinoamérica Comparte cambió mi vida en Quito.',
      },
      {
        'nombre': 'Roberto Vera',
        'pais': 'Ecuador',
        'texto':
            'Gracias al programa Edifica pude iniciar mi negocio en Guayaquil. Hoy soy mi propio jefe.',
      },
      {
        'nombre': 'Patricia Lema',
        'pais': 'Ecuador',
        'texto':
            'El acompañamiento personalizado que recibí en Cuenca fue clave para superar la crisis económica.',
      },
    ],
  ),
};

// ── Pantalla principal por país ───────────────────────────────────────────────

class CountryHomeScreen extends StatelessWidget {
  /// Recibe el nombre del país en minúsculas: 'colombia', 'chile', 'ecuador'
  final String pais;

  const CountryHomeScreen({super.key, required this.pais});

  @override
  Widget build(BuildContext context) {
    final config = _configs[pais.toLowerCase()];

    // Fallback por si llega un país no configurado
    if (config == null) {
      return Scaffold(
        appBar: AppBar(title: Text(pais)),
        body: Center(child: Text('País no encontrado: $pais')),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF5F0FA),

      // ── AppBar con color del país ──────────────────────────────────────
      appBar: AppBar(
        backgroundColor: config.appBarColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            Text(config.bandera, style: const TextStyle(fontSize: 22)),
            const SizedBox(width: 10),
            Flexible(
              child: Text(
                'Latinoamérica Comparte ${config.nombre}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: TextButton.icon(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const LoginScreen()),
              ),
              icon:
                  const Icon(Icons.lock_outline, color: Colors.white, size: 18),
              label: const Text(
                'Ingresar',
                style: TextStyle(color: Colors.white, fontSize: 13),
              ),
              style: TextButton.styleFrom(
                backgroundColor: Colors.white.withOpacity(0.15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              ),
            ),
          ),
        ],
      ),

      // ── Cuerpo ────────────────────────────────────────────────────────
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hero con gradiente del país
            _CountryHero(config: config),

            const SizedBox(height: 20),

            // Programa destacado del país
            _ProgramaCard(config: config),

            const SizedBox(height: 24),

            // Noticias filtradas por este país
            HomeSectionTitle(
              titulo: 'Noticias en ${config.nombre}',
              icono: Icons.article_outlined,
            ),
            const SizedBox(height: 12),
            _CountryNewsSection(pais: config.nombre),

            const SizedBox(height: 24),

            // Testimonios del país
            HomeSectionTitle(
              titulo: 'Historias de éxito',
              icono: Icons.format_quote_rounded,
            ),
            const SizedBox(height: 12),
            _CountryTestimonialsSection(config: config),

            const SizedBox(height: 24),

            // Contacto (pre-seleccionado el país)
            HomeSectionTitle(
              titulo: 'Contáctanos en ${config.nombre}',
              icono: Icons.mail_outline,
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: HomeContactCard(paisInicial: config.nombre),
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}

// ── Hero del país ─────────────────────────────────────────────────────────────

class _CountryHero extends StatelessWidget {
  final _PaisConfig config;
  const _CountryHero({required this.config});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 36, horizontal: 24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: config.gradiente,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Bandera grande + badge de país
          Row(
            children: [
              Text(config.bandera,
                  style: const TextStyle(fontSize: 48)),
              const SizedBox(width: 16),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                      color: Colors.white.withOpacity(0.4), width: 1),
                ),
                child: Text(
                  config.codigo,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    letterSpacing: 2,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Tagline
          Text(
            config.tagline,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
              height: 1.3,
            ),
          ),

          const SizedBox(height: 12),

          // Subtítulo
          Text(
            config.subtitulo,
            style: TextStyle(
              color: Colors.white.withOpacity(0.88),
              fontSize: 14,
              height: 1.6,
            ),
          ),

          const SizedBox(height: 20),

          OutlinedButton(
            onPressed: () {},
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.white,
              side:
                  const BorderSide(color: Colors.white54, width: 1.2),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              padding: const EdgeInsets.symmetric(
                  horizontal: 28, vertical: 10),
            ),
            child: Text(
              'Conoce ${config.nombre}',
              style: const TextStyle(
                  fontSize: 13, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Tarjeta de programa destacado ────────────────────────────────────────────

class _ProgramaCard extends StatelessWidget {
  final _PaisConfig config;
  const _ProgramaCard({required this.config});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
          border: Border.all(
            color: config.accentColor.withOpacity(0.2),
            width: 1.2,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: config.accentColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(
                config.iconaPrograma,
                color: config.accentColor,
                size: 28,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    config.programaDestacado,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: config.accentColor,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    config.descripcionPrograma,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.black54,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Sección noticias filtradas por país ───────────────────────────────────────

class _CountryNewsSection extends StatelessWidget {
  final String pais;
  const _CountryNewsSection({required this.pais});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<NewsModel>>(
      future: NewsService().getPublicNewsByCountry(pais),
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
          return _EmptyState(
              mensaje: 'No se pudieron cargar las noticias de $pais');
        }

        final noticias = snapshot.data!;
        if (noticias.isEmpty) {
          return _EmptyState(
              mensaje: 'No hay noticias publicadas en $pais aún');
        }

        return SizedBox(
          height: 220,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: noticias.length,
            itemBuilder: (context, index) {
              return HomeNewsCard(noticia: noticias[index]);
            },
          ),
        );
      },
    );
  }
}

// ── Sección testimonios del país ──────────────────────────────────────────────

class _CountryTestimonialsSection extends StatelessWidget {
  final _PaisConfig config;
  const _CountryTestimonialsSection({required this.config});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 190,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: config.testimonios.length,
        itemBuilder: (context, index) {
          final t = config.testimonios[index];
          return HomeTestimonialCard(
            nombre: t['nombre']!,
            pais: t['pais']!,
            texto: t['texto']!,
          );
        },
      ),
    );
  }
}

// ── Empty state ───────────────────────────────────────────────────────────────

class _EmptyState extends StatelessWidget {
  final String mensaje;
  const _EmptyState({required this.mensaje});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child:
          Text(mensaje, style: const TextStyle(color: Colors.black45, fontSize: 13)),
    );
  }
}