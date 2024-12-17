import 'dart:convert';
import 'package:flutter/material.dart';
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
          "Accept": "application/json",
          'Authorization': 'Bearer $token',
        },
      );

      // Analizar la respuesta JSON
      Map<String, dynamic> jsonResponse  = jsonDecode(response.body);
      
      // Validar el estado de la respuesta
      if (jsonResponse['success'] == true) {
        if (jsonResponse.containsKey('data')) {
          Map<String, dynamic> userJson = jsonResponse['data'];
          return User.fromJson(userJson);
        } else {
          print('La clave "data" no existe en el JSON de respuesta.');
        }
      } else {
        print('Error al obtener el JSON: ${response.statusCode}');
      }

      // Retornar objeto por defecto en caso de error en la respuesta
      return User(
       id: 0,
        name: 'Default User',
        email: 'default@example.com',
        nameComercial: 'test',
        ntickets: 0,
        nrejectedtickets: 0,
        qualification: 0,
        address: 'test',
        geographicalcoordinates: '',
        latitude: '0.0',
        longitude: '0.0',
        phone: '+58phone'
        // añade más campos predeterminados si es necesario
      );
    } catch (e) {
      print('Error fetching user data: $e');
      
      // Retornar objeto por defecto en caso de excepción
      return User(
        id: 0,
        name: 'Default User',
        email: 'default@example.com',
        nameComercial: 'test',
        ntickets: 0,
        nrejectedtickets: 0,
        qualification: 0,
        address: 'test',
        geographicalcoordinates: '',
        latitude: '0.0',
        longitude: '0.0',
        phone: '+58phone'
        // añade más campos predeterminados si es necesario
      );
    }
  }
}
