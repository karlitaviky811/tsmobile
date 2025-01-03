
import 'package:flutter/material.dart';

class ImageProviderCloseTicketManagement with ChangeNotifier {
  List<String> _initialImagePaths = [];
  List<String> _newImagePaths = [];
  bool _isImagePickerActive = false;
  bool get isImagePickerActive => _isImagePickerActive;

  List<String> get initialImagePaths => _initialImagePaths;
  List<String> get newImagePaths => _newImagePaths;

  void setInitialImages(List<String> paths) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initialImagePaths = paths;
      notifyListeners();
    });
  }

  void setImagePickerActive(bool isActive) {
    _isImagePickerActive = isActive;
    notifyListeners();
  }

  void resetImage() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _newImagePaths.clear();
      _initialImagePaths.clear();
      notifyListeners();
    });
  }

  void addImage(String path) {
    _newImagePaths.add(path);
    notifyListeners();
  }

  void removeImage(String path) {
    if (_initialImagePaths.contains(path)) {
      _initialImagePaths.remove(path);
    } else {
      _newImagePaths.remove(path);
    }
    notifyListeners();
  }

  void clearImages() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initialImagePaths.clear();
      _newImagePaths.clear();
      notifyListeners();
    });
  }
}