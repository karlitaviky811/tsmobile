import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tsmobile/src/models/tickets_model.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';
import 'package:http_parser/http_parser.dart';

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
          "Accept": "application/json",
          'Authorization':
              'Bearer $token', // Asegúrate de reemplazar con tu token real
        },
      );
      print('respsonse  ${jsonDecode(response.body)}');
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
          "Accept": "application/json",
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
          'Content-Type': 'application/json',
          "Accept": "application/json",
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

  Future<void> sendFile(File file, String modelType, String modelId,
      String collectionName) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('auth_token');

    final uri = Uri.parse('http://3.137.100.242:3000/api/v1/media');

    var request = http.MultipartRequest('POST', uri)
      ..headers['Authorization'] = 'Bearer $token'
      ..fields['model_type'] = modelType
      ..fields['model_id'] = modelId
      ..fields['collection_name'] = collectionName
      ..files.add(await http.MultipartFile.fromPath(
        'file',
        file.path,
        contentType: MediaType('image', 'webp'),
      ));

    try {
      final response = await request.send();

      if (response.statusCode == 200) {
        print('Archivo enviado exitosamente.');
      } else {
        final responseBody = await response.stream.bytesToString();
        print('Error al enviar el archivo: ${response.statusCode}');
        print('Respuesta del servidor: $responseBody');
      }
    } on http.ClientException catch (e) {
      print('ClientException: $e');
    } catch (e) {
      print('Error al enviar la solicitud: $e');
    }
  }

  Future<void> saveFormData(
      String date, String observations, List<File> images, idTicket) async {
    String apiUrl =
        'http://3.137.100.242:3000/api/v1/tickets/${idTicket}'; // Reemplaza con tu endpoint real
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('auth_token');

    DateFormat dateFormat = DateFormat("yyyy-MM-dd'T'HH:mm:ss");
    DateTime dateTime = dateFormat.parse(date.replaceAll('/', '-'));

    print("DateTime: $dateTime");

    // Crea el cuerpo de la solicitud
    Map<String, dynamic> formData = {
      'diagnosis_date':
          dateFormat.format(dateTime), // Convierte el DateTime a String
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

        Fluttertoast.showToast(
            msg: "Datos guardados exitosamente",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.green,
            textColor: Colors.white,
            fontSize: 16.0);
        // Enviar imágenes
        for (File image in images) {
          await sendFile(image, 'Ticket', idTicket.toString(), 'diagnostic');
        }
      } else {
        Fluttertoast.showToast(
            msg: "Error al guardar los datos",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
        print('Respuesta del servidor: ${response.body}');
      }
    } catch (e) {
      Fluttertoast.showToast(
          msg: "Error al enviar la solicitud",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  Future<void> savecloseTicketFormData(
      String date, String observations, List<File> images, idTicket) async {
    String apiUrl =
        'http://3.137.100.242:3000/api/v1/tickets/${idTicket}'; // Reemplaza con tu endpoint real
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('auth_token');

    DateFormat dateFormat = DateFormat("yyyy-MM-dd'T'HH:mm:ss");
    DateTime dateTime = dateFormat.parse(date.replaceAll('/', '-'));

    print("DateTime: $dateTime");
    //print("DateTime: $dateTime");

    // Crea el cuerpo de la solicitud
    Map<String, dynamic> formData = {
      'solution_date': dateFormat.format(dateTime),
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
        // Enviar imágenes
        for (File image in images) {
          await sendFile(image, 'Ticket', idTicket.toString(), 'diagnostic');
        }
        Fluttertoast.showToast(
            msg: "Datos guardados exitosamente",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.green,
            textColor: Colors.white,
            fontSize: 16.0);
      } else {
        Fluttertoast.showToast(
            msg: "Error al guardar los datos",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
        print('Respuesta del servidor: ${response.body}');
      }
    } catch (e) {
      Fluttertoast.showToast(
          msg: "Error al enviar la solicitud",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }
}
