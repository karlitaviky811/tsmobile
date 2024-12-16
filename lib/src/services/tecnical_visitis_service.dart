import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_neat_and_clean_calendar/neat_and_clean_calendar_event.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tsmobile/src/models/visit_model.dart';

class VisitService {
  String apiUrl = 'http://3.137.100.242:3000/api/v1/technical-visits';
  Future<List<NeatCleanCalendarEvent>> fetchTechnicalVisits() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('auth_token');

    final response = await http.get(
      Uri.parse('http://3.137.100.242:3000/api/v1/technical-visits'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((eventData) {
        return NeatCleanCalendarEvent(
          eventData['title'] ?? 'Sin título',
          description: eventData['observations'] ?? 'Sin observaciones',
          startTime: DateTime.parse(eventData['visit_date']),
          endTime: DateTime.parse(eventData['visit_date']),
          color: Colors.orange,
        );
      }).toList();
    } else {
      throw Exception('Error al cargar las visitas del técnico');
    }
  }

  Future<void> sendDataVisit(Map<String, dynamic> data) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('auth_token');
    print('data $data');
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode(data),
      );

      print('response ${response}');
      Map<String, dynamic> jsonResponse = jsonDecode(response.body);

      if (response.statusCode == 200) {
        print('Datos enviados exitosamente.');
      } else {
        print('Error al enviar los datos: ${response.statusCode}');
        print('Respuesta del servidor: ${response.body}');
      }
    } catch (e) {
      print('Error al enviar la solicitud: $e');
    }
  }

  Future<Visit?> sendDataVisitReprogramming(
      Map<String, dynamic> data, String idVisit) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('auth_token');
    String urlRequest =
        'http://3.137.100.242:3000/api/v1/technical-visits/$idVisit/reprogramming';

    print('data $data $token $urlRequest');
    try {
      final response = await http.patch(
        Uri.parse(urlRequest),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(data),
      );

      final responseBody = json.decode(response.body);
      print('response $responseBody');

      if (responseBody['status'] == 'success') {
        print('Datos enviados exitosamente.');
        return Visit.fromJson(responseBody['data']);
      } else {
        print('Error al enviar los datos: ${response.statusCode}');
        print('Respuesta del servidor: ${response.body}');
        return null;
      }
    } catch (e) {
      print('Error al enviar la solicitud: $e');
      return null;
    }
  }
}
