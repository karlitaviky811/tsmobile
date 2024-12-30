import 'package:flutter/material.dart';

class ImageProviderTechnicalBuySpareParts extends ChangeNotifier {
  List<String> _initialImagePaths = [];
  List<String> _newImagePaths = [];

  List<String> get initialImagePaths => _initialImagePaths;
  List<String> get newImagePaths => _newImagePaths;

  void setInitialImages(List<String> paths) {
    _initialImagePaths = paths;
    notifyListeners();
  }

  void addImage(String path) {
    _newImagePaths.add(path);
    notifyListeners();
  }

  void removeImage(String path) {
    _newImagePaths.remove(path);
    notifyListeners();
  }

  void clearImages() {
    _newImagePaths.clear();
    notifyListeners();
  }
}