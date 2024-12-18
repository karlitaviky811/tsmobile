import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tsmobile/src/models/part_request.dart';
import 'package:tsmobile/src/models/visit_model.dart';
import 'package:tsmobile/src/services/tecnical_visitis_service.dart';
import 'package:http/http.dart' as http;
class VisitProvider with ChangeNotifier {
  final VisitService _visitService = VisitService();
  List<Visit> _visits = [];
  bool _isLoading = false;
  String? _errorMessage;
  List<Repuesto> _repuestos = [];
  List<Repuesto> get repuestos => _repuestos;
  List<Visit> get visits => _visits;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> fetchVisitsByTicket(String ticketId) async {
    _isLoading = true;

    try {
      _visits = await _visitService.fetchVisitsByTicket(int.parse(ticketId));
      notifyListeners();
      _errorMessage = null;
    } catch (error) {
      _errorMessage = error.toString();
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> fetchRepuestos(int technicalVisitId) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('auth_token');
    final urlRequest =
        'http://3.137.100.242:3000/api/v1/part-requests?technical_visit_id=$technicalVisitId&page=1';
    try {
      final response = await http.get(
        Uri.parse(urlRequest),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        if (jsonResponse['data'] != null) {
          final data = jsonResponse['data'] as List<dynamic>;
          _repuestos = data.map((item) => Repuesto.fromJson(item)).toList();
          notifyListeners();
        }
      } else {
        print('Error fetching repuestos: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching repuestos: $e');
    }
  }
}
