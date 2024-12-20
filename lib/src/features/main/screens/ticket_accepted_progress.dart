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
          backgroundColor: Colors.white,
          child: const Icon(
            Icons.chat_rounded,
            color: Colors.blueAccent,
          ),
        ),
        appBar: AppBar(
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
                return TabBarView(
                  children: [
                    _TicketDetailProgress(ticketInfo: item),
                    DiagnosticForm(
                      idTicket: widget.ticketId,
                      onSave: (DateTime? date, String observations,List<File> images) {
                      },
                    ),
                    RepairLogFormData(ticketId: widget.ticketId),
                    CloseTicketForm(
                      idTicket: widget.ticketId,
                      onSave: (DateTime? date, String observations,List<File> images) {
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
                  ticketId: ticketInfo.id?.toString() ?? 'N/A',
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
      if (mounted) {
        // Verificar si el widget aún está en el árbol
        setState(() {
          _address =
              "${place.street}, ${place.locality}, ${place.postalCode}, ${place.country}";
        });
      }
    } catch (e) {
      print(e);
      if (mounted) {
        // Verificar si el widget aún está en el árbol
        setState(() {
          _address = "Could not get address";
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    _getAddressFromCoordinates(
        double.parse(widget.ticketInfo.serviceCallDetail['latitude']),
        double.parse(widget.ticketInfo.serviceCallDetail['longitude']));
    return Center(
      child: ClienteDetailCard(
        address:
            widget.ticketInfo.serviceCallDetail['BPBillAddr'] ?? 'No tiene',
        phoneNumber:
            widget.ticketInfo.serviceCallDetail['BPCellular'] ?? 'No tiene',
        email: widget.ticketInfo.serviceCallDetail['BPE_Mail'] ?? 'No tiene',
        geolocation: _address ?? 'No tiene',
        latitude: widget.ticketInfo.serviceCallDetail['latitude'] ?? 0.0,
        longitude: widget.ticketInfo.serviceCallDetail['longitude'] ??
            0.0, // Ejemplo de coordenadas
        onAddressChanged: _updateAddress,
      ),
    );
  }
}
