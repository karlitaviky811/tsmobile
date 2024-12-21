import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:tsmobile/src/models/image_provider_visit.dart';
import 'package:tsmobile/src/models/images_model.dart';
import 'package:tsmobile/src/providers/image_provider_diagnostic.dart';
import 'package:tsmobile/src/providers/image_provider_visit.dart';

class ImageUploaderVisits extends StatefulWidget {
  final List<ImageData> initialImages;

  ImageUploaderVisits({Key? key, this.initialImages = const []}) : super(key: key);

  @override
  _ImageUploaderDiagnosticState createState() => _ImageUploaderDiagnosticState();
}

class _ImageUploaderDiagnosticState extends State<ImageUploaderVisits> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final imageProvider = Provider.of<ImagesVisitProviderModel>(context, listen: false);
      imageProvider.setInitialImages(widget.initialImages.map((imgData) => imgData.originalUrl).toList());
    });
  }

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final imageProvider = Provider.of<ImagesVisitProviderModel>(context, listen: false);
      imageProvider.addImage(pickedFile.path);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ImagesVisitProviderModel>(
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
            if (imageProvider.initialImagePaths.isNotEmpty || imageProvider.newImagePaths.isNotEmpty)
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
