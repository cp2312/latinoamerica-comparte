import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mobile/constants/app_colors.dart';
import 'package:mobile/screens/models/news_model.dart';
import 'package:mobile/screens/widgets/news/create_news_screen.dart';
import 'package:mobile/screens/widgets/news/news_card.dart';
import 'package:mobile/services/news_service.dart';

class NewsScreen extends StatefulWidget {
  const NewsScreen({super.key});

  @override
  State<NewsScreen> createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  late Future<List<NewsModel>> newsFuture;

  String _search = '';
  String _filterStatus = 'todas';

  String userRole = '';
  String userCountry = '';

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  // ─────────────────────────────────────────────
  // INIT
  // ─────────────────────────────────────────────
  Future<void> _initialize() async {
    final prefs = await SharedPreferences.getInstance();
    userRole = prefs.getString('user_rol') ?? '';
    userCountry = prefs.getString('user_pais') ?? '';
    _loadNews();
    if (mounted) setState(() {});
  }

  // ─────────────────────────────────────────────
  // NOTICIAS
  // ─────────────────────────────────────────────
  void _loadNews() {
    final isAdminPais = userRole == 'admin_pais' || userRole == 'editor';
    newsFuture = isAdminPais
        ? NewsService().getNews(country: userCountry)
        : NewsService().getNews();
  }

  Future<void> _refreshNews() async {
    setState(() => _loadNews());
  }

