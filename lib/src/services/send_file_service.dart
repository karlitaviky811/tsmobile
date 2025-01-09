import 'dart:convert';
import 'dart:io';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http_parser/http_parser.dart';

class FileService {
  final String apiUrl = '${dotenv.env['API_URL']}media';

  Future<bool> sendFile(File file, String modelType, String modelId, String collectionName) async {
    return await _sendMultipartRequest(file, modelType, modelId, collectionName);
  }

  Future<bool> sendFileSpareParts(File file, String modelType, String modelId, String collectionName) async {
   return await _sendMultipartRequest(file, modelType, modelId, collectionName);
  }

  Future<bool> _sendMultipartRequest(File file, String modelType, String modelId, String collectionName) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('auth_token');

    if (token == null) {
      print('No se encontró el token de usuario');
      throw Exception('No se encontró el token de usuario');
    }

    final uri = Uri.parse(apiUrl);
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

      if (response.statusCode == 200 || response.statusCode == 201) {
        print('Archivo enviado exitosamente.');
        return true;
      } else {
        final responseBody = await response.stream.bytesToString();
        print('Error al enviar el archivo: ${response.statusCode}');
        print('Respuesta del servidor: $responseBody');
         return false;
      }
    } catch (e) {
      print('Error al enviar la solicitud: $e');
      throw Exception('Error al enviar la solicitud: $e');
      
    }
  }
}
