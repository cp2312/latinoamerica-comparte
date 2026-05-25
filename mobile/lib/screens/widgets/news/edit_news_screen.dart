import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mobile/constants/app_colors.dart';
import 'package:mobile/screens/models/news_model.dart';
import 'package:mobile/services/news_service.dart';
import 'news_form_hero.dart';
import 'news_form_widgets.dart';
import 'package:mobile/constants/api_constants.dart';

class EditNewsScreen extends StatefulWidget {
  const EditNewsScreen({
    super.key,
    required this.news,
  });

  final NewsModel news;

  @override
  State<EditNewsScreen> createState() => _EditNewsScreenState();
}

class _EditNewsScreenState extends State<EditNewsScreen> {
  final _formKey = GlobalKey<FormState>();

  final titleController = TextEditingController();
  final contentController = TextEditingController();

  String selectedCountry = '';
  String selectedStatus = '';

  PlatformFile? selectedImage;

  bool isLoading = false;

  String userRole = '';
  String userCountry = '';

  static const _countries = [
    'Argentina',
    'Chile',
    'Ecuador',
    'Colombia',
  ];

  static const _statusList = [
    'borrador',
    'publicado',
  ];

  @override
  void initState() {
    super.initState();

    titleController.text = widget.news.title;
    contentController.text = widget.news.content;

    selectedCountry = widget.news.country;
    selectedStatus = widget.news.status;

    _loadUserData();
  }

  // ─────────────────────────────────────────────
  // CARGAR DATOS DEL USUARIO
  // ─────────────────────────────────────────────
  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();

    final role = prefs.getString('user_rol') ?? '';
    final country = prefs.getString('user_pais') ?? '';

    setState(() {
      userRole = role;
      userCountry = country;

      // ADMIN-PAIS → país fijo
      if (role == 'admin_pais') {
        selectedCountry = country;
      }
    });
  }

  @override
  void dispose() {
    titleController.dispose();
    contentController.dispose();
    super.dispose();
  }

  // ─────────────────────────────────────────────
  // SELECCIONAR IMAGEN
  // ─────────────────────────────────────────────
  Future<void> _pickImage() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      withData: true,
    );

    if (result != null) {
      setState(() {
        selectedImage = result.files.first;
      });
    }
  }

  // ─────────────────────────────────────────────
  // ACTUALIZAR NOTICIA
  // ─────────────────────────────────────────────
  Future<void> _updateNews() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      isLoading = true;
    });

    final success = await NewsService().updateNews(
      id: widget.news.id,
      title: titleController.text.trim(),
      country: selectedCountry,
      content: contentController.text.trim(),
      status: selectedStatus,
      imageFile: selectedImage,
    );

    if (!mounted) return;

    setState(() {
      isLoading = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          success
              ? 'Noticia actualizada correctamente'
              : 'Error al actualizar noticia',
        ),
        backgroundColor:
            success ? AppColors.primary : Colors.redAccent,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );

    if (success) {
      Navigator.pop(context, true);
    }
  }

  // ─────────────────────────────────────────────
  // UI
  // ─────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    // Esperar carga del usuario
    if (selectedCountry.isEmpty) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    final isAdminPais = userRole == 'admin_pais';

    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      body: Column(
        children: [
          NewsFormHero(
            screenTitle: 'Editar Noticia',
            newsTitle: widget.news.title,
            subtitle: 'Última edición · $selectedCountry',
          ),

          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(18, 18, 18, 30),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [

                    // ───────── TÍTULO ─────────
                    NewsFormField(
                      label: 'Título',
                      icon: Icons.title_rounded,
                      controller: titleController,
                      hint: 'Título de la noticia',
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Ingrese el título';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 14),

                    // ───────── PAÍS ─────────

                    // ADMIN-PAIS → bloqueado
                    if (isAdminPais)
                      NewsFormField(
                        label: 'País',
                        icon: Icons.public_outlined,
                        controller: TextEditingController(
                          text: selectedCountry,
                        ),
                        hint: '',
                        enabled: false,
                      )

                    // SUPERADMIN → dropdown completo
                    else
                      NewsFormDropdown<String>(
                        label: 'País',
                        icon: Icons.public_outlined,
                        value: selectedCountry,
                        items: _countries.map((country) {
                          return DropdownMenuItem(
                            value: country,
                            child: Text(country),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedCountry = value!;
                          });
                        },
                      ),

                    const SizedBox(height: 14),

                    // ───────── CONTENIDO ─────────
                    NewsFormField(
                      label: 'Contenido',
                      icon: Icons.notes_rounded,
                      controller: contentController,
                      maxLines: 5,
                      hint: 'Escribe el contenido…',
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Ingrese el contenido';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 14),

                    // ───────── ESTADO ─────────
                    NewsFormDropdown<String>(
                      label: 'Estado',
                      icon: Icons.toggle_on_outlined,
                      value: selectedStatus,
                      items: _statusList.map((status) {
                        return DropdownMenuItem(
                          value: status,
                          child: Text(status),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedStatus = value!;
                        });
                      },
                    ),

                    const SizedBox(height: 14),

                    // ───────── IMAGEN ─────────
                    NewsImagePicker(
                      onTap: _pickImage,
                      imageName: selectedImage?.name,
                      label: 'Seleccionar nueva imagen',
                    ),

                    // ───────── IMAGEN ACTUAL ─────────
                    if (selectedImage == null &&
                        widget.news.image.isNotEmpty) ...[
                      const SizedBox(height: 12),
                      _buildCurrentImage(),
                    ],

                    const SizedBox(height: 22),

                    // ───────── BOTÓN ACTUALIZAR ─────────
                    NewsSubmitButton(
                      label: 'Actualizar Noticia',
                      onPressed: _updateNews,
                      isLoading: isLoading,
                    ),

                    const SizedBox(height: 10),

                    // ───────── BOTÓN CANCELAR ─────────
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

  // ─────────────────────────────────────────────
  // IMAGEN ACTUAL
  // ─────────────────────────────────────────────
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
            '${ApiConstants.baseUrl}${widget.news.image}',
            height: 160,
            width: double.infinity,
            fit: BoxFit.cover,

            errorBuilder: (_, __, ___) {
              return Container(
                height: 80,
                decoration: BoxDecoration(
                  color: AppColors.fieldBg,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: AppColors.fieldBorder,
                  ),
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
              );
            },
          ),
        ),
      ],
    );
  }

  // ─────────────────────────────────────────────
  // CANCELAR
  // ─────────────────────────────────────────────
  Widget _buildCancelButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: OutlinedButton(
        onPressed: () {
          Navigator.pop(context);
        },
        style: OutlinedButton.styleFrom(
          side: const BorderSide(
            color: AppColors.fieldBorder,
            width: 1,
          ),
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