  Future<void> _goToCreate() async {
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (_) => const CreateNewsScreen()),
    );
    if (result == true) _refreshNews();
  }

  // ─────────────────────────────────────────────
  // FILTROS
  // ─────────────────────────────────────────────
  List<NewsModel> _applyFilters(List<NewsModel> list) {
    return list.where((n) {
      final matchSearch = n.title.toLowerCase().contains(_search.toLowerCase());
      final matchStatus =
          _filterStatus == 'todas' || n.status.toLowerCase() == _filterStatus;
      return matchSearch && matchStatus;
    }).toList();
  }

  // ─────────────────────────────────────────────
  // BUILD
  // ─────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      body: Column(
        children: [
          _buildTopbar(context),
          Expanded(
            child: FutureBuilder<List<NewsModel>>(
              future: newsFuture,
              builder: _buildBody,
            ),
          ),
        ],
      ),
      floatingActionButton: _buildFab(),
    );
  }

  // ─────────────────────────────────────────────
  // TOPBAR — estilo NewsFormHero
  // ─────────────────────────────────────────────
  Widget _buildTopbar(BuildContext context) {
    final top = MediaQuery.of(context).padding.top;
    final isAdminPais = userRole == 'admin_pais' || userRole == 'editor';

    return Container(
      color: AppColors.heroBottom,
      padding: EdgeInsets.fromLTRB(18, top + 14, 18, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Status bar simulado ──
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(),
              Row(
                children: [
                  Icon(
                    Icons.wifi,
                    size: 13,
                    color: Colors.white.withOpacity(0.70),
                  ),
                  const SizedBox(width: 4),
                  Icon(
                    Icons.battery_full_rounded,
                    size: 13,
                    color: Colors.white.withOpacity(0.70),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 10),

          // ── Botón volver + título de pantalla ──
          Row(
            children: [
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  width: 34,
                  height: 34,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(0.15),
                  ),
                  child: const Icon(
                    Icons.arrow_back_ios_new_rounded,
                    color: Colors.white,
                    size: 16,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                isAdminPais ? 'Noticias · $userCountry' : 'Todas las Noticias',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // ── Título grande + subtítulo ──
          const Text(
            'Gestión de Noticias',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w500,
              letterSpacing: -0.3,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Administra el contenido de tu país',
            style: TextStyle(
              color: Colors.white.withOpacity(0.60),
              fontSize: 11,
            ),
          ),
          const SizedBox(height: 16),

          // ── Buscador con glassmorphism ──
          Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: Colors.white.withOpacity(0.25),
                width: 0.5,
              ),
            ),
            child: TextField(
              onChanged: (v) => setState(() => _search = v),
              style: const TextStyle(color: Colors.white, fontSize: 13),
              decoration: InputDecoration(
                hintText: 'Buscar noticia…',
                hintStyle: TextStyle(
                  color: Colors.white.withOpacity(0.55),
                  fontSize: 13,
                ),
                prefixIcon: Icon(
                  Icons.search_rounded,
                  color: Colors.white.withOpacity(0.55),
                  size: 20,
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(vertical: 11),
              ),
            ),
          ),
          const SizedBox(height: 12),

          // ── Filtros ──
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _filterChip('Todas', 'todas'),
                _filterChip('Publicadas', 'publicado'),
                _filterChip('Borradores', 'borrador'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────
  // CHIP FILTRO
  // ─────────────────────────────────────────────
  Widget _filterChip(String label, String value) {
    final isOn = _filterStatus == value;
    return GestureDetector(
      onTap: () => setState(() => _filterStatus = value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: isOn ? Colors.white : Colors.white.withOpacity(0.15),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isOn ? Colors.white : Colors.white.withOpacity(0.3),
            width: 0.5,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w500,
            color: isOn ? AppColors.heroBottom : Colors.white,
          ),
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────
  // BODY
  // ─────────────────────────────────────────────
  Widget _buildBody(
    BuildContext context,
    AsyncSnapshot<List<NewsModel>> snapshot,
  ) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.primary),
      );
    }

    if (snapshot.hasError) {
      return Center(
        child: Text(
          snapshot.error.toString(),
          style: const TextStyle(color: AppColors.fieldLabel),
        ),
      );
    }

    final all = snapshot.data ?? [];
    final filtered = _applyFilters(all);

    // ── Resumen de conteos ──
    final totalPub = all
        .where((n) => n.status.toLowerCase() == 'publicado')
        .length;
    final totalDraft = all
        .where((n) => n.status.toLowerCase() == 'borrador')
        .length;

    if (filtered.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.article_outlined,
              size: 48,
              color: AppColors.primary.withOpacity(0.3),
            ),
            const SizedBox(height: 12),
            const Text(
              'No hay noticias',
              style: TextStyle(color: AppColors.fieldLabel, fontSize: 14),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _refreshNews,
      color: AppColors.primary,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 90),
        children: [
          // ── Chips de resumen ──
          Row(
            children: [
              _statChip(
                label: 'Publicadas',
                count: totalPub,
                color: const Color(0xFF059669),
                bg: const Color(0xFFECFDF5),
              ),
              const SizedBox(width: 8),
              _statChip(
                label: 'Borradores',
                count: totalDraft,
                color: const Color(0xFFD97706),
                bg: const Color(0xFFFFFBEB),
              ),
              const SizedBox(width: 8),
              _statChip(
                label: 'Total',
                count: all.length,
                color: AppColors.primary,
                bg: AppColors.fieldBg,
              ),
            ],
          ),
          const SizedBox(height: 14),

          // ── Lista de tarjetas ──
          ...filtered.map(
            (news) => NewsCard(news: news, onRefresh: _refreshNews),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────
  // STAT CHIP
  // ─────────────────────────────────────────────
  Widget _statChip({
    required String label,
    required int count,
    required Color color,
    required Color bg,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: color.withOpacity(0.2), width: 0.5),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '$count',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
                color: color,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                color: color.withOpacity(0.75),
                letterSpacing: 0.3,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────
  // FAB
  // ─────────────────────────────────────────────
  Widget _buildFab() {
    return FloatingActionButton(
      onPressed: _goToCreate,
      backgroundColor: AppColors.primary,
      shape: const CircleBorder(),
      child: const Icon(Icons.add_rounded, color: Colors.white),
    );
  }
}
