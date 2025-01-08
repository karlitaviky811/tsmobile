import 'package:flutter/material.dart';

class ExpansionProvider extends ChangeNotifier {
  Map<String, bool> _expandedStates = {};

  bool isExpanded(String id) {
    return _expandedStates[id] ?? false;
  }

  void setExpanded(String id, bool isExpanded) {
    _expandedStates[id] = isExpanded;
    notifyListeners();
  }
}
