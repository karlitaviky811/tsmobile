import 'dart:convert';
import 'package:http/http.dart' as http;

class Message {
  final String text;
  final DateTime time;

  Message({required this.text, required this.time});

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      text: json['text'],
      time: DateTime.parse(json['time']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'text': text,
      'time': time.toIso8601String(),
    };
  }
}

class ChatService {
  final String apiUrl = 'http://example.com/api/messages';

  Future<List<Message>> fetchMessages() async {
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = jsonDecode(response.body);
      return jsonResponse.map((json) => Message.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load messages');
    }
  }

  Future<void> sendMessage(Message message) async {
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(message.toJson()),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to send message');
    }
  }
}
