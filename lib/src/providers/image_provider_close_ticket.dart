import 'package:flutter/material.dart';

class ImageProviderCloseTicketManagement extends ChangeNotifier {
  List<String> _newImagePaths = [];
  List<String> _initialImagePaths = [];
  bool _isImagePickerActive = false;

  List<String> get newImagePaths => _newImagePaths;
  List<String> get initialImagePaths => _initialImagePaths;
  bool get isImagePickerActive => _isImagePickerActive;

  void addImage(String path) {
    _newImagePaths.add(path);
    notifyListeners();
  }

  void removeImage(String path) {
    _newImagePaths.remove(path);
    notifyListeners();
  }

  void setImagePickerActive(bool isActive) {
    _isImagePickerActive = isActive;
    notifyListeners();
  }

  void resetImage() {
    _newImagePaths.clear();
    notifyListeners();
  }

  void clearImages() {
    _newImagePaths.clear();
    notifyListeners();
  }

  void setInitialImages(List<String> initialImages) {
    _initialImagePaths = initialImages;
    notifyListeners();
  }
}