import 'package:flutter/material.dart';

class ImagePickerProvider extends ChangeNotifier {
  bool _isImagePickerActive = false;

  bool get isImagePickerActive => _isImagePickerActive;

  void setImagePickerActive(bool isActive) {
    _isImagePickerActive = isActive;
    notifyListeners();
  }
}
