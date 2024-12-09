import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class User {
  final int id;
  final String name;
  final String email;
  final String geographicalcoordinates;
  final String nameComercial;
  final int ntickets;
  final int nrejectedtickets;
  final int qualification;
  final String address;
  User(
      {required this.id,
      required this.name,
      required this.email,
      required this.nameComercial,
      required this.ntickets,
      required this.nrejectedtickets,
      required this.qualification,
      required this.address,
      required this.geographicalcoordinates});
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
        id: json['id'],
        name: json['User_name'],
        email: json['Email'],
        nameComercial: json['Name_user_comercial'],
        ntickets: json['Tickets'],
        nrejectedtickets: json['Tickets_rejected'],
        qualification: json['Qualification'],
        address: json['Address'],
        geographicalcoordinates: json['GeographicalCoordinates']);
  }
}

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
    print('response $response');
    if (response.statusCode == 200) {
      Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      if (jsonResponse.containsKey('data')) {
        Map<String, dynamic> userJson =
            jsonResponse['data']; // Asegúrate de acceder al objeto JSON
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
  }
}
