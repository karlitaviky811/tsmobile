import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:tsmobile/src/core/theme/app.styles.dart';
import 'package:tsmobile/src/providers/tikets_provider.dart';
import 'package:tsmobile/src/providers/visit_provider.dart';
import 'package:tsmobile/src/providers/visit_provider.dart';
import 'package:tsmobile/src/services/tecnical_visitis_service.dart';

import '../models/visit_model.dart';

class TicketDetailCard extends StatefulWidget {
  final String headerTitle;
  final String code;
  final String id;
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
    required this.id,
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
  final visitService = new VisitService();
  DateTime? _selectedDate;
  TextEditingController _dateController = TextEditingController();
  TextEditingController _notesController = TextEditingController();

  @override
  void initState() {
    super.initState();
    //Aquiii
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
      case '1':
        statusColor = const Color.fromARGB(255, 49, 145, 224);
        break;
      case '2':
        statusColor = const Color.fromARGB(108, 224, 49, 131);
        break;
      case '3':
        statusColor = const Color.fromARGB(188, 138, 140, 233);
        break;
      case '4':
        statusColor = const Color.fromARGB(150, 230, 107, 36);
        break;
      case '5':
        statusColor = const Color.fromARGB(143, 80, 37, 87);
        break;
      case '6':
        statusColor = const Color.fromARGB(101, 89, 68, 180);
        break;
      case '7':
        statusColor = const Color.fromARGB(148, 21, 201, 147);
        break;
      default:
        statusColor = Colors.grey.shade100;
    }

    IconData _getChipIcon(String estado) {
      switch (estado) {
        case '1':
          return Icons.create;
        case '2':
          return Icons.check_circle;
        case '3':
          return Icons.work;
        case '4':
          return Icons.done;
        case '5':
          return Icons.pause;
        case '6':
          return Icons.cancel_schedule_send;
        case '7':
          return Icons.done_all;
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
      label: Text(getStatusFromNumber(int.parse(status))),
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

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _dateController.text = DateFormat.yMd().format(picked);
      });
    }
  }

  void _saveDetails() async {
    final visitProvider = Provider.of<VisitProvider>(context, listen: false);
    final ticketProvider = Provider.of<TicketProvider>(context, listen: false);
    await visitProvider.fetchVisitsByTicket(widget.id);

    var finalIdVisit = visitProvider.visits[0].id;
    DateTime dateTime = DateFormat('MM/dd/yyyy').parse(_dateController.text);
    Map<String, dynamic> data = {
      "new_date": DateFormat('yyyy-MM-dd HH:mm:ss').format(dateTime).toString(),
      "extend_reason": _notesController.text,
      "reason": "3"
    };

    Visit? visit = await visitService.sendDataVisitReprogramming(
        data, finalIdVisit.toString());
    await visitProvider.fetchVisitsByTicket(widget.id);
    await ticketProvider.loadTicketById(widget.id);

    if (visit != null) {
      // Maneja la visita recibida en la respuest
      print('Visita recibida: ${visit.title}');
    } else {
      print('Error al enviar y recibir la visita.');
    }

    Navigator.pop(context);
  }

  String getStatusFromNumber(int number) {
    switch (number) {
      case 1:
        return 'Nuevo';
      case 2:
        return 'Cerrado por el técnico';
      case 3:
        return 'Rechazado';
      case 4:
        return 'En proceso';
      case 5:
        return 'En en pausa';
      case 6:
        return 'Ticket Cancelado (Por el cliente)';
      case 7:
        return 'Resuelto por el técnico'; // Puede agregar cualquier otro estado aquí si es necesario
      default:
        return 'Número inválido';
    }
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
            icon: const Icon(Icons.calendar_today),
            onPressed: () => _showAcceptedFormModal(context),
          ),
        ],
      ),
    );
  }

  void _showAcceptedFormModal(BuildContext context) {
    bool _isSaveButtonEnabled = false;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            void _validateModalForm() {
              setModalState(() {
                _isSaveButtonEnabled = _dateController.text.isNotEmpty &&
                    _notesController.text.isNotEmpty;
              });
            }

            return Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text('Agendar Visita', style: AppStyle.txtPoppinsBold14Black),
                  const SizedBox(height: 10),
                  const Text('Programar primera visita'),
                  TextField(
                    controller: _dateController,
                    decoration: InputDecoration(
                      labelText: 'Fecha de inicio',
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.calendar_today),
                        onPressed: () => _selectDate(context),
                      ),
                    ),
                    readOnly: true,
                    onChanged: (text) => _validateModalForm(),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _notesController,
                    decoration:
                        const InputDecoration(labelText: 'Notas adicionales'),
                    maxLines: null,
                    onChanged: (text) => _validateModalForm(),
                  ),
                  DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                      labelText: 'Motivo de Reprogramación',
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
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: _isSaveButtonEnabled ? _saveDetails : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xff051937),
                    ),
                    child: Text('Guardar',
                        style: AppStyle.txtPoppinsMedium14White),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
