import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tsmobile/src/services/notification_service.dart';
import 'package:tsmobile/src/models/notifications_model.dart';

class NotificationListScreen extends StatelessWidget {
  final NotificationService _notificationService = NotificationService();

  IconData _getIconForStatus(String status) {
    switch (status) {
      case 'abierto':
        return Icons.info;
      case 'en progreso':
        return Icons.work;
      case 'cerrado':
        return Icons.check_circle;
      default:
        return Icons.notifications;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Notificaciones')),
      body: FutureBuilder<List<NotificationTicket>>(
        future: _notificationService.fetchNotifications(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            // Usa las notificaciones del endpoint o datos de prueba si está vacío o hay un error
            final notifications = snapshot.data ?? _notificationService.sampleNotifications;

            return ListView.builder(
              itemCount: notifications.length,
              itemBuilder: (context, index) {
                final notification = notifications[index];
                return ListTile(
                  leading: Icon(_getIconForStatus(notification.status)),
                  title: Text(notification.title),
                  subtitle: Text(
                    notification.description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  trailing: Text(DateFormat('dd/MM/yyyy HH:mm').format(notification.date)),
                  onTap: () {
                    // Manejar el evento al hacer clic en una notificación
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Clic en notificación: ${notification.title}')),
                    );
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
}

