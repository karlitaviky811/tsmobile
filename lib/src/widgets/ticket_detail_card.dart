import 'package:flutter/material.dart';
import 'package:glass/glass.dart';
class TicketDetailCard extends StatelessWidget {
  final String headerTitle;
  final String code;
  final String clientName;
  final String status;
  final String type;
  final String creationDate;
  final String title;
  final String description;

  //obligatorio por el reuired , no posicional
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
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Stack(
          children: [
            Positioned(
              right: 0,
              top: 0,
              child: _buildStatusChip(status),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  headerTitle,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                _buildDetailRow('Código:', code),
                _buildDetailRow('Cliente:', clientName),
                _buildDetailRow('Tipo:', type),
                _buildDetailRow('Fecha de Creación:', creationDate),
                _buildDetailRow('Título:', title),
                const Text(
                  'Descripción:',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Text(description, style: const TextStyle(fontSize: 14)),
              ],
            ),
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
          Text(
            '$label ',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          Expanded(child: Text(value, style: const TextStyle(fontSize: 16))),
        ],
      ),
    );
  }

  Widget _buildStatusChip(String status) {
    Color statusColor;
    switch (status) {
      case 'Creada':
        statusColor = const Color.fromARGB(255, 49, 145, 224);
        break;
      case 'Nuevo':
        statusColor = const Color.fromARGB(108, 224, 49, 131);
        break;
      case 'Aprobada':
        statusColor = const Color.fromARGB(188, 138, 140, 233);
        break;
      case 'En Proceso':
        statusColor = const Color.fromARGB(150, 230, 107, 36);
        break;
      case 'Resuelto':
        statusColor = const Color.fromARGB(143, 80, 37, 87);
        break;
      case 'Cerrado':
        statusColor = const Color.fromARGB(148, 21, 201, 147);
        break;
      default:
        statusColor = Colors.grey.shade100;
    }

    IconData _getChipIcon(String estado) {
      switch (estado) {
        case 'Creada':
          return Icons.create;
        case 'Aprobada':
          return Icons.check_circle;
        case 'En proceso':
          return Icons.work;
        case 'Resuelto':
          return Icons.done;
        case 'Cerrado':
          return Icons.close;
        default:
          return Icons.info;
      }
    }

    return Chip(
      label: Text(status),
      backgroundColor: statusColor,
      avatar: Icon(
        _getChipIcon(status),
        color: Colors.white,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(25.0),
        side: const BorderSide(color: Colors.transparent),
      ),
    );
  }
}
