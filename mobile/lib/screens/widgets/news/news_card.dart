import 'package:flutter/material.dart';
import 'package:mobile/constants/app_colors.dart';
import 'package:mobile/screens/models/news_model.dart';
import 'package:mobile/services/news_service.dart';
import 'edit_news_screen.dart';

class NewsCard extends StatelessWidget {
  const NewsCard({
    super.key,
    required this.news,
    required this.onRefresh,
  });

  final NewsModel news;
  final VoidCallback onRefresh;

  // ── Acciones ─────────────────────────────────
  Future<void> _deleteNews(BuildContext context) async {
    final confirmed = await _showDeleteDialog(context);
    if (confirmed != true || !context.mounted) return;

    final success = await NewsService().deleteNews(news.id);
    if (!context.mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          success
              ? 'Noticia eliminada correctamente'
              : 'Error al eliminar noticia',
        ),
        backgroundColor: success ? AppColors.primary : Colors.redAccent,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );

    if (success) onRefresh();
  }

  Future<bool?> _showDeleteDialog(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: const Text(
          '¿Eliminar noticia?',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        content: Text(
          'Se eliminará "${news.title}" de forma permanente.',
          style: const TextStyle(fontSize: 13),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar',
                style: TextStyle(color: AppColors.fieldLabel)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Eliminar',
                style: TextStyle(color: Colors.redAccent)),
          ),
        ],
      ),
    );
  }

  void _editNews(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => EditNewsScreen(news: news)),
    ).then((result) {
      if (result == true) onRefresh();
    });
  }

  // ── Build ─────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.fieldBorder, width: 0.5),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            _buildIconBox(),
            const SizedBox(width: 12),
            Expanded(child: _buildInfo()),
            const SizedBox(width: 8),
            _buildActions(context),
          ],
        ),
      ),
    );
  }

  Widget _buildIconBox() {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: AppColors.fieldBg,
        borderRadius: BorderRadius.circular(14),
      ),
      child: const Icon(
        Icons.article_outlined,
        size: 22,
        color: AppColors.primary,
      ),
    );
  }

  Widget _buildInfo() {
    final isPublished = news.status.toLowerCase() == 'publicado';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          news.title,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: AppColors.fieldText,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            Text(
              news.country,
              style: const TextStyle(
                fontSize: 10,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(width: 6),
            _buildStatusBadge(isPublished),
          ],
        ),
      ],
    );
  }

  Widget _buildStatusBadge(bool isPublished) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
      decoration: BoxDecoration(
        color: isPublished
            ? const Color(0xFFE8F5E9)
            : const Color(0xFFF3F4F6),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        news.status.toUpperCase(),
        style: TextStyle(
          fontSize: 9,
          fontWeight: FontWeight.w500,
          color: isPublished
              ? const Color(0xFF2E7D32)
              : const Color(0xFF6B7280),
        ),
      ),
    );
  }

  Widget _buildActions(BuildContext context) {
    return Row(
      children: [
        _actionBtn(
          icon: Icons.edit_outlined,
          bg: AppColors.fieldBg,
          color: AppColors.primary,
          onTap: () => _editNews(context),
        ),
        const SizedBox(width: 6),
        _actionBtn(
          icon: Icons.delete_outline_rounded,
          bg: const Color(0xFFFFF5F5),
          color: Colors.redAccent,
          onTap: () => _deleteNews(context),
        ),
      ],
    );
  }

  Widget _actionBtn({
    required IconData icon,
    required Color bg,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, size: 16, color: color),
      ),
    );
  }
}