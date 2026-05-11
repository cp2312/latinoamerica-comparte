import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import '../../../../services/news_service.dart';

class CreateNewsScreen extends StatefulWidget {
  const CreateNewsScreen({super.key});

  @override
  State<CreateNewsScreen> createState() => _CreateNewsScreenState();
}

class _CreateNewsScreenState extends State<CreateNewsScreen> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController contentController = TextEditingController();

  final List<String> countries = [
    'Colombia',
    'Chile',
    'Argentina',
    'Ecuador',
  ];

  String selectedCountry = 'Colombia';
  String selectedStatus = 'borrador';

  String? selectedImageName;

  @override
  void dispose() {
    titleController.dispose();
    contentController.dispose();
    super.dispose();
  }

 

  Future<void> saveNews() async {
    final success = await NewsService().createNews(
      title: titleController.text.trim(),
      country: selectedCountry,
      content: contentController.text.trim(),
      status: selectedStatus,
    );

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          success
              ? 'Noticia creada correctamente'
              : 'Error al guardar noticia',
        ),
      ),
    );

    if (success) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FC),
      appBar: AppBar(
        title: const Text('Crear Noticia'),
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Nueva publicación',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            const Text(
              'Completa la información de la noticia',
              style: TextStyle(fontSize: 14),
            ),

            const SizedBox(height: 24),

            TextField(
              controller: titleController,
              decoration: _inputDecoration('Título de la noticia'),
            ),

            const SizedBox(height: 16),

            DropdownButtonFormField<String>(
              value: selectedCountry,
              decoration: _inputDecoration('País'),
              items: countries.map((country) {
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

            const SizedBox(height: 16),

            TextField(
              controller: contentController,
              maxLines: 5,
              decoration: _inputDecoration('Contenido'),
            ),

            const SizedBox(height: 16),

            DropdownButtonFormField<String>(
              value: selectedStatus,
              decoration: _inputDecoration('Estado'),
              items: const [
                DropdownMenuItem(
                  value: 'borrador',
                  child: Text('Borrador'),
                ),
                DropdownMenuItem(
                  value: 'publicado',
                  child: Text('Publicado'),
                ),
              ],
              onChanged: (value) {
                setState(() {
                  selectedStatus = value!;
                });
              },
            ),

            const SizedBox(height: 20),

            InkWell(
              
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: Colors.grey.shade300,
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.image_outlined),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        selectedImageName ?? 'Seleccionar imagen',
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 28),

            SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton(
                onPressed: saveNews,
                child: const Text(
                  'Guardar noticia',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
    );
  }
}