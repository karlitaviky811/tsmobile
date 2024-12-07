import 'dart:convert';
import 'package:http/http.dart' as http;

class ChatService {
  final String apiUrl = "https://example.com/api/chat";  // URL del endpoint ficticio

  Future<List<String>> getMessages() async {
    final response = await http.get(Uri.parse(apiUrl));

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
