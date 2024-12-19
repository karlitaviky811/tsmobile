import 'dart:collection';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImageProviderDiagnostic with ChangeNotifier {
  List<String> _imagePaths = [];

  UnmodifiableListView<String> get imagePaths => UnmodifiableListView(_imagePaths);

  void addImage(String path) {
    _imagePaths.add(path);
    notifyListeners();
  }

  void removeImage(String path) {
    _imagePaths.remove(path);
    notifyListeners();
  }

  void setInitialImages(List<String> paths) {
    _imagePaths = paths;
    notifyListeners();
  }
}
