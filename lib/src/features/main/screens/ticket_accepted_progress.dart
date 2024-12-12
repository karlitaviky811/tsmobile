import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:tsmobile/src/features/main/screens/chat_service_screen.dart';
import 'package:tsmobile/src/interfaces/ticket.dart';
import 'package:tsmobile/src/providers/tikets_provider.dart';
import 'package:tsmobile/src/widgets/client_detail_card.dart';
import 'package:tsmobile/src/widgets/close_ticket_form.dart';
import 'package:tsmobile/src/widgets/repair_log_form.dart';
import 'package:tsmobile/src/widgets/ticket_detail_card.dart';
import '../../../widgets/diagnostic_log_ticket.dart';

class TicketAcceptedProgressDetailPage extends StatefulWidget {
  final String ticketId;
  static const String route = 'ticket-accepted-decline-ticket-route';
  const TicketAcceptedProgressDetailPage({super.key, this.ticketId = '0'});

  @override
  _TicketDetailPageState createState() => _TicketDetailPageState();
}

class _TicketDetailPageState extends State<TicketAcceptedProgressDetailPage> {
  // bool _needsReplacement = false;
  DateTime? _selectedDate;
  //final _inputController1 = TextEditingController();
  //final _inputController2 = TextEditingController();
  //final _replacementCodeController = TextEditingController();
  late Future<void> _loadTicketFuture;
  @override
  void initState() {
    super.initState();
    final ticketProvider = Provider.of<TicketProvider>(context, listen: false);
    _loadTicketFuture = ticketProvider.loadTicketById(widget.ticketId);
  }

  @override
  Widget build(BuildContext context) {
    final ticketProvider = Provider.of<TicketProvider>(context);

    List<Map<String, dynamic>> reparaciones = [
      // Ejemplo de datos iniciales provenientes del backend
      {
        'titulo': 'Cambio de pantalla',
        'estado': 'Solicitud de Repuesto',
        'selectedDate': DateTime.now(),
        'selectedServicios': ['Servicio 1'],
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
      },
      {
        'titulo': 'Cambio de antena',
        'estado': 'Sin stock',
        'selectedDate': DateTime.now(),
        'selectedServicios': ['Servicio 1'],
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
      },
      {
        'titulo': 'Cambio de antena',
        'estado': 'Sin stock',
        'selectedDate': DateTime.now(),
        'selectedServicios': ['Servicio 1', 'Servicio 2'],
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

    final ValueNotifier<void> reparacionesNotifier = ValueNotifier(null);
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ChatScreen(
                        ticketId: widget.ticketId,
                      )),
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
          leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new),
              onPressed: () {
                Navigator.pop(context);
              }),
          title: const Text('Detalles del Ticket',
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
              Tab(
                text: 'Cierre',
              ),
            ],
          ),
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

                return TabBarView(
                  children: [
                    _TicketDetailProgress(ticketInfo: item),
                    DiagnosticForm(
                      idTicket: widget.ticketId,
                      onSave: (DateTime? date, String observations,
                          List<File> images) {
                        // Lógica para manejar los datos guardados del formulario
                        print('Fecha: $date');
                        print('Observaciones: $observations');
                        print('Imágenes: $images');
                      },
                    ),
                    RepairLogFormData(initialReparaciones: reparaciones),
                    CloseTicketForm(
                      idTicket: widget.ticketId,
                      onSave: (DateTime? date, String observations,
                          List<File> images) {
                        // Lógica para manejar los datos guardados del formulario
                        print('Fecha: $date');
                        print('Observaciones: $observations');
                        print('Imágenes: $images');
                      },
                    )
                  ],
                );
              }
            }),
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
  final dynamic ticketInfo;

  const _TicketDetailProgress({super.key, required this.ticketInfo});

  @override
  Widget build(BuildContext context) {
    print('ticketInfo $ticketInfo');

    String formattedDate =
        DateFormat('yyyy-MM-dd – kk:mm').format(ticketInfo.createdAt);
    return Container(
      child: Column(
        children: [
          Expanded(
            child: ListView(
              children: [
                TicketDetailCard(
                  headerTitle: 'Ticket de Servicio',
                  code: ticketInfo.serviceCallId?.toString() ?? 'N/A',
                  clientName: ticketInfo.customerName ?? 'N/A',
                  status: ticketInfo.status.toString(),
                  type: 'Reparación',
                  creationDate: formattedDate,
                  title: ticketInfo.title,
                  description: ticketInfo.serviceCallDetail['descrption'],
                ),
                const SizedBox(
                  height: 5,
                ),
                //Divider(),
                ClienteHandler(),

                // Más apartados como Prueba y Cierre pueden ser añadidos aquí...
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/*

     description: item.serviceCallDetail['descrption'], // Ajusta según sea necesario
                            creationDateTime: item.createdAt,
                            location: 'Cambiar formato de coordenadas',
                            product:  item.serviceCallDetail['itemName'], 
 */

class ClienteHandler extends StatefulWidget {
  @override
  _ClienteHandlerState createState() => _ClienteHandlerState();
}

class _ClienteHandlerState extends State<ClienteHandler> {
  String address = 'Calle 123, Ciudad, País';

  void _updateAddress(String newAddress) {
    setState(() {
      address = newAddress;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ClienteDetailCard(
        address: address,
        phoneNumber: '+58 0412 4838 327',
        email: 'cliente@ejemplo.com',
        geolocation: '10.123456, -64.123456', // Ejemplo de coordenadas
        onAddressChanged: _updateAddress,
      ),
    );
  }
}


/*

              code: item.serviceCallId?.toString() ?? 'N/A',
                            clientName: item.customerName ?? 'N/A',
                            status: item.status?.toString() ?? 'N/A',
                            type: 'Reparación',
                            title: item.title ?? 'N/A',
                            description: 'N/A', // Ajusta según sea necesario
                            creationDateTime: item.createdAt,

 */