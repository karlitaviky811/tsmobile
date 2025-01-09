import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tsmobile/src/models/message_send.dart';
import 'package:tsmobile/src/models/messages_model.dart';

class MessageService {
  final String apiUrl = '${dotenv.env['API_URL']}comments';

  Future<List<Message>> fetchMessages(String commentableType, int commentableId) async {
    final response = await _getRequest(
      '$apiUrl?commentable_type=$commentableType&commentable_id=$commentableId'
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> jsonResponse = jsonDecode(response.body);

      if (jsonResponse.containsKey('data')) {
        List<dynamic> data = jsonResponse['data'];
        print('Datos obtenidos: $data');
        return data.map((json) => Message.fromJson(json)).toList();
      } else {
        throw Exception('La clave "data" no existe en el JSON de respuesta.');
      }
    } else {
      print('Error al obtener los mensajes: ${response.statusCode}');
      throw Exception('Error al obtener los mensajes: ${response.statusCode}');
    }
  }

  Future<void> sendMessage(MessageSend message) async {
    final response = await _postRequest(apiUrl, message.toJson());

    if (response.statusCode != 200) {
      print('Error al enviar el mensaje: ${response.statusCode}');
      print('Respuesta del servidor: ${response.body}');
      throw Exception('Error al enviar el mensaje');
    }
  }

  Future<http.Response> _getRequest(String url) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('auth_token');
    
    if (token == null) {
      print('No se encontró el token de usuario');
      throw Exception('No se encontró el token de usuario');
    }

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );
      return response;
    } catch (e) {
      throw Exception('Failed to make GET request: $e');
    }
  }

  Future<http.Response> _postRequest(String url, Map<String, dynamic> body) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('auth_token');

    if (token == null) {
      print('No se encontró el token de usuario');
      throw Exception('No se encontró el token de usuario');
    }

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode(body),
      );
      return response;
    } catch (e) {
      throw Exception('Failed to make POST request: $e');
    }
  }
}
