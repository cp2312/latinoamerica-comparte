import 'package:flutter/material.dart';
import 'package:mobile/constants/app_colors.dart';
import 'package:mobile/screens/models/news_model.dart';
import 'package:mobile/screens/widgets/news/news_card.dart';
import 'package:mobile/screens/widgets/news/create_news_screen.dart';
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

  @override
  void initState() {
    super.initState();
    _loadNews();
  }

  void _loadNews() {
    newsFuture = NewsService().getNews();
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

  List<NewsModel> _applyFilters(List<NewsModel> list) {
    return list.where((n) {
      final matchSearch =
          n.title.toLowerCase().contains(_search.toLowerCase());
      final matchStatus = _filterStatus == 'todas' ||
          n.status.toLowerCase() == _filterStatus;
      return matchSearch && matchStatus;
    }).toList();
  }

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

  // ── Topbar ───────────────────────────────────
  Widget _buildTopbar(BuildContext context) {
    final top = MediaQuery.of(context).padding.top;
    return Container(
      color: AppColors.heroBottom,
      padding: EdgeInsets.fromLTRB(18, top + 14, 18, 16),
      child: Column(
        children: [
          // Status + navegación
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
              const Expanded(
                child: Text(
                  'Noticias',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(width: 34),
            ],
          ),
          const SizedBox(height: 14),

          // Buscador
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

          // Filtros
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

  // ── Body ─────────────────────────────────────
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

    if (filtered.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.article_outlined,
                size: 48, color: AppColors.primary.withOpacity(0.3)),
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
      child: ListView.builder(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 90),
        itemCount: filtered.length,
        itemBuilder: (_, i) => NewsCard(
          news: filtered[i],
          onRefresh: _refreshNews,
        ),
      ),
    );
  }

  // ── FAB ──────────────────────────────────────
  Widget _buildFab() {
    return FloatingActionButton(
      onPressed: _goToCreate,
      backgroundColor: AppColors.primary,
      shape: const CircleBorder(),
      child: const Icon(Icons.add_rounded, color: Colors.white),
    );
  }
}