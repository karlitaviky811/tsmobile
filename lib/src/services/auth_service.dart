import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {

  Future<Map<String, dynamic>> signIn(String email, String password) async {
    final response = await _postRequest('login', {"email": email, "password": password});
    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = jsonDecode(response.body);
      final String token = responseData['data']['token'];
      await saveToken(token);
      return responseData;
    } else {
      throw Exception('Failed to login: ${response.reasonPhrase}');
    }
  }

  Future<Map<String, dynamic>> register(String email, String password) async {
    final response = await _postRequest('register', {"email": email, "password": password});
    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = jsonDecode(response.body);
      final String token = responseData['data']['token'];
      await saveToken(token);
      return responseData;
    } else {
      throw Exception('Failed to register: ${response.reasonPhrase}');
    }
  }

  Future<void> saveToken(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);
  }

  Future<http.Response> _postRequest(String endpoint, Map<String, dynamic> body) async {
    try {
      final response = await http.post(
        Uri.parse('${dotenv.env['API_URL']}$endpoint'),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
        },
        body: jsonEncode(body),
      );
      return response;
    } catch (e) {
      throw Exception('Failed to make request: $e');
    }
  }
}
