import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:tsmobile/src/models/images_model.dart';
import 'package:tsmobile/src/providers/provider_technical_buy_spare_parts.dart';

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
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _initialImagePaths = widget.initialImages.map((imgData) => imgData.originalUrl).toList();
    final imageProvider = Provider.of<ImageProviderTechnicalBuySpareParts>(context, listen: false);
    _newImagePaths = imageProvider.newImagePaths;
  }

  Future<void> _pickImage(ImageSource source) async {
    if (_isPickerActive) return; // Evitar abrir el selector de imágenes si ya está activo

    setState(() {
      _isPickerActive = true;
    });

    try {
      final pickedFile = await _picker.pickImage(source: source);
      if (pickedFile != null && mounted) {
        setState(() {
          if (!_newImagePaths.contains(pickedFile.path)) {
            final imageProvider = Provider.of<ImageProviderTechnicalBuySpareParts>(context, listen: false);
            imageProvider.addImage(pickedFile.path);
          }
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

  void _showPickerOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: Icon(Icons.photo_library),
                title: Text('Seleccionar desde la galería'),
                onTap: () {
                  _pickImage(ImageSource.gallery);
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                leading: Icon(Icons.photo_camera),
                title: Text('Tomar una foto'),
                onTap: () {
                  _pickImage(ImageSource.camera);
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _removeImage(String path) {
    setState(() {
      _newImagePaths.remove(path);
      final imageProvider = Provider.of<ImageProviderTechnicalBuySpareParts>(context, listen: false);
      imageProvider.removeImage(path);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ImageProviderTechnicalBuySpareParts>(
      builder: (context, imageProvider, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.showAddButton)
              ElevatedButton(
                onPressed: () => _showPickerOptions(context),
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
      },
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