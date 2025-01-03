import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tsmobile/src/models/auth_model.dart';

class UserService {
  Future<User?> fetchUserData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('auth_token');

    const String url = 'http://3.137.100.242:3000/api/v1/user?ticketsCount=true&partRequestCount=true';

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
      Map<String, dynamic> jsonResponse = jsonDecode(response.body);

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
          nparts: 0,
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
          phone: '+58phone',
          nparts: 0,
          // añade más campos predeterminados si es necesario
          );
    }
  }

  Future<void> fetchUserDataUpdate(Map<String, dynamic> data) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('auth_token');

    const String url = 'http://3.137.100.242:3000/api/v1/user';

    try {
      final response = await http.post(Uri.parse(url),
          headers: {
            'Content-Type': 'application/json',
            "Accept": "application/json",
            'Authorization': 'Bearer $token',
          },
          body: jsonEncode(data));

      // Analizar la respuesta JSON
      Map<String, dynamic> jsonResponse = jsonDecode(response.body);

      // Validar el estado de la respuesta
      if (jsonResponse['success'] == true) {
  
          Fluttertoast.showToast(
            msg: "Se han actualizado los datos exitosamente",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.green,
            textColor: Colors.white,
            fontSize: 16.0,
          );
         
      } else {
        print('Error al obtener el JSON: ${response.statusCode}');
        Fluttertoast.showToast(
          msg: "Error al intentar actualizar",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      }
      Fluttertoast.showToast(
        msg: "Error al intentar actualizar",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      // Retornar objeto por defecto en caso de error en la respuesta
    } catch (e) {
      print('Error fetching user data: $e');

      // Retornar objeto por defecto en caso de excepción
      Fluttertoast.showToast(
        msg: "Error en la petición",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }
}
