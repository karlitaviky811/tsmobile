import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  final String apiUrl =
      "http://3.137.100.242:3000/api/v1"; // URL del endpoint ficticio
  final String token = 'your_token_here';
  Future<Map<String, dynamic>> signIn(String email, String password) async {
    final response = await http.post(
      Uri.parse('$apiUrl/login'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "email": email,
        "password": password,
      }),
    );
      final Map<String, dynamic> responseData = jsonDecode(response.body);
      final String token = responseData['data']['token'];
      await saveToken(
          token);
    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = jsonDecode(response.body);
      final String token = responseData['data']['token'];
      await saveToken(
          token); // Asegúrate de que esta función guarde el token correctamente
      return responseData; // Devolvemos el mapa completo
    } else {
      throw Exception('Failed to login');
    }
  }

  Future<Map<String, dynamic>> register(String email, String password) async {
    final response = await http.post(
      Uri.parse('$apiUrl/register'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "email": email,
        "password": password,
      }),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = jsonDecode(response.body);
      final String token = responseData['data']['token'];
      saveToken(token);
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to register');
    }
  }

  Future<void> saveToken(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);
  }
}
