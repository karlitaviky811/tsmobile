import 'dart:convert';
import 'package:http/http.dart' as http;

Future<void> makeAuthenticatedRequest() async {
  final String url = 'http://technical-service.test/api/v1/api/login';
  final String token = 'your_token_here';  // Reemplaza esto con tu token

  // Encabezados
  Map<String, String> headers = {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer $token',  // Agregar el token aquí
  };

  // Cuerpo de la solicitud
  Map<String, String> body = {
    'username': 'your_username',
    'password': 'your_password',
  };

  // Hacer la solicitud POST
  try {
    final response = await http.post(
      Uri.parse(url),
      headers: headers,
      body: jsonEncode(body),
    );

    if (response.statusCode == 200) {
      print('Solicitud exitosa: ${response.body}');
    } else {
      print('Error en la solicitud: ${response.statusCode}');
    }
  } catch (e) {
    print('Error al hacer la solicitud: $e');
  }
}



 