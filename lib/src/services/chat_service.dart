import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ChatService {
  final String apiUrl =
      "http://3.137.100.242:3000/api/v1/comments?commentable_type=Ticket&commentable_id=81"; // URL del endpoint ficticio

  Future<List<String>> getMessages() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('auth_token');
    final response = await http.get(
      Uri.parse('${apiUrl}commentable_type=Ticket&commentable_id=81'),
      headers: {"Content-Type": "application/json",'Authorization': 'Bearer $token',},
    );

    if (response.statusCode == 200) {
      List<dynamic> messagesJson = jsonDecode(response.body);
      return messagesJson.map((message) => message.toString()).toList();
    } else {
      throw Exception('Failed to load messages');
    }
  }

  Future<void> sendMessage(String message) async {
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"message": message}),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to send message');
    }
  }
}
