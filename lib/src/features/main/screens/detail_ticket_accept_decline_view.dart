import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tsmobile/src/core/theme/app.styles.dart';
import 'package:tsmobile/src/features/main/screens/ticket_accepted_progress.dart';
import 'package:tsmobile/src/providers/tikets_provider.dart';
import 'package:tsmobile/src/services/tecnical_visitis_service.dart';
import 'package:tsmobile/src/widgets/new_ticket_detail_client_info.dart';
import 'location_map_distance.dart';

class TicketDetailPageView extends StatefulWidget {
  static const String route = 'detail-view-ticket-route';

  final String ticketId;
  const TicketDetailPageView({super.key, this.ticketId = ''});

  @override
  _TicketDetailPageState createState() => _TicketDetailPageState();
}

void _showLoadingDialog(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return const Dialog(
        backgroundColor: Colors.transparent,
        child: Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
          ),
        ),
      );
    },
  );
}

void _hideLoadingDialog(BuildContext context) {
  Navigator.of(context).pop();
}

class _TicketDetailPageState extends State<TicketDetailPageView> {
  String _status = 'pending';
  String _selectedReason = 'No especificado';
  late Future<void> _loadTicketFuture;

  TextEditingController _dateController = TextEditingController();
  TextEditingController _notesController = TextEditingController();
  DateTime? _selectedDate;

  /* void _saveDetails() async {
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
      final visistService = VisistService();
      final ticketProvider =
          Provider.of<TicketProvider>(context, listen: false);
      final item = ticketProvider.ticketInfo;
      _loadTicketFuture = ticketProvider.updateTicket(item!, data);

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => TicketAcceptedProgressDetailPage(
              ticketId: item.id.toString()), // Cambiar item a ticket
        ),
      );
      print("Se ha aceptado el ticket exitosamente");
    } catch (e) {
      print("Error al conectar con el servidor: $e");
    }
  }
*/
  void _saveDetails() async {
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
      final visistService = VisitService();
      final ticketProvider =
          Provider.of<TicketProvider>(context, listen: false);
      final item = ticketProvider.ticketInfo;
      _loadTicketFuture = ticketProvider.updateTicket(item!, data);

      Fluttertoast.showToast(
          msg: "Detalles guardados exitosamente",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0);
      print("Se ha aceptado el ticket exitosamente");
      _hideLoadingDialog(context);

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              TicketAcceptedProgressDetailPage(ticketId: item.id.toString()),
        ),
      );
    } catch (e) {
      Fluttertoast.showToast(
          msg: "Error al guardar los detalles",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
      print("Error al conectar con el servidor: $e");
    } finally {
        Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              TicketAcceptedProgressDetailPage(ticketId: widget.ticketId.toString()),
        ),
      );
      _hideLoadingDialog(context); 
      
      // Ocultar el diálogo de carga
    }
  }

  void _saveDetailsRejected() async {
    final Map<String, dynamic> data = {
      'start_date': DateTime.now().toIso8601String(),
      'additional_notes': _notesController.text,
      'status': 1,
    };

    print('programado $data');
    _showLoadingDialog(context); // Mostrar el diálogo de carga
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final idTicket = widget.ticketId.toString();
      String? token = prefs.getString('auth_token');
      final ticketProvider =
          Provider.of<TicketProvider>(context, listen: false);
      final item = ticketProvider.ticketInfo;
      _loadTicketFuture = ticketProvider.updateTicket(item!, data);

      Fluttertoast.showToast(
          msg: "Ticket rechazado exitosamente",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0);
      print("Error al guardar los detalles:");
    } catch (e) {
      Fluttertoast.showToast(
          msg: "Error al guardar los detalles",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
      print("Error al conectar con el servidor: $e");
    } finally {
      _hideLoadingDialog(context); // Ocultar el diálogo de carga
    }
  }

  /* void _saveDetailsRejected() async {
    final Map<String, dynamic> data = {
      'start_date': DateTime.now().toIso8601String(),
      'additional_notes': _notesController.text,
      'status': 1,
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
  }*/

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

  void _showAcceptedFormModal() {
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
                  Text('Aceptar Ticket de Servicio',
                      style: AppStyle.txtPoppinsBold14Black),
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

  void _showRejectedFormModal() {
    bool _isSaveButtonEnabled = false;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            void _validateModalForm() {
              setModalState(() {
                _isSaveButtonEnabled = _selectedReason.isNotEmpty &&
                    _notesController.text.isNotEmpty;
              });
            }

            return Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text('Rechazar ticket',
                      style: AppStyle.txtPoppinsBold14Black),
                  const SizedBox(height: 10),
                  const Text('Ingrese motivo'),
                  const SizedBox(height: 10),
                  DropdownButtonFormField<String>(
                    value: _selectedReason,
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedReason = newValue!;
                        _validateModalForm();
                      });
                    },
                    items: _rejectionReasons
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    decoration:
                        const InputDecoration(labelText: 'Motivo de rechazo'),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _notesController,
                    onChanged: (text) => _validateModalForm(),
                    decoration:
                        const InputDecoration(labelText: 'Notas adicionales'),
                    maxLines: null,
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed:
                        _isSaveButtonEnabled ? _saveDetailsRejected : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xff051937),
                    ),
                    child: Text('Rechazar',
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

            return Stack(
              children: [
                SingleChildScrollView(
                  child: Container(
                    color: Colors.white,
                    child: Padding(
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
                              description: item.serviceCallDetail['descrption'],
                              creationDateTime: item.createdAt,
                              location: 'Cambiar formato de coordenadas',
                              product: item.serviceCallDetail['itemName'] ?? '',
                              brand: 'Hyundai',
                            ),
                          ),
                          const SizedBox(height: 10),
                          LocationMapDistance(
                            initialCoordinates:
                                const LatLng(10.254027777778, -68.010855555556),
                            destinationCoordinates: LatLng(
                              double.tryParse(
                                      item.serviceCallDetail?['latitude'] ??
                                          '0') ??
                                  0,
                              double.tryParse(
                                      item.serviceCallDetail?['longitude'] ??
                                          '0') ??
                                  0,
                            ),
                          ),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  right: 16,
                  bottom: 16,
                  child: Column(
                    children: [
                      FloatingActionButton(
                        onPressed: _showAcceptedFormModal,
                        backgroundColor: const Color(0xff051937),
                        child: const Icon(Icons.check_box, color: Colors.white),
                      ),
                      const SizedBox(height: 10),
                      FloatingActionButton(
                        onPressed: _showRejectedFormModal,
                        backgroundColor: const Color(0xff051937),
                        child: const Icon(Icons.report_problem,
                            color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ],
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
          onPressed: _saveDetails, // Asegúrate de no tener paréntesis aquí
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
