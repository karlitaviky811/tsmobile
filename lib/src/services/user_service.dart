import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tsmobile/src/models/auth_model.dart';


class UserService {

  Future<User?> fetchUserData() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  String? token = prefs.getString('auth_token');

  const String url = 'http://3.137.100.242:3000/api/v1/user';

  try {
    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      if (jsonResponse.containsKey('data')) {
        Map<String, dynamic> userJson = jsonResponse['data'];
        return User.fromJson(userJson);
      } else {
        print('La clave "data" no existe en el JSON de respuesta.');
      }
    } else {
      print('Error al obtener el JSON: ${response.statusCode}');
    }
    return null;
  } catch (e) {
    print('Error fetching user data: $e');
    return null;
  }
}



}
