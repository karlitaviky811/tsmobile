import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EditTicketDetailCard extends StatelessWidget {
  final String code;
  final String clientName;
  final String status;
  final String type;
  final String title;
  final String description;
  final String location;
  final String product;
  final String brand;
  final DateTime creationDateTime;
  final ValueChanged<String> onLocationChanged; // Usar ValueChanged<String>

  EditTicketDetailCard({
    required this.code,
    required this.clientName,
    required this.status,
    required this.type,
    required this.title,
    required this.description,
    required this.location,
    required this.product,
    required this.brand,
    required this.creationDateTime,
    required this.onLocationChanged,
  });

  Color _getChipColor(String status) {
    switch (status) {
      case 'Creada':
        return Colors.lightBlue.shade300;
      case 'Aprobada':
        return Colors.lightGreen.shade300;
      case 'En proceso':
        return Colors.deepOrange.shade200;
      case 'Resuelto':
        return Colors.deepPurple.shade200;
      case 'Cerrado':
        return Colors.pink.shade200;
      default:
        return Colors.grey.shade300;
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status) {
      case 'Creada':
        return Icons.check_circle_outline;
      case 'Aprobada':
        return Icons.thumb_up_alt_outlined;
      case 'En proceso':
        return Icons.sync;
      case 'Resuelto':
        return Icons.done_all;
      case 'Cerrado':
        return Icons.lock_outline;
      default:
        return Icons.info_outline;
    }
  }

  String _formatDate(DateTime date) {
    return DateFormat.yMMMMd().format(date);
  }

  String _formatTime(DateTime date) {
    return DateFormat.Hm().format(date);
  }

  void _editarUbicacion(BuildContext context, String currentLocation) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        TextEditingController locationController = TextEditingController(text: currentLocation);

        return AlertDialog(
          title: Text('Editar Ubicación'),
          content: TextField(
            controller: locationController,
            decoration: InputDecoration(
              hintText: 'Ingrese nueva dirección',
            ),
          ),
          actions: [
            TextButton(
              child: Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Guardar'),
              onPressed: () {
                onLocationChanged(locationController.text);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(16.0),
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Stack(
          children: [
            Positioned(
              right: 0,
              top: 0,
              child: Chip(
                label: Text(status, style: TextStyle(color: Colors.white)),
                backgroundColor: _getChipColor(status),
                avatar: Icon(_getStatusIcon(status), color: Colors.white),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                  side: BorderSide(color: Colors.transparent),
                ),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildDetailRow('Código:', code),
                _buildDetailRow('Cliente:', clientName),
                _buildDetailRow('Tipo:', type),
                _buildDetailRow('Título:', title),
                _buildDetailRow('Fecha:', _formatDate(creationDateTime)),
                _buildDetailRow('Hora:', _formatTime(creationDateTime)),
                SizedBox(height: 8),
                Text('Descripción:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                Text(description, style: TextStyle(fontSize: 16)),
                SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildDetailRow('Ubicación:', location),
                    IconButton(
                      icon: Icon(Icons.edit, color: Colors.blue),
                      onPressed: () => _editarUbicacion(context, location),
                    ),
                  ],
                ),
                _buildDetailRow('Producto:', product),
                _buildDetailRow('Marca:', brand),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('$label ', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          Expanded(child: Text(value, style: TextStyle(fontSize: 16))),
        ],
      ),
    );
  }
}
