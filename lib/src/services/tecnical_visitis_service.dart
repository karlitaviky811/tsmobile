import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_neat_and_clean_calendar/neat_and_clean_calendar_event.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tsmobile/src/models/visit_model.dart';
import 'package:tsmobile/src/services/send_file_service.dart';

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
        Uri.parse('http://3.137.100.242:3000/api/v1/technical-visits'),
        headers: {
          'Content-Type': 'application/json',
          "Accept": "application/json",
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

      if (responseBody['success'] == true) {
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

  Future<List<Visit>> fetchVisitsByTicket(int ticketId) async {
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

    if (response.statusCode == 200) {
      // Decodificar el cuerpo de la respuesta
      Map<String, dynamic> body = json.decode(response.body)['data'];

      // Obtener la lista de visitas desde la propiedad 'visits'
      List<dynamic> visitsData = body['visits'];

      // Mapear cada elemento de visitsData a un objeto Visit
      List<Visit> visits =
          visitsData.map((dynamic item) => Visit.fromJson(item)).toList();

      return visits;
    } else {
      throw Exception('Failed to load visits for ticket');
    }
  }

  Future<bool> sendUpdateDataVisit(
      Map<String, dynamic> data, int idTicket) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('auth_token');
    print('data $data $apiUrl');
    try {
      final response = await http.put(
        Uri.parse(apiUrl + '/${idTicket}'),
        headers: {
          'Content-Type': 'application/json',
          "Accept": "application/json",
          'Authorization': 'Bearer $token',
        },
        body: json.encode(data),
      );

      print('response ${response}');
      var jsonResponse = jsonDecode(response.body);

      if (response.statusCode == 200) {
        print('Datos enviados exitosamente.');
        return true;
      } else {
        print('Error al enviar los datos: ${response.statusCode}');
        print('Respuesta del servidor: ${response.body}');
        return false;
      }
    } catch (e) {
      print('Error al enviar la solicitud: $e');
      return false;
    }
  }

  Future<bool> sendUpdateDataVisitPartRequest(
      Map<String, dynamic> data, int idTicket, List<File> images) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('auth_token');
    print('data $data $apiUrl');
    try {
      final response = await http.post(
        Uri.parse('http://3.137.100.242:3000/api/v1/part-requests'),
        headers: {
          'Content-Type': 'application/json',
          "Accept": "application/json",
          'Authorization': 'Bearer $token',
        },
        body: json.encode(data),
      );

      print('response ${response}');
      var jsonResponse = jsonDecode(response.body);

      if (response.statusCode == 200) {
        print('repuesto solicitado éxitosamente ${jsonResponse}');
        // Enviar imágenes
        for (File image in images) {
          await sendFile(image, 'PartRequest', idTicket.toString(), 'part');
        }

        Fluttertoast.showToast(
            msg: "Solicitud de repuesto creada exitosamente",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.green,
            textColor: Colors.white,
            fontSize: 16.0);
        return true;
      } else {
        print('Error al enviar los datos: ${response.statusCode}');
        print('Respuesta del servidor: ${response.body}');
        Fluttertoast.showToast(
            msg: "Error al crear la solicitud",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
        return false;
      }
    } catch (e) {
      print('Error al enviar la solicitud: $e');
      Fluttertoast.showToast(
          msg: "Error al crear la solicitud",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
      return false;
    }
  }

  Future<bool> getDataVisitPartRequest(
      Map<String, dynamic> data, int idVisit) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('auth_token');
    print('data $data $apiUrl');
    try {
      final response = await http.post(
        Uri.parse(
            'http://3.137.100.242:3000/api/v1/part-requests?technical_visit_id=${idVisit}'),
        headers: {
          'Content-Type': 'application/json',
          "Accept": "application/json",
          'Authorization': 'Bearer $token',
        },
        body: json.encode(data),
      );

      print('response ${response}');
      var jsonResponse = jsonDecode(response.body);

      if (response.statusCode == 200) {
        print('repuesto solicitado éxitosamente');
        return true;
      } else {
        print('Error al enviar los datos: ${response.statusCode}');
        print('Respuesta del servidor: ${response.body}');
        return false;
      }
    } catch (e) {
      print('Error al enviar la solicitud: $e');
      return false;
    }
  }

  Future<bool> getDataImagePartRequest(
      Map<String, dynamic> data, int idPartRequest) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('auth_token');
    print('data $data $apiUrl');
    try {
      final response = await http.post(
        Uri.parse(
            'http://3.137.100.242:3000/api/v1/media?model_type=PartRequest&model_id=${idPartRequest}&collection_name=part'),
        headers: {
          'Content-Type': 'application/json',
          "Accept": "application/json",
          'Authorization': 'Bearer $token',
        },
        body: json.encode(data),
      );

      print('response ${response}');
      var jsonResponse = jsonDecode(response.body);

      if (response.statusCode == 200) {
        print('repuesto solicitado éxitosamente');
        return true;
      } else {
        print('Error al enviar los datos: ${response.statusCode}');
        print('Respuesta del servidor: ${response.body}');
        return false;
      }
    } catch (e) {
      print('Error al enviar la solicitud: $e');
      return false;
    }
  }




}
