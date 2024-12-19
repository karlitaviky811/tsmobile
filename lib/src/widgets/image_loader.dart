import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:tsmobile/src/models/image_provider_diagnostic.dart';
import 'package:tsmobile/src/models/images_model.dart';


class ImageUploaderDiagnostic extends StatefulWidget {
  final List<ImageData> initialImages;

  ImageUploaderDiagnostic({Key? key, this.initialImages = const []}) : super(key: key);

  @override
  _ImageUploaderDiagnosticState createState() => _ImageUploaderDiagnosticState();
}

class _ImageUploaderDiagnosticState extends State<ImageUploaderDiagnostic> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final imageProvider = Provider.of<ImageProviderDiagnostic>(context, listen: false);
      imageProvider.setInitialImages(widget.initialImages.map((imgData) => imgData.originalUrl).toList());
    });
  }

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final imageProvider = Provider.of<ImageProviderDiagnostic>(context, listen: false);
      imageProvider.addImage(pickedFile.path);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ImageProviderDiagnostic>(
      builder: (context, imageProvider, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ElevatedButton(
              onPressed: _pickImage,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xff051937),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text('Añadir imágenes', style: TextStyle(color: Colors.white)),
            ),
            if (imageProvider.imagePaths.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.0),
                    child: Text(
                      'Imágenes cargadas:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  Wrap(
                    children: imageProvider.imagePaths.map((path) {
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
