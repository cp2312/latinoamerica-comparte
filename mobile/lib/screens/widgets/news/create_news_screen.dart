import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mobile/constants/app_colors.dart';
import 'package:mobile/services/news_service.dart';
import 'news_form_hero.dart';
import 'news_form_widgets.dart';

class CreateNewsScreen extends StatefulWidget {
  const CreateNewsScreen({super.key});

  @override
  State<CreateNewsScreen> createState() => _CreateNewsScreenState();
}

class _CreateNewsScreenState extends State<CreateNewsScreen> {
  final _formKey = GlobalKey<FormState>();

  final titleController = TextEditingController();
  final contentController = TextEditingController();

  String selectedCountry = '';
  String selectedStatus = 'borrador';

  PlatformFile? selectedImage;

  bool isLoading = false;

  String userRole = '';
  String userCountry = '';

  static const _countries = ['Colombia', 'Chile', 'Argentina', 'Ecuador'];

  @override
  void initState() {
    super.initState();
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

      if (role == 'admin_pais') {
        selectedCountry = country;
      } else {
        selectedCountry = 'Colombia';
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
      allowMultiple: false,
      withData: true,
    );

    if (result != null && result.files.isNotEmpty) {
      setState(() {
        selectedImage = result.files.first;
      });
    }
  }

  // ─────────────────────────────────────────────
  // GUARDAR NOTICIA
  // ─────────────────────────────────────────────
  Future<void> _saveNews() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      isLoading = true;
    });

    final success = await NewsService().createNews(
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
          success ? 'Noticia creada correctamente' : 'Error al guardar noticia',
        ),
        backgroundColor: success ? AppColors.primary : Colors.redAccent,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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
    // Esperar datos del usuario
    if (selectedCountry.isEmpty) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final isAdminPais = userRole == 'admin_pais';

    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      body: Column(
        children: [
          NewsFormHero(
            screenTitle: 'Crear Noticia',
            newsTitle: 'Nueva publicación',
            subtitle: 'Completa la información de la noticia',
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

                    // ADMIN-PAIS → país bloqueado
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
                      hint: 'Escribe el contenido de la noticia…',
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Ingrese el contenido';
                        }
                        return null;
                      },
                    ),

                

                    const SizedBox(height: 14),

                    // ───────── IMAGEN ─────────
                    NewsImagePicker(
                      onTap: _pickImage,
                      imageName: selectedImage?.name,
                    ),

                    const SizedBox(height: 22),

                    // ───────── BOTÓN ─────────
                    NewsSubmitButton(
                      label: 'Guardar noticia',
                      onPressed: _saveNews,
                      isLoading: isLoading,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
