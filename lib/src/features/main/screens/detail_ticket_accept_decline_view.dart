import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tsmobile/src/core/theme/app.styles.dart';
import 'package:tsmobile/src/providers/tikets_provider.dart';
import 'package:tsmobile/src/widgets/new_ticket_detail_client_info.dart';
import 'location_map_distance.dart';

class TicketDetailPageView extends StatefulWidget {
  static const String route = 'detail-view-ticket-route';

  final String ticketId;
  const TicketDetailPageView({super.key, this.ticketId = ''});

  @override
  _TicketDetailPageState createState() => _TicketDetailPageState();
}

class _TicketDetailPageState extends State<TicketDetailPageView> {
  String _status = 'pending';
  String _selectedReason = 'No especificado';
  late Future<void> _loadTicketFuture;

  TextEditingController _dateController = TextEditingController();
  TextEditingController _notesController = TextEditingController();
  DateTime? _selectedDate;
  void _saveDetails() async {
    // Lógica para enviar datos al endpoint
    if (_selectedDate == null) {
      print("Por favor, selecciona una fecha.");
      return;
    }

    final Map<String, dynamic> data = {
      'start_date': _selectedDate!.toIso8601String(),
      'additional_notes': _notesController.text,
      'status': 4,
    };

    print('programado $data');
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final idTicket = widget.ticketId.toString();
      String? token = prefs.getString('auth_token');
      final ticketProvider =
          Provider.of<TicketProvider>(context, listen: false);
      final item = ticketProvider.ticketInfo;
      _loadTicketFuture = ticketProvider.updateTicket(item!, data);

      print("Error al guardar los detalles:");
    } catch (e) {
      print("Error al conectar con el servidor: $e");
    }
  }

  void _saveDetailsRejected() async {
    // Lógica para enviar datos al endpoint

    final Map<String, dynamic> data = {
      'start_date': new DateTime.now().toIso8601String(),
      'additional_notes': _notesController.text,
      'status': 1,
    };

    print('programado $data');
    // Lógica para enviar datos al endpoint
 

    print('programado $data');
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final idTicket = widget.ticketId.toString();
      String? token = prefs.getString('auth_token');
      final ticketProvider =
          Provider.of<TicketProvider>(context, listen: false);
      final item = ticketProvider.ticketInfo;
      _loadTicketFuture = ticketProvider.updateTicket(item!, data);

      print("Error al guardar los detalles:");
    } catch (e) {
      print("Error al conectar con el servidor: $e");
    }
  }

  final List<String> _rejectionReasons = [
    'Cliente no disponible',
    'Información insuficiente',
    'Problema fuera de alcance',
    'Lugar de destino lejano',
    'Solicitud cancelada',
    'Equipo no se puede reparar',
    'No especificado'
  ];

  @override
  void initState() {
    super.initState();
    final ticketProvider = Provider.of<TicketProvider>(context, listen: false);
    _loadTicketFuture = ticketProvider.loadTicketById(widget.ticketId);
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

  @override
  Widget build(BuildContext context) {
    final ticketProvider = Provider.of<TicketProvider>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xffF3F5FD),
        title: Text(
          'Detalle del Ticket',
          style: AppStyle.txtPoppinsRegular18Black,
        ),
        leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new),
            onPressed: () {
              Navigator.pop(context);
            }),
      ),
      body: FutureBuilder(
        future:
            _loadTicketFuture, // Utiliza el Future inicializado en initState
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final item = ticketProvider.ticketInfo;

            if (item == null) {
              return const Center(child: Text('No se encontró el ticket'));
            }

            return SingleChildScrollView(
              child: Container(
                color: Colors.white,
                child: Stack(children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Center(
                          child: NewTicketDetailCard(
                            code: item.serviceCallId?.toString() ?? 'N/A',
                            clientName: item.customerName ?? 'N/A',
                            status: item.status?.toString() ?? 'N/A',
                            type: 'Reparación',
                            title: item.title ?? 'N/A',
                            description: 'N/A', // Ajusta según sea necesario
                            creationDateTime: item.createdAt,
                            location: 'Cambiar formato de coordenadas',
                            product: 'N/A', // Ajusta según sea necesario
                            brand: 'Hyundai',
                          ),
                        ),
                        const SizedBox(height: 10),
                        LocationMapDistance(
                          initialCoordinates: const LatLng(10.254027777778,
                              -68.010855555556), // Coordenadas de San Francisco
                          destinationCoordinates: LatLng(
                              double.tryParse(
                                      item.serviceCallDetail?['latitude'] ??
                                          '0') ??
                                  0,
                              double.tryParse(
                                      item.serviceCallDetail?['longitude'] ??
                                          '0') ??
                                  0), // Coordenadas de Los Ángeles
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            ElevatedButton.icon(
                              icon: const Icon(Icons.check_box,
                                  size: 18, color: Colors.white),
                              onPressed: () {
                                setState(() {
                                  _status = 'accepted';
                                });
                                ticketProvider.acceptTicket(item);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xff051937),
                                // Cambia este color al que desees
                              ),
                              label: Text('Aceptar',
                                  style: AppStyle.txtPoppinsMedium14White),
                            ),
                            const SizedBox(width: 10),
                            ElevatedButton.icon(
                              icon: const Icon(Icons.report_problem,
                                  size: 18, color: Colors.white),
                              onPressed: () {
                                setState(() {
                                  _status = 'rejected';
                                });
                                ticketProvider.rejectTicket(item);
                              },
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xff051937)),
                              label: Text('Rechazar',
                                  style: AppStyle.txtPoppinsMedium14White),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        if (_status == 'accepted') buildAcceptedForm(),
                        if (_status == 'rejected') buildRejectedForm(),
                      ],
                    ),
                  ),
                ]),
              ),
            );
          }
        },
      ),
    );
  }

  Widget buildAcceptedForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
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
        ),
        const SizedBox(height: 10),
        TextField(
          controller: _notesController,
          decoration: const InputDecoration(labelText: 'Notas adicionales'),
          maxLines: null,
        ),
        const SizedBox(height: 10),
        ElevatedButton(
          onPressed: _saveDetails,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xff051937),
          ),
          child: Text('Guardar', style: AppStyle.txtPoppinsMedium14White),
        ),
      ],
    );
  }

  Widget buildRejectedForm() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text('Motivo del rechazo:', style: AppStyle.txtPoppinsRegular18Black),
          DropdownButton<String>(
            value: _selectedReason,
            onChanged: (String? newValue) {
              setState(() {
                _selectedReason = newValue!;
              });
            },
            items:
                _rejectionReasons.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
          TextFormField(
            decoration: const InputDecoration(labelText: 'Razón del rechazo'),
          ),
          const SizedBox(
            height: 20,
          ),
          ElevatedButton.icon(
            icon: const Icon(Icons.save, size: 18, color: Colors.white),
            onPressed: _saveDetailsRejected,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xff051937),
              // Cambia este color al que desees onPrimary: Colors.white, // Color del texto del botón
            ),
            label: Text('Guardar', style: AppStyle.txtPoppinsMedium14White),
          )
        ],
      ),
    );
  }
}

Widget getStatusChip(String status) {
  Color color;
  String text;
  //Color colorIcon;

  switch (status) {
    case 'pending':
      color = Colors.orange;
      text = 'Pendiente';
      break;
    case '3':
      color = const Color(0xffE0FFFF);
      text = 'Nuevo';
      break;
    case 'in_progress':
      color = const Color(0xffb0c2f2);
      text = 'En Proceso';
      break;
    case 'completed':
      color = const Color(0xffa07a);
      text = 'Completado';
      break;
    case 'canceled':
      color = const Color(0xffa07a);
      text = 'Cancelado';
      break;
    default:
      color = Colors.grey;
      text = 'Desconocido';
  }
  return Chip(
    label: Text(
      text,
      style: const TextStyle(
          fontStyle: FontStyle.normal,
          color: Colors.black,
          fontFamily: 'Poppins'),
    ),
    avatar: const Icon(
      Icons.sell, color: Colors.black, // Color del ícono
    ),
    shadowColor: Colors.grey[350],
    backgroundColor: color,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(100.0),
      side: BorderSide(
        color: color, // Cambiar el color del borde aquí
        width: 2.0, // Ancho del borde
      ),
    ),
  );
}
