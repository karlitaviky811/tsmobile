import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tsmobile/src/models/visit_model.dart';

class VisitProvider with ChangeNotifier {
  List<Visit> _visits = [];
  bool _isLoading = false;

  List<Visit> get visits => _visits;
  bool get isLoading => _isLoading;

  Future<void> fetchVisits(String ticketId) async {
    _isLoading = true;
    notifyListeners();

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('auth_token');
    print('ticketId ${ticketId}');
    final urlRequest = 'http://3.137.100.242:3000/api/v1/technical-visits?include=ticket_id=1';

    try {
      final response = await http.get(
        Uri.parse('http://3.137.100.242:3000/api/v1/technical-visits?include=ticket_id=1'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
    print('response ${json.decode(response.body)['status']}');
      if (response.statusCode == 200) {
        final data = json.decode(response.body)['data'] as List<dynamic>;
        _visits = data.map((item) => Visit.fromJson(item)).toList();
      } else {
        print('Error fetching visits: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching visits: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
