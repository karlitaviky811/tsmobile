import 'package:flutter/material.dart';

class ImagesDiagnosticProviderModel with ChangeNotifier {
  List<String> _imagePaths = [];

  List<String> get imagePaths => _imagePaths;

  void addImagePath(String path) {
    _imagePaths.add(path);
    notifyListeners();
  }

  void removeImagePath(String path) {
    _imagePaths.remove(path);
    notifyListeners();
  }

  void setImagePaths(List<String> paths) {
    _imagePaths = paths;
    notifyListeners();
  }
}
