import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tsmobile/src/core/theme/app.styles.dart';
import 'package:tsmobile/src/features/main/screens/card_detail_ticket.dart';
import 'package:tsmobile/src/features/main/screens/chat_screen.dart';
import 'package:tsmobile/src/features/main/screens/detail_ticket_accept_decline_view.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';

import 'package:tsmobile/src/interfaces/ticket.dart';
import 'package:tsmobile/src/widgets/cliente_direccion_card.dart';

import 'package:tsmobile/src/widgets/repair_log_form.dart';
import 'package:tsmobile/src/widgets/ticket_detail_card.dart';

import '../../../widgets/diagnostic_log_ticket.dart';

class TicketAcceptedProgressDetailPage extends StatefulWidget {
  final Ticket ticket;
  static const String route = 'ticket-accepted-decline-ticket-route';
  const TicketAcceptedProgressDetailPage({super.key, required this.ticket});

  @override
  _TicketDetailPageState createState() => _TicketDetailPageState();
}

class _TicketDetailPageState extends State<TicketAcceptedProgressDetailPage> {
  // bool _needsReplacement = false;
  DateTime? _selectedDate;
  //final _inputController1 = TextEditingController();
  //final _inputController2 = TextEditingController();
  //final _replacementCodeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> reparaciones = [
      // Ejemplo de datos iniciales provenientes del backend
      {
        'titulo': 'Cambio de pantalla',
        'estado': 'Solicitud de Repuesto',
        'selectedDate': DateTime.now(),
        'selectedServicios': ['Revisión general'],
        'necesitaRepuesto': true,
        'selectedRepuestos': ['Pantalla'],
        'presupuestoRepuesto': '',
        'comentarios': '',
        'imagenSolicitud': '',
        'imagenPresupuesto': '',
        'imagenReparacion': '',
        'comentariosGenerales': '',
        'presupuestoAceptado': false,
        'nombreRepuesto': '',
        'precioRepuesto': '',
        'repuestoSolicitado': false,
        'estadoCompraRepuesto': 'Enviada',
      }
    ];

    void _agregarNuevaReparacion() {
      setState(() {
        reparaciones.add({
          'titulo': '',
          'estado': 'Solicitud de Repuesto',
          'selectedDate': null,
          'selectedServicios': <String>[],
          'necesitaRepuesto': false,
          'selectedRepuestos': <String>[],
          'presupuestoRepuesto': '',
          'comentarios': '',
          'imagenSolicitud': '',
          'imagenPresupuesto': '',
          'imagenReparacion': '',
          'comentariosGenerales': '',
          'presupuestoAceptado': false,
          'nombreRepuesto': '',
          'precioRepuesto': '',
          'repuestoSolicitado': false,
          'estadoCompraRepuesto': 'Enviada',
        });
      });
    }

    final ValueNotifier<void> reparacionesNotifier = ValueNotifier(null);
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ChatScreen()),
            );
          },
          child: const Icon(
            Icons.chat_rounded,
            color: Colors.blueAccent,
          ),
          backgroundColor: Colors.white,
        ),
        appBar: AppBar(
          /*leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),*/
          backgroundColor: const Color(0xffF3F5FD),
          title: Text('Detalles del Ticket',
              style: TextStyle(
                  fontFamily: 'Poppins', fontSize: 18, color: Colors.black)),
          bottom: const TabBar(
            tabs: [
              Tab(
                text: 'General',
              ),
              Tab(
                text: 'Evaluación',
              ),
              Tab(
                text: 'Reparación',
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            const _TicketDetailProgress(),
            DiagnosticForm(
              onSave: (DateTime? date, String observations, String comments) {
                print('Fecha: $date');
                print('Observaciones: $observations');
                print('Comentarios: $comments');
              },
            ),
            RepairLogFormData(initialReparaciones: reparaciones),
          ],
        ),
      ),
    );
  }

  Widget _buildDatePicker() {
    return ListTile(
      title: Text(_selectedDate == null
          ? 'Seleccionar Fecha'
          : 'Fecha: ${_selectedDate!.toLocal()}'.split(' ')[0]),
      trailing: const Icon(Icons.calendar_today),
      onTap: () async {
        DateTime? picked = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(2000),
          lastDate: DateTime(2101),
        );
        if (picked != null && picked != _selectedDate) {
          setState(() {
            _selectedDate = picked;
          });
        }
      },
    );
  }

  Widget _buildDropdown(String hint, List<String> options) {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        labelText: hint,
        border: const OutlineInputBorder(),
      ),
      items: options.map((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      onChanged: (newValue) {
        // Lógica para manejar el cambio
      },
    );
  }
}

class _TicketDetailProgress extends StatelessWidget {
  const _TicketDetailProgress({
    super.key,
  });


  @override
  Widget build(BuildContext context) {

      final String initialLocation = 'Calle 123, Ciudad, País';
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          Expanded(
            child: ListView(
              children: [
                TicketDetailCard(
                  headerTitle: 'Ticket de Servicio',
                  code: 'TICKET12345',
                  clientName: 'Juan Pérez',
                  status: 'En Proceso',
                  type: 'Reparación',
                  creationDate: '2024-11-18',
                  title: 'Reparación del Aire Acondicionado',
                  description:
                      'El aire acondicionado no enfría adecuadamente y hace ruido.',
                ),
                const SizedBox(
                  height: 20,
                ),
                TicketDetailCard(
                  headerTitle: 'Dirección del cliente',
                  code: 'TICKET12345',
                  clientName: 'Juan Pérez',
                  status: 'En Proceso',
                  type: 'Reparación',
                  creationDate: '2024-11-18',
                  title: 'Reparación del Aire Acondicionado',
                  description:
                      'El aire acondicionado no enfría adecuadamente y hace ruido.',
                ),
                LocationHandler(initialLocation: initialLocation)
                // Más apartados como Prueba y Cierre pueden ser añadidos aquí...
              ],
            ),
          ),
        ],
      ),
    );
  }
}





class LocationHandler extends StatefulWidget {
  final String initialLocation;

  LocationHandler({required this.initialLocation});

  @override
  _LocationHandlerState createState() => _LocationHandlerState();
}

class _LocationHandlerState extends State<LocationHandler> {
  late String location;

  @override
  void initState() {
    super.initState();
    location = widget.initialLocation;
  }

  void _updateLocation(String newLocation) {
    setState(() {
      location = newLocation;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: EditTicketDetailCard(
        code: 'TICKET12345',
        clientName: 'Juan Pérez',
        status: 'Creada',
        type: 'Reparación',
        title: 'Problema con el aire acondicionado',
        description: 'El aire acondicionado no enfría adecuadamente.',
        location: location,
        product: 'Aire acondicionado',
        brand: 'Samsung',
        creationDateTime: DateTime.now(),
        onLocationChanged: _updateLocation,
      ),
    );
  }
}
