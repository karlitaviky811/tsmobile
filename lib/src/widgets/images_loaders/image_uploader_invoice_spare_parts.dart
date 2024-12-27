import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:tsmobile/src/models/images_model.dart';
import 'package:tsmobile/src/providers/provider_invoice_spare_parts.dart';

class ImageUploaderInvoiceThecnical extends StatefulWidget {
  final List<ImageData> initialImages;
  final bool showAddButton;

  ImageUploaderInvoiceThecnical({Key? key, this.initialImages = const [], required this.showAddButton}) : super(key: key);

  @override
  _ImageUploaderInvoiceThecnicalState createState() => _ImageUploaderInvoiceThecnicalState();
}

class _ImageUploaderInvoiceThecnicalState extends State<ImageUploaderInvoiceThecnical> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final imageProvider = Provider.of<ImageProviderTechnicalInvoice>(context, listen: false);
      imageProvider.setInitialImages(widget.initialImages.map((imgData) => imgData.originalUrl).toList());
    });
  }

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(source: source);
    if (pickedFile != null) {
      final imageProvider = Provider.of<ImageProviderTechnicalInvoice>(context, listen: false);
      if (mounted) {
        imageProvider.addImage(pickedFile.path);
      }
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

  @override
  Widget build(BuildContext context) {
    return Consumer<ImageProviderTechnicalInvoice>(
      builder: (context, imageProvider, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if(widget.showAddButton)
               ElevatedButton.icon(
              onPressed: () => _showPickerOptions(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xff051937),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              icon: const Icon(Icons.insert_drive_file, color: Colors.white),
              label: const Text('Añadir fotos de la factura', style: TextStyle(color: Colors.white)),
            )
          
           ,
            if (imageProvider.initialImagePaths.isNotEmpty || imageProvider.newImagePaths.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.0),
                    child: Text(
                      'Facturas cargadas:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  Wrap(
                    children: [
                      ...imageProvider.initialImagePaths.map((path) {
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
                      ...imageProvider.newImagePaths.map((path) {
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
                                onTap: () => imageProvider.removeImage(path),
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
