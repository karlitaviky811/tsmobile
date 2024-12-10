import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tsmobile/src/core/theme/app.styles.dart';
import 'package:tsmobile/src/providers/geolocation_provider.dart';
import 'package:tsmobile/src/services/map_coordinates.dart';
import 'package:tsmobile/src/widgets/new_ticket_detail_client_info.dart';
import 'package:http/http.dart' as http;
import 'location_map_distance.dart';

class TicketDetailPageView extends StatefulWidget {
  static const String route = 'detail-view-ticket-route';

  final dynamic item;
  const TicketDetailPageView({super.key, this.item});

  @override
  _TicketDetailPageState createState() => _TicketDetailPageState();
}

class _TicketDetailPageState extends State<TicketDetailPageView> {
  String _status = 'pending';
  String _selectedReason = 'No especificado';

  TextEditingController _dateController = TextEditingController();
  TextEditingController _notesController = TextEditingController();
  DateTime? _selectedDate;

  final List<String> _rejectionReasons = [
    'Cliente no disponible',
    'Información insuficiente',
    'Problema fuera de alcance',
    'Lugar de destino lejano',
    'Solicitud cancelada',
    'Equipo no se puede reparar',
    'No especificado'
  ];
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
      final idTicket = widget.item.serviceCallId.toString();
      String? token = prefs.getString('auth_token');
      final response = await http.put(
        Uri.parse('http://3.137.100.242:3000/api/v1/tickets/${idTicket}'),
        headers: {
          "Content-Type": "application/json",
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(data),
      );

      if (response.statusCode == 200) {
        print("Detalles guardados con éxito");
        // Acciones adicionales después de guardar
      } else {
        print("Error al guardar los detalles: ${response.body}");
      }
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
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final idTicket = widget.item.serviceCallId.toString();
      String? token = prefs.getString('auth_token');
      final response = await http.put(
        Uri.parse('http://3.137.100.242:3000/api/v1/tickets/${idTicket}'),
        headers: {
          "Content-Type": "application/json",
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(data),
      );

      if (response.statusCode == 200) {
        print("Detalles guardados con éxito");
        // Acciones adicionales después de guardar
      } else {
        print("Error al guardar los detalles: ${response.body}");
      }
    } catch (e) {
      print("Error al conectar con el servidor: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final item = widget.item;
    //GeolocationInfo gelocation = Provider.of<GeolocationInfo>(context);

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
      body: SingleChildScrollView(
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
                          code: item.serviceCallId.toString(),
                          clientName: item.customerName,
                          status: item.status.toString(),
                          type: 'Reparación',
                          title: item.title,
                          description: item.serviceCallDetail['U_DK_QUEJA'],
                          creationDateTime: item.createdAt,
                          location: 'Cambiar formato de coordenadas',
                          product: item.serviceCallDetail['itemName'],
                          brand: 'Hyundai')),
                  const SizedBox(height: 10),
                  LocationMapDistance(
                    initialCoordinates: const LatLng(10.254027777778,
                        -68.010855555556), // Coordenadas de San Francisco
                    destinationCoordinates: LatLng(
                        double.parse(item.serviceCallDetail['latitude']),
                        double.parse(item.serviceCallDetail[
                            'longitude'])), // Coordenadas de Los Ángeles
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
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xff051937),
                          // Cambia este color al que desees onPrimary: Colors.white, // Color del texto del botón
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
      ),
    );
  }

  Widget buildAcceptedForm() {
    return SingleChildScrollView(
      child: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('Programar visita ticket aceptado:',
                style: AppStyle.txtPoppinsRegular18Black),
            TextField(
              controller: _dateController,
              readOnly: true,
              decoration: const InputDecoration(
                labelText: 'Fecha de inicio',
              ),
              onTap: () => _selectDate(context),
              style: AppStyle.txtPoppinsRegular14Black,
            ),
            TextField(
              controller: _notesController,
              decoration: const InputDecoration(labelText: 'Notas adicionales'),
              style: AppStyle.txtPoppinsRegular14Black,
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              icon: const Icon(Icons.save, size: 18, color: Colors.white),
              onPressed: _saveDetails,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xff051937),
              ),
              label: Text('Guardar', style: AppStyle.txtPoppinsMedium14White),
            ),
          ],
        ),
      ),
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
