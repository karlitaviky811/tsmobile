import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_neat_and_clean_calendar/neat_and_clean_calendar_event.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

Future<List<NeatCleanCalendarEvent>> fetchTechnicalVisits() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  String? token = prefs.getString('auth_token');

  final response = await http
      .get(Uri.parse('http://3.137.100.242:3000/api/v1/technical-visits?ticket_id=320'), headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },);

  if (response.statusCode == 200) {
    List<dynamic> data = json.decode(response.body);
    return data.map((eventData) {
      return NeatCleanCalendarEvent(
        eventData['title'],
        description: eventData['description'],
        startTime: DateTime.parse(eventData['visit_date']),
        endTime: DateTime.parse(eventData['visit_date']),
        color: Colors.orange,
      );
    }).toList();
  } else {
    throw Exception('Error al cargar las visitas del técnico');
  }
}
