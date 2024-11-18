import 'package:flutter/material.dart';

class TicketDetailCard extends StatelessWidget {
  final String headerTitle;
  final String code;
  final String clientName;
  final String status;
  final String type;
  final String creationDate;
  final String title;
  final String description;

  TicketDetailCard({
    required this.headerTitle,
    required this.code,
    required this.clientName,
    required this.status,
    required this.type,
    required this.creationDate,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(16.0),
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(headerTitle, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 16),
            _buildDetailRow('Código:', code),
            _buildDetailRow('Cliente:', clientName),
            _buildStatusChip('Estatus:', status),
            _buildDetailRow('Tipo:', type),
            _buildDetailRow('Fecha de Creación:', creationDate),
            _buildDetailRow('Título:', title),
            Text('Descripción:', style: TextStyle(fontSize: 16)),
            Text(description, style: TextStyle(fontSize: 14)),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Text('$label ', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          Expanded(child: Text(value, style: TextStyle(fontSize: 16))),
        ],
      ),
    );
  }

  Widget _buildStatusChip(String label, String status) {
    Color statusColor;
    switch (status) {
      case 'Creada':
        statusColor = Colors.blue.shade100;
        break;
      case 'Aprobada':
        statusColor = Colors.green.shade100;
        break;
      case 'En proceso':
        statusColor = Colors.orange.shade100;
        break;
      case 'Resuelto':
        statusColor = Colors.purple.shade100;
        break;
      case 'Cerrado':
        statusColor = Colors.red.shade100;
        break;
      default:
        statusColor = Colors.grey.shade100;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Text('$label ', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          Chip(
            label: Text(status),
            backgroundColor: statusColor,
          ),
        ],
      ),
    );
  }
}

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Detalle del Ticket',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Detalle del Ticket'),
        ),
        body: Center(
          child: TicketDetailCard(
            headerTitle: 'Información del Ticket',
            code: 'TICKET12345',
            clientName: 'Juan Pérez',
            status: 'En proceso',
            type: 'Reparación',
            creationDate: '2024-11-18',
            title: 'Reparación del Aire Acondicionado',
            description: 'El aire acondicionado no enfría adecuadamente y hace ruido.',
          ),
        ),
      ),
    );
  }
}
