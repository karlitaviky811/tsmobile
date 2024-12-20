import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tsmobile/src/models/message_send.dart';
import 'package:tsmobile/src/models/messages_model.dart';

class MessageService {
  final String apiUrl = 'http://3.137.100.242:3000/api/v1/comments';

  Future<List<Message>> fetchMessages(
      String commentableType, int commentableId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs
        .getString('auth_token'); // Obtén el token del almacenamiento local

    if (token == null) {
      print('No se encontró el token de usuario');
      throw Exception('No se encontró el token de usuario');
    }

    print('Token encontrado: $token');

    final response = await http.get(
      Uri.parse(
          '$apiUrl?commentable_type=$commentableType&commentable_id=$commentableId'),
      headers: {
        'Authorization': 'Bearer $token', // Agrega el token en las cabeceras
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    );

    print('Respuesta del servidor: ${response.body}');

    if (response.statusCode == 200) {
      Map<String, dynamic> jsonResponse = jsonDecode(response.body);

      if (jsonResponse.containsKey('data')) {
        List<dynamic> data = jsonResponse['data'];
        print('Datos obtenidos: $data'); // Añadir log para verificar datos
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
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('auth_token');

    if (token == null) {
      throw Exception('No se encontró el token de usuario');
    }

    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode(message.toJson()),
    );

    if (response.statusCode != 200) {
      print('Error al enviar el mensaje: ${response.statusCode}');
      print('Respuesta del servidor: ${response.body}');
      throw Exception('Error al enviar el mensaje');
    }
  }
}
