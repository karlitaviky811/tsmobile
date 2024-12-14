// lib/src/models/notifications_model.dart
class NotificationTicket {
  final String id;
  final String title;
  final String description;
  final DateTime date;
  final String status; // Añadimos el campo de estado

  NotificationTicket({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
    required this.status, // Añadimos el campo de estado al constructor
  });

  factory NotificationTicket.fromJson(Map<String, dynamic> json) {
    return NotificationTicket(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      date: DateTime.parse(json['date']),
      status: json['status'], // Añadimos el campo de estado
    );
  }
}
