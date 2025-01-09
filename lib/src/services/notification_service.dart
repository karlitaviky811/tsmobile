// lib/src/services/notification_service.dart
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:tsmobile/src/models/notifications_model.dart';
import 'package:http/http.dart' as http;

class NotificationService {
  final List<NotificationTicket> sampleNotifications = [
    NotificationTicket(
      id: '1',
      title: 'Nueva actualización del ticket',
      description: 'El ticket #123 ha sido actualizado.',
      date: DateTime.now().subtract(Duration(days: 1)),
      status: 'abierto',
    ),
    NotificationTicket(
      id: '2',
      title: 'Comentario en el ticket',
      description: 'Se ha añadido un nuevo comentario en el ticket #456.',
      date: DateTime.now().subtract(Duration(hours: 5)),
      status: 'en progreso',
    ),
    NotificationTicket(
      id: '3',
      title: 'Ticket cerrado',
      description: 'El ticket #789 ha sido cerrado.',
      date: DateTime.now(),
      status: 'cerrado',
    ),
  ];

  Future<List<NotificationTicket>> fetchNotifications() async {
    try {
      final response = await http.get(Uri.parse('${dotenv.env['API_URL']}notifications'));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        if (data.isNotEmpty) {
          return data.map((notification) => NotificationTicket.fromJson(notification)).toList();
        } else {
          // Si la respuesta es vacía, devuelve datos de prueba
          return sampleNotifications;
        }
      } else {
        // Si hay un error, devuelve datos de prueba
        return sampleNotifications;
      }
    } catch (e) {
      // Si ocurre una excepción, devuelve datos de prueba
      return sampleNotifications;
    }
  }
}
