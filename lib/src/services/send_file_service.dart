import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';
import 'package:http_parser/http_parser.dart';

Future<void> sendFile(File file, String modelType, String modelId, String collectionName) async {
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

    if (response.statusCode == 200 || response.statusCode == 201) {
      print('Archivo enviado exitosamente.');
    } else {
      final responseBody = await response.stream.bytesToString();
      print('Error al enviar el archivo: ${response.statusCode}');
      print('Respuesta del servidor: $responseBody');
    }
  } catch (e) {
    print('Error al enviar la solicitud: $e');
  }
}


Future<void> sendFileSpareParts(File file, String modelType, String modelId, String collectionName) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  String? token = prefs.getString('auth_token');
  print('modeltype: $modelType $collectionName');
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

    if (response.statusCode == 200 || response.statusCode == 201) {
      print('Archivo enviado exitosamente.');
    } else {
      final responseBody = await response.stream.bytesToString();
      print('Error al enviar el archivo: ${response.statusCode}');
      print('Respuesta del servidor: $responseBody');
    }
  } catch (e) {
    print('Error al enviar la solicitud: $e');
  }
}
