import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:tsmobile/src/features/main/screens/chat_service_screen.dart';
import 'package:tsmobile/src/interfaces/ticket.dart';
import 'package:tsmobile/src/models/visit_model.dart';
import 'package:tsmobile/src/providers/tikets_provider.dart';
import 'package:tsmobile/src/providers/visit_provider.dart';
import 'package:tsmobile/src/widgets/client_detail_card.dart';
import 'package:tsmobile/src/widgets/close_ticket_form.dart';
import 'package:tsmobile/src/widgets/repair_log_form.dart';
import 'package:tsmobile/src/widgets/ticket_detail_card.dart';
import '../../../widgets/diagnostic_log_ticket.dart';
import 'package:geocoding/geocoding.dart';

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
  late Future<void> _loadVisitFuture;
  late Future<void> _loadDataFuture;
  @override
  void initState() {
    super.initState();
    _loadDataFuture = _loadData();
  }

  Future<void> _loadData() async {
    await Provider.of<TicketProvider>(context, listen: false)
        .loadTicketById(widget.ticketId);
    await Provider.of<VisitProvider>(context, listen: false)
        .fetchVisitsByTicket(widget.ticketId);
  }

  @override
  Widget build(BuildContext context) {
    final ticketProvider = Provider.of<TicketProvider>(context);
    final visitProvider = Provider.of<VisitProvider>(context);
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
                _loadDataFuture, // Utiliza el Future inicializado en initState
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

                return Consumer2<TicketProvider, VisitProvider>(
                  builder: (context, ticketProvider, visitProvider, child) {
                    final itemVisit = visitProvider.visits;
                    return TabBarView(
                      children: [
                        _TicketDetailProgress(
                            ticketInfo: item, visit: itemVisit),
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
                        RepairLogFormData(ticketId: widget.ticketId),
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
                  },
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
  final List<Visit> visit;
  const _TicketDetailProgress(
      {super.key, required this.ticketInfo, required this.visit});

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
                  ticketId: ticketInfo.id?.toString() ?? 'N/A',
                  scheduledVisit: visit[0].visitDate,
                ),
                const SizedBox(
                  height: 5,
                ),
                //Divider(),
                ClienteHandler(ticketInfo: ticketInfo),

                // Más apartados como Prueba y Cierre pueden ser añadidos aquí...
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ClienteHandler extends StatefulWidget {
  var ticketInfo;

  ClienteHandler({super.key, required this.ticketInfo});

  @override
  _ClienteHandlerState createState() => _ClienteHandlerState();
}

class _ClienteHandlerState extends State<ClienteHandler> {
  String address = 'Calle 123, Ciudad, País';
  String _address = 'Unknown';
  void _updateAddress(String newAddress) {
    setState(() {
      address = newAddress;
    });
  }

  Future<void> _getAddressFromCoordinates(
      double latitude, double longitude) async {
    try {
      List<Placemark> placemarks =
          await placemarkFromCoordinates(latitude, longitude);
      Placemark place = placemarks[0];
      setState(() {
        _address =
            "${place.street}, ${place.locality}, ${place.postalCode}, ${place.country}";
      });
    } catch (e) {
      print(e);
      setState(() {
        _address = "Could not get address";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    _getAddressFromCoordinates(
        double.parse(widget.ticketInfo.serviceCallDetail['latitude']),
        double.parse(widget.ticketInfo.serviceCallDetail['longitude']));
    return Center(
      child: ClienteDetailCard(
        address: widget.ticketInfo.serviceCallDetail['BPBillAddr'],
        phoneNumber: widget.ticketInfo.serviceCallDetail['BPCellular'],
        email: widget.ticketInfo.serviceCallDetail['BPE_Mail'],
        geolocation: _address,
        latitude: widget.ticketInfo.serviceCallDetail['latitude'],
        longitude: widget.ticketInfo
            .serviceCallDetail['longitude'], // Ejemplo de coordenadas
        onAddressChanged: _updateAddress,
      ),
    );
  }
}
