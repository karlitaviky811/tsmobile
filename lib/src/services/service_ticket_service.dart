import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tsmobile/src/models/tickets_model.dart';

const String apiUrl =
    'http://3.137.100.242:3000/api/v1/tickets?include=serviceCall';

class TicketService {
  Future<List<ServiceTicket>> fetchServiceTickets() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('auth_token');
      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization':
              'Bearer $token', // Asegúrate de reemplazar con tu token real
        },
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> jsonResponse = jsonDecode(response.body);
        List<dynamic> data = jsonResponse['data'];
        return data.map((item) => ServiceTicket.fromJson(item)).toList();
      } else {
        throw Exception('Failed to load service tickets');
      }
    } catch (e) {
      throw Exception('Error fetching service tickets: $e');
    }
  }

 Future<ServiceTicket> fetchServiceTicketById(idTicket) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('auth_token');
      final response = await http.get(
        Uri.parse('http://3.137.100.242:3000/api/v1/tickets/$idTicket?include=serviceCall'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> jsonResponse = jsonDecode(response.body);
        Map<String, dynamic> data = jsonResponse['data'];
        print('data $data');
        
        return ServiceTicket.fromJson(data);
      } else {
        throw Exception('Failed to load service ticket');
      }
    } catch (e) {
      throw Exception('Error fetching service ticket: $e');
    }
  }


  Future<dynamic> updateTickets(idTicket, data, token) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('auth_token');
      final response = await http.put(
        Uri.parse('http://3.137.100.242:3000/api/v1/tickets/${idTicket}'),
        headers: {
          "Content-Type": "application/json",
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(data),
      );

      if (response.statusCode == 200) {
        print("Detalles guardados con éxito $data");
        // Acciones adicionales después de guardar
      } else {
        print("Error al guardar los detalles: ${response.body}");
      }
    } catch (e) {
      print("Error al conectar con el servidor: $e");
    }
  }
}


