import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:mobile/constants/app_colors.dart';
import 'package:mobile/screens/models/news_model.dart';
import 'package:mobile/services/news_service.dart';
import 'news_form_hero.dart';
import 'news_form_widgets.dart';

class EditNewsScreen extends StatefulWidget {
  const EditNewsScreen({super.key, required this.news});

  final NewsModel news;

  @override
  State<EditNewsScreen> createState() => _EditNewsScreenState();
}

class _EditNewsScreenState extends State<EditNewsScreen> {
  final _formKey          = GlobalKey<FormState>();
  final titleController   = TextEditingController();
  final contentController = TextEditingController();

  String selectedCountry = '';
  String selectedStatus  = '';
  PlatformFile? selectedImage;
  bool isLoading = false;

  static const _countries = [
    'Argentina', 'Chile', 'Ecuador', 'Colombia',
  ];
  static const _statusList = ['borrador', 'publicado'];

  @override
  void initState() {
    super.initState();
    titleController.text   = widget.news.title;
    contentController.text = widget.news.content;
    selectedCountry        = widget.news.country;
    selectedStatus         = widget.news.status;
  }

  @override
  void dispose() {
    titleController.dispose();
    contentController.dispose();
    super.dispose();
  }

  // ── Acciones ─────────────────────────────────
  Future<void> _pickImage() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      withData: true,
    );
    if (result != null) {
      setState(() => selectedImage = result.files.first);
    }
  }

  Future<void> _updateNews() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => isLoading = true);

    final success = await NewsService().updateNews(
      id:        widget.news.id,
      title:     titleController.text.trim(),
      country:   selectedCountry,
      content:   contentController.text.trim(),
      status:    selectedStatus,
      imageFile: selectedImage,
    );

    if (!mounted) return;
    setState(() => isLoading = false);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          success
              ? 'Noticia actualizada correctamente'
              : 'Error al actualizar noticia',
        ),
        backgroundColor: success ? AppColors.primary : Colors.redAccent,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );

    if (success) Navigator.pop(context, true);
  }

  // ── Build ─────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      body: Column(
        children: [
          NewsFormHero(
            screenTitle: 'Editar Noticia',
            newsTitle: widget.news.title,
            subtitle: 'Última edición · ${widget.news.country}',
          ),
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(18, 18, 18, 30),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    NewsFormField(
                      label: 'Título',
                      icon: Icons.title_rounded,
                      controller: titleController,
                      hint: 'Título de la noticia',
                      validator: (v) => (v == null || v.trim().isEmpty)
                          ? 'Ingrese el título'
                          : null,
                    ),
                    const SizedBox(height: 14),
                    NewsFormDropdown<String>(
                      label: 'País',
                      icon: Icons.public_outlined,
                      value: selectedCountry,
                      items: _countries
                          .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                          .toList(),
                      onChanged: (v) => setState(() => selectedCountry = v!),
                    ),
                    const SizedBox(height: 14),
                    NewsFormField(
                      label: 'Contenido',
                      icon: Icons.notes_rounded,
                      controller: contentController,
                      maxLines: 5,
                      hint: 'Escribe el contenido…',
                      validator: (v) => (v == null || v.trim().isEmpty)
                          ? 'Ingrese el contenido'
                          : null,
                    ),
                    const SizedBox(height: 14),
                    NewsFormDropdown<String>(
                      label: 'Estado',
                      icon: Icons.toggle_on_outlined,
                      value: selectedStatus,
                      items: _statusList
                          .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                          .toList(),
                      onChanged: (v) => setState(() => selectedStatus = v!),
                    ),
                    const SizedBox(height: 14),
                    NewsImagePicker(
                      onTap: _pickImage,
                      imageName: selectedImage?.name,
                      label: 'Seleccionar nueva imagen',
                    ),

                    // Imagen actual si existe y no se seleccionó una nueva
                    if (selectedImage == null &&
                        widget.news.image != null &&
                        widget.news.image!.isNotEmpty) ...[
                      const SizedBox(height: 12),
                      _buildCurrentImage(),
                    ],

                    const SizedBox(height: 22),
                    NewsSubmitButton(
                      label: 'Actualizar Noticia',
                      onPressed: _updateNews,
                      isLoading: isLoading,
                    ),
                    const SizedBox(height: 10),
                    _buildCancelButton(context),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCurrentImage() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'IMAGEN ACTUAL',
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w600,
            color: AppColors.fieldLabel,
            letterSpacing: 0.8,
          ),
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(14),
          child: Image.network(
            'http://127.0.0.1:3000${widget.news.image}',
            height: 160,
            width: double.infinity,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => Container(
              height: 80,
              decoration: BoxDecoration(
                color: AppColors.fieldBg,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.fieldBorder),
              ),
              child: const Center(
                child: Text(
                  'No se pudo cargar la imagen',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.fieldLabel,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCancelButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: OutlinedButton(
        onPressed: () => Navigator.pop(context),
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: AppColors.fieldBorder, width: 1),
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: const Text(
          'Cancelar',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppColors.primary,
          ),
        ),
      ),
    );
  }
}