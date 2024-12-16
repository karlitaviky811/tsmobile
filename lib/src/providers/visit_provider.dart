import 'package:flutter/material.dart';
import 'package:tsmobile/src/models/visit_model.dart';
import 'package:tsmobile/src/services/tecnical_visitis_service.dart';



class VisitProvider with ChangeNotifier {
  final VisitService _visitService = VisitService();
  List<Visit> _visits = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<Visit> get visits => _visits;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> fetchVisitsByTicket(String ticketId) async {
    _isLoading = true;
  

    try {
      _visits = await _visitService.fetchVisitsByTicket(ticketId);
        notifyListeners();
      _errorMessage = null;
    } catch (error) {
      _errorMessage = error.toString();
    }

    _isLoading = false;
    notifyListeners();
  }
}
