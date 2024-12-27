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
Visit? _visitData;
  bool _isLoading = false;
  String? _errorMessage;
  List<Repuesto> _repuestos = [];
  List<Repuesto> get repuestos => _repuestos;
  List<Visit> get visits => _visits;
 Visit? get visitData => _visitData;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<List<Visit>> fetchVisitsByTicket(String ticketId) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('auth_token');

    final response = await http.get(
      Uri.parse(
          'http://3.137.100.242:3000/api/v1/tickets/$ticketId?include=visits'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    Map<String, dynamic> body = json.decode(response.body);
    final jsonResponse = jsonDecode(response.body);
    if (jsonResponse['success'] == true) {
      // Decodificar el cuerpo de la respuesta
      Map<String, dynamic> body = json.decode(response.body)['data'];

      // Obtener la lista de visitas desde la propiedad 'visits'
      List<dynamic> visitsData = body['visits'];

      if (visitsData.isEmpty) {
        print('No se encontraron visitas para el ticket.');
        _visits = [];
        notifyListeners();
        return [];
      }

      // Mapear cada elemento de visitsData a un objeto Visit
      _visits = visitsData.map((dynamic item) => Visit.fromJson(item)).toList();
      notifyListeners();
      return visits;
    } else {
      print('Error al obtener las visitas: ${response.statusCode}');
      throw Exception('Failed to load visits for ticket');
    }
  }

  Future<void> fetchVisitById(String visitId) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('auth_token');

    try {
      final response = await http.get(
        Uri.parse('http://3.137.100.242:3000/api/v1/technical-visits/$visitId'),
        headers: {
          'Content-Type': 'application/json',
          "Accept": "application/json",
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        if (jsonResponse['success'] == true) {
          // Decodificar el cuerpo de la respuesta
          Map<String, dynamic> body = jsonResponse['data'];

          // Obtener la visita desde la propiedad 'data'
          Visit visitData = Visit.fromJson(body);

          if (visitData != null) {
            print('Visita encontrada y cargada.');
            _visitData = visitData;
            notifyListeners();
          }
        } else {
          print('Error al obtener la visita: ${jsonResponse['message']}');
        }
      } else {
        print('Error al obtener la visita: ${response.statusCode}');
      }
    } catch (e) {
      print('Error al obtener la visita: $e');
    }
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


   Future<void> deleteVisits(int technicalVisitId) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('auth_token');
    final urlRequest =
        'http://3.137.100.242:3000/api/v1/technical-visits/$technicalVisitId';
    try {
      final response = await http.delete(
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
