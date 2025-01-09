import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class TabulatorService {

  Future<Map<String, dynamic>?> fetchTabulators( {required int page, required int ticketId}) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('auth_token');
      final response = await http.get(Uri.parse('${dotenv.env['API_URL']}tabulators?filter[by_ticket_id]=$ticketId&perPage=200'), headers: {
        'Content-Type': 'application/json',
        "Accept": "application/json",
        'Authorization': 'Bearer $token',
      });

      if (response.statusCode == 200) {
        Map<String, dynamic> jsonResponse = jsonDecode(response.body);
        return jsonResponse;
      } else {
        print('Error fetching data: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error fetching data: $e');
      return null;
    }
  }
}
