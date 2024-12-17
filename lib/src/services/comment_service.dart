import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Comment {
  final String text;
  final DateTime time;

  Comment({required this.text, required this.time});

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
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

class CommentService {
  final String apiUrl =
      "http://3.137.100.242:3000/api/v1/comments?";

  Future<List<Comment>> fetchComments() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('auth_token');
    final response = await http.get(
      Uri.parse('${apiUrl}commentable_type=Ticket&commentable_id=81'),
      headers: {
        "Content-Type": "application/json",
        'Accept':'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> jsonResponse = jsonDecode(response.body);

      if (jsonResponse.containsKey('data')) {
        List<dynamic> data = jsonResponse['data'];
        return data.map((json) => Comment.fromJson(json)).toList();
      } else {
        throw Exception('La clave "data" no existe en el JSON de respuesta.');
      }
    } else {
      throw Exception(
          'Error al obtener los comentarios: ${response.statusCode}');
    }
  }

  Future<void> sendComment(Comment comment) async {

    final message = {
      'comment' : 'Hasta que se envie',
      'commentable_type': 'Ticket',
      'commentable_id' : 81
    };
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {
        'Content-Type': 'application/json',
        'Accept':'application/json',
      },
      body: jsonEncode(message),
    );

    if (response.statusCode != 200) {
      throw Exception('Error al enviar el comentario');
    }
  }
}
