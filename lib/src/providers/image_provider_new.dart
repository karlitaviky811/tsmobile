
import 'package:flutter/material.dart';

class ImageProviderSparePartsNew with ChangeNotifier {
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
    if (_initialImagePaths.contains(path)) {
      _initialImagePaths.remove(path);
    } else {
      _newImagePaths.remove(path);
    }
    notifyListeners();
  }

  void clearImages() {
    _initialImagePaths.clear();
    _newImagePaths.clear();
    notifyListeners();
  }
}



