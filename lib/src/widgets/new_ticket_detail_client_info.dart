import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tsmobile/src/core/theme/app.styles.dart';

class NewTicketDetailCard extends StatelessWidget {
  final String code;
  final String clientName;
  final String status;
  final String type;
  final String title;
  final String description;
  final String location;
  final String product;
  final String brand;
  final String creationDateTime; // Cambiar a String

  NewTicketDetailCard({
    required this.code,
    required this.clientName,
    required this.status,
    required this.type,
    required this.title,
    required this.description,
    required this.location,
    required this.product,
    required this.brand,
    required DateTime creationDateTime, // Recibir como DateTime
  }) : creationDateTime = DateFormat.yMMMMd()
            .add_Hm()
            .format(creationDateTime); // Formatear a String

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

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      child: Padding(
        padding: EdgeInsets.all(16.0),
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
                _buildDetailRow('Código:', code),
                _buildDetailRow('Cliente:', clientName),
                _buildDetailRow('Tipo:', type),
                _buildDetailRow('Título:', title),
                _buildDetailRow('Fecha:', creationDateTime),
                _buildDetailRowLarge('Título:', title),
                _buildDetailRowLarge('Detalle:', description),
                _buildDetailRow('Ubicación:', location),
                _buildDetailRow('Producto:', product),
                _buildDetailRow('Marca:', brand),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRowLarge(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 100, // Ajusta el ancho según sea necesario
            child: Text(
              label,
              style: AppStyle.txtPoppinsBold14Black,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: AppStyle.txtPoppinsRegular14Black,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 100, // Ajusta el ancho según sea necesario
            child: Text(
              label,
              style: AppStyle.txtPoppinsBold14Black,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: AppStyle.txtPoppinsRegular14Black,
              overflow:
                  TextOverflow.ellipsis, // Añadir si deseas manejar texto largo
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusChip(String status) {
    Color statusColor;
    switch (status) {
      case 'Abierto':
        statusColor = const Color.fromARGB(255, 49, 145, 224);
        break;
      case 'Cerrado':
        statusColor = const Color.fromARGB(108, 224, 49, 131);
        break;
      case 'En Progreso':
        statusColor = const Color.fromARGB(188, 138, 140, 233);
        break;
      case 'Rechazado':
        statusColor = const Color.fromARGB(150, 230, 107, 36);
        break;
      case 'Bloqueado':
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
        case 'Abierto':
          return Icons.create;
        case 'Aprobada':
          return Icons.check_circle;
        case 'En Progreso':
          return Icons.work;
        case 'Resuelto':
          return Icons.done;
        case 'Cerrado':
          return Icons.close;
        default:
          return Icons.info;
      }
    }

    String _getChipLabel(String estado) {
      switch (estado) {
        case '1':
          return 'Abierto';
        case '2':
          return 'Cerrado';
        case '3':
          return 'Rechazado';
        case '4':
          return 'En Progreso';
        case '5':
          return 'Bloqueado';
        default:
          return 'Nuevo';
      }
    }

    return Chip(
      label: Text(_getChipLabel(status)),
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
