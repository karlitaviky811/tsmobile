import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tsmobile/src/models/images_model.dart';

class ImageUploaderBuySparePartTechnical extends StatefulWidget {
  final List<ImageData> initialImages;
  final bool showAddButton;

  ImageUploaderBuySparePartTechnical({Key? key, this.initialImages = const [], this.showAddButton = true}) : super(key: key);

  @override
  _ImageUploaderBuySparePartTechnicalState createState() => _ImageUploaderBuySparePartTechnicalState();
}

class _ImageUploaderBuySparePartTechnicalState extends State<ImageUploaderBuySparePartTechnical> {
  List<String> _initialImagePaths = [];
  List<String> _newImagePaths = [];
  bool _isPickerActive = false;

  @override
  void initState() {
    super.initState();
    _initialImagePaths = widget.initialImages.map((imgData) => imgData.originalUrl).toList();
  }

  Future<void> _pickImage() async {
    if (_isPickerActive) return; // Evitar abrir el selector de imágenes si ya está activo

    setState(() {
      _isPickerActive = true;
    });

    try {
      final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (pickedFile != null && mounted) {
        setState(() {
          _newImagePaths.add(pickedFile.path);
        });
      }
    } catch (e) {
      print('Error picking image: $e');
    } finally {
      setState(() {
        _isPickerActive = false;
      });
    }
  }

  void _removeImage(String path) {
    setState(() {
      _newImagePaths.remove(path);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.showAddButton)
          ElevatedButton(
            onPressed: _pickImage,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xff051937),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text('Añadir imágenes presupuesto', style: TextStyle(color: Colors.white)),
          ),
        if (_initialImagePaths.isNotEmpty || _newImagePaths.isNotEmpty)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  'Imágenes de presupuesto:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              Wrap(
                children: [
                  ..._initialImagePaths.map((path) {
                    return Stack(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Image.network(
                            path,
                            width: 100,
                            height: 100,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ],
                    );
                  }).toList(),
                  ..._newImagePaths.map((path) {
                    return Stack(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: _isUrl(path)
                              ? Image.network(
                                  path,
                                  width: 100,
                                  height: 100,
                                  fit: BoxFit.cover,
                                )
                              : Image.file(
                                  File(path),
                                  width: 100,
                                  height: 100,
                                  fit: BoxFit.cover,
                                ),
                        ),
                        Positioned(
                          right: 0,
                          child: GestureDetector(
                            onTap: () => _removeImage(path),
                            child: const Icon(Icons.remove_circle, color: Colors.red),
                          ),
                        ),
                      ],
                    );
                  }).toList(),
                ],
              ),
            ],
          ),
      ],
    );
  }

  bool _isUrl(String path) {
    try {
      Uri uri = Uri.parse(path);
      return uri.isAbsolute && (uri.scheme == 'http' || uri.scheme == 'https');
    } catch (e) {
      return false;
    }
  }
}