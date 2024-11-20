import 'package:flutter/material.dart';
import 'package:tsmobile/src/core/theme/app.styles.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class DiagnosticForm extends StatefulWidget {
  final Function(DateTime?, String, String, List<File>) onSave;

  DiagnosticForm({required this.onSave});

  @override
  _DiagnosticFormState createState() => _DiagnosticFormState();
}

class _DiagnosticFormState extends State<DiagnosticForm> {
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _observationsController = TextEditingController();
  final TextEditingController _commentsController = TextEditingController();
  final List<File> _images = [];
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        _dateController.text = "${picked.day}/${picked.month}/${picked.year}";
      });
    }
  }

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _images.add(File(image.path));
      });
    }
  }

  void _removeImage(int index) {
    if (index >= 0 && index < _images.length) {
      setState(() {
        _images.removeAt(index);
      });
    } else {
      print('Índice inválido: $index');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Card(
              color: Colors.white,
              elevation: 20,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Diagnóstico',
                      textAlign: TextAlign.left,
                      style: AppStyle.txtPoppinsMedium18Black,
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _dateController,
                      decoration: InputDecoration(
                        labelText: 'Fecha',
                        prefixIcon: IconButton(
                          icon: const Icon(Icons.calendar_today),
                          onPressed: () => _pickDate(context),
                        ),
                      ),
                      readOnly: true,
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _observationsController,
                      decoration: const InputDecoration(labelText: 'Observaciones'),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _commentsController,
                      decoration: const InputDecoration(labelText: 'Comentarios'),
                    ),
                    const SizedBox(height: 16),
                    TextButton.icon(
                      icon: Icon(Icons.add_photo_alternate),
                      label: Text('Añadir Imagen'),
                      onPressed: _pickImage,
                    ),
                    const SizedBox(height: 16),
                    _buildImageThumbnails(),
                    const SizedBox(height: 30),
                    Center(
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xff051937),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        icon: const Icon(Icons.save, size: 18, color: Colors.white),
                        onPressed: () {
                          final DateTime? selectedDate = DateTime.tryParse(_dateController.text);
                          widget.onSave(
                            selectedDate,
                            _observationsController.text,
                            _commentsController.text,
                            _images,
                          );
                        },
                        label: const Text(
                          'Guardar Información',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImageThumbnails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Imágenes Añadidas:',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        SizedBox(
          height: 100,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: _images.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.all(4.0),
                child: Stack(
                  children: [
                    Image.file(
                      _images[index],
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                    ),
                    Positioned(
                      right: 0,
                      child: GestureDetector(
                        onTap: () => _removeImage(index),
                        child: Icon(
                          Icons.remove_circle,
                          color: Colors.red,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
