import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_neat_and_clean_calendar/neat_and_clean_calendar_event.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tsmobile/src/models/visit_model.dart';
import 'package:tsmobile/src/services/send_file_service.dart';

class VisitService {
  final String apiUrl = '${dotenv.env['API_URL']}technical-visits';

  Future<List<NeatCleanCalendarEvent>> fetchTechnicalVisits() async {
    final response = await _getRequest(apiUrl);
    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body)['data'];
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

  Future<bool> sendDataVisit(Map<String, dynamic> data, List<File> images) async {
    final response = await _postRequest(apiUrl, data);
    if (response.statusCode == 200 || response.statusCode == 201) {
      final fileService = FileService();
      var jsonResponse = jsonDecode(response.body);
      for (File image in images) {
        await fileService.sendFile(image, 'Visit', jsonResponse['data']['id'].toString(), 'visit');
      }
      return true;
    } else {
      print('Error al enviar los datos: ${response.statusCode}');
      print('Respuesta del servidor: ${response.body}');
      return false;
    }
  }

  Future<Visit?> sendDataVisitReprogramming(Map<String, dynamic> data, String idVisit) async {
    final response = await _patchRequest('$apiUrl/$idVisit/reprogramming', data);
    final responseBody = json.decode(response.body);
    if (responseBody['success'] == true) {
      return Visit.fromJson(responseBody['data']);
    } else {
      print('Error al enviar los datos: ${response.statusCode}');
      print('Respuesta del servidor: ${response.body}');
      return null;
    }
  }

  Future<List<Visit>> fetchVisitsByTicket(int ticketId) async {
    final response = await _getRequest('${dotenv.env['API_URL']}tickets/$ticketId?include=visits');
    if (response.statusCode == 200) {
      Map<String, dynamic> body = json.decode(response.body)['data'];
      List<dynamic> visitsData = body['visits'];
      if (visitsData.isEmpty) {
        return [];
      }
      return visitsData.map((dynamic item) => Visit.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load visits for ticket');
    }
  }

  Future<bool> sendUpdateDataVisit(Map<String, dynamic> data, int idTicket, List<File> images) async {
    final response = await _putRequest('$apiUrl/$idTicket', data);
    var jsonResponse = jsonDecode(response.body);
    if (jsonResponse['success'] == true) {
      final fileService = FileService();
      for (File image in images) {
        if (await image.exists()) {
          await fileService.sendFile(image, 'Visit', jsonResponse['data']['id'].toString(), 'visit');
        } else {
          print('El archivo no existe: ${image.path}');
        }
      }
      return true;
    } else {
      print('Error al enviar los datos: ${response.statusCode}');
      print('Respuesta del servidor: ${response.body}');
      return false;
    }
  }

  Future<bool> sendUpdateDataVisitPartRequest(Map<String, dynamic> data, int idVisit, List<File> images) async {
    final response = await _postRequest('${dotenv.env['API_URL']}part-requests', data);
    if (response.statusCode == 200) {
      Fluttertoast.showToast(
        msg: "Datos guardados exitosamente",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      var jsonResponse = jsonDecode(response.body);
      final fileService = FileService();
      for (File image in images) {
        if (await image.exists()) {
          await fileService.sendFile(image, 'PartRequest', jsonResponse['data']['id'].toString(), 'part');
        } else {
          print('El archivo no existe: ${image.path}');
        }
      }
      return true;
    } else {
      Fluttertoast.showToast(
        msg: "Error al guardar los datos",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      return false;
    }
  }

  Future<bool> getDataVisitPartRequest(Map<String, dynamic> data, int idVisit) async {
    final response = await _postRequest('${dotenv.env['API_URL']}part-requests?technical_visit_id=$idVisit', data);
    if (response.statusCode == 200) {
      print('repuesto solicitado éxitosamente');
      return true;
    } else {
      print('Error al enviar los datos: ${response.statusCode}');
      print('Respuesta del servidor: ${response.body}');
      return false;
    }
  }

  Future<http.Response> _getRequest(String url) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('auth_token');
    if (token == null) {
      print('No se encontró el token de usuario');
      throw Exception('No se encontró el token de usuario');
    }
    try {
      return await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );
    } catch (e) {
      throw Exception('Failed to make GET request: $e');
    }
  }

  Future<http.Response> _postRequest(String url, Map<String, dynamic> body) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('auth_token');
    if (token == null) {
      print('No se encontró el token de usuario');
      throw Exception('No se encontró el token de usuario');
    }
    try {
      return await http.post(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode(body),
      );
    } catch (e) {
      throw Exception('Failed to make POST request: $e');
    }
  }

  Future<http.Response> _patchRequest(String url, Map<String, dynamic> body) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('auth_token');
    if (token == null) {
      print('No se encontró el token de usuario');
      throw Exception('No se encontró el token de usuario');
    }
    try {
      return await http.patch(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode(body),
      );
    } catch (e) {
      throw Exception('Failed to make PATCH request: $e');
    }
  }

  Future<http.Response> _putRequest(String url, Map<String, dynamic> body) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('auth_token');
    if (token == null) {
      print('No se encontró el token de usuario');
      throw Exception('No se encontró el token de usuario');
    }
    try {
      return await http.put(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode(body),
      );
    } catch (e) {
      throw Exception('Failed to make PUT request: $e');
    }
  }
}
