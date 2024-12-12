import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tsmobile/src/models/tickets_model.dart';
import 'package:intl/intl.dart';

const String apiUrl =
    'http://3.137.100.242:3000/api/v1/tickets?include=serviceCall';

class TicketService {
  Future<List<ServiceTicket>> fetchServiceTickets() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('auth_token');
      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization':
              'Bearer $token', // Asegúrate de reemplazar con tu token real
        },
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> jsonResponse = jsonDecode(response.body);
        List<dynamic> data = jsonResponse['data'];
        return data.map((item) => ServiceTicket.fromJson(item)).toList();
      } else {
        throw Exception('Failed to load service tickets');
      }
    } catch (e) {
      throw Exception('Error fetching service tickets: $e');
    }
  }

  Future<ServiceTicket> fetchServiceTicketById(idTicket) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('auth_token');
      final response = await http.get(
        Uri.parse(
            'http://3.137.100.242:3000/api/v1/tickets/$idTicket?include=serviceCall'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> jsonResponse = jsonDecode(response.body);
        Map<String, dynamic> data = jsonResponse['data'];
        print('data $data');

        return ServiceTicket.fromJson(data);
      } else {
        throw Exception('Failed to load service ticket');
      }
    } catch (e) {
      throw Exception('Error fetching service ticket: $e');
    }
  }

  Future<dynamic> updateTickets(idTicket, data, token) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('auth_token');
      final response = await http.put(
        Uri.parse('http://3.137.100.242:3000/api/v1/tickets/${idTicket}'),
        headers: {
          "Content-Type": "application/json",
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(data),
      );

      if (response.statusCode == 200) {
        print("Detalles guardados con éxito $data");
        // Acciones adicionales después de guardar
      } else {
        print("Error al guardar los detalles: ${response.body}");
      }
    } catch (e) {
      print("Error al conectar con el servidor: $e");
    }
  }

  Future<void> saveFormData(
      String date, String observations, List<File> images, idTicket) async {
    String apiUrl =
        'http://3.137.100.242:3000/api/v1/tickets/${idTicket}'; // Reemplaza con tu endpoint real
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('auth_token');

    String dateString = "2023-12-31 23:59";
    DateFormat dateFormat = DateFormat("dd/MM/yyyy 'at' HH:mm");
    DateTime dateTime = dateFormat.parse(date.replaceAll('/', '-'));

    print("String: $dateString");
    //print("DateTime: $dateTime");

    // Crea el cuerpo de la solicitud
    Map<String, dynamic> formData = {
      'diagnosis_date': dateTime,
      'diagnosis_detail': observations,
      // Aquí podrías agregar la lógica para manejar las imágenes si es necesario
    };

    // Convierte el mapa a JSON
    String body = json.encode(formData);

    try {
      final response = await http.put(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: body,
      );

      if (response.statusCode == 200) {
        print('Datos guardados exitosamente.');
      } else {
        print('Error al guardar los datos: ${response.statusCode}');
        print('Respuesta del servidor: ${response.body}');
      }
    } catch (e) {
      print('Error al enviar la solicitud: $e');
    }
  }

  Future<void> savecloseTicketFormData(
      String date, String observations, List<File> images, idTicket) async {
    String apiUrl =
        'http://3.137.100.242:3000/api/v1/tickets/${idTicket}'; // Reemplaza con tu endpoint real
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('auth_token');

    String dateString = "2023-12-31 23:59";
    DateFormat dateFormat = DateFormat("yyyy-MM-dd HH:mm");
    // DateTime dateTime = dateFormat.parse(date);

    print("String: $dateString");
    //print("DateTime: $dateTime");

    // Crea el cuerpo de la solicitud
    Map<String, dynamic> formData = {
      'solution_date': new DateTime.now().toIso8601String(),
      'solution_detail': observations,
      'status': 2,
      // Aquí podrías agregar la lógica para manejar las imágenes si es necesario
    };

    // Convierte el mapa a JSON
    String body = json.encode(formData);

    try {
      final response = await http.put(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: body,
      );

      if (response.statusCode == 200) {
        print('Datos guardados exitosamente.');
      } else {
        print('Error al guardar los datos: ${response.statusCode}');
        print('Respuesta del servidor: ${response.body}');
      }
    } catch (e) {
      print('Error al enviar la solicitud: $e');
    }
  }
}
