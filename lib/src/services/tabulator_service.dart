import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tsmobile/src/models/tabulator_model.dart';

class TabulatorService {
  final String _baseUrl = 'http://3.137.100.242:3000/api/v1/tabulators';

  Future<Map<String, dynamic>?> fetchTabulators( {required int page, required int ticketId}) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('auth_token');
      final response = await http.get(Uri.parse('http://3.137.100.242:3000/api/v1/tabulators?filter[by_ticket_id]=$ticketId&perPage=200'), headers: {
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
