import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tsmobile/src/core/theme/app.styles.dart';

class TicketDetailCard extends StatefulWidget {
  final String headerTitle;
  final String code;
  final String clientName;
  final String status;
  final String type;
  final String creationDate;
  final String title;
  final String description;
  final DateTime scheduledVisit; // Añadimos el campo de visita programada

  // Constructor con required
  TicketDetailCard({
    required this.headerTitle,
    required this.code,
    required this.clientName,
    required this.status,
    required this.type,
    required this.creationDate,
    required this.title,
    required this.description,
    required this.scheduledVisit,
  });

  @override
  _TicketDetailCardState createState() => _TicketDetailCardState();
}

class _TicketDetailCardState extends State<TicketDetailCard> {
  late DateTime _scheduledVisit;
  String? _rescheduleReason;

  @override
  void initState() {
    super.initState();
    _scheduledVisit = widget.scheduledVisit;
  }

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
              child: _buildStatusChip(widget.status),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.headerTitle,
                  style: AppStyle.txtPoppinsSemiBold18Black,
                ),
                const SizedBox(height: 16),
                _buildDetailRow('Código:', widget.code),
                _buildDetailRow('Cliente:', widget.clientName),
                _buildDetailRow('Tipo:', widget.type),
                _buildDetailRow('Fecha:', widget.creationDate),
                _buildDetailRowLarge('Título:', widget.title),
                _buildDetailRowLarge('Detalle:', widget.description),
                _buildScheduledVisitRow(),
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
              overflow: TextOverflow.ellipsis, // Añadir si deseas manejar texto largo
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
        case 'Creada':
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
        case 'Abierto':
          return 'Abierto';
        case 'Cerrado':
          return 'Cerrado';
        case 'Rechazado':
          return 'Rechazado';
        case 'En Progreso':
          return 'En Progreso';
        case 'Bloqueado':
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

  Widget _buildScheduledVisitRow() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Container(
            width: 100,
            child: Text(
              'Visita programada:',
              style: AppStyle.txtPoppinsBold14Black,
            ),
          ),
          Expanded(
            child: Text(
              DateFormat('dd/MM/yyyy').format(_scheduledVisit),
              style: AppStyle.txtPoppinsRegular14Black,
            ),
          ),
          IconButton(
            icon: Icon(Icons.calendar_today),
            onPressed: () => _showDatePicker(context),
          ),
        ],
      ),
    );
  }

  void _showDatePicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
      ),
      builder: (BuildContext builder) {
        return FractionallySizedBox(
          heightFactor: 0.7, // Ajusta la altura según sea necesario
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Reprogramar Visita',
                  style: AppStyle.txtPoppinsBold14Black,
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    final DateTime? picked = await showDatePicker(
                      context: context,
                      initialDate: _scheduledVisit,
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2101),
                    );
                    if (picked != null && picked != _scheduledVisit) {
                      setState(() {
                        _scheduledVisit = picked;
                      });
                    }
                  },
                  child: Text('Seleccionar Fecha'),
                ),
                const SizedBox(height: 20),
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    labelText: 'Motivo de Reprogramación',
                    border: OutlineInputBorder(),
                  ),
                  items: ['Motivo 1', 'Motivo 2', 'Motivo 3']
                      .map((reason) => DropdownMenuItem<String>(
                            value: reason,
                            child: Text(reason),
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      _rescheduleReason = value;
                    });
                  },
                  value: _rescheduleReason,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    // Aquí puedes agregar la lógica para guardar la nueva fecha y el motivo
                  },
                  child: Text('Guardar'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
