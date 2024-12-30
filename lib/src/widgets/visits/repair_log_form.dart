import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tsmobile/src/core/theme/app.styles.dart';
import 'package:tsmobile/src/models/visit_model.dart';
import 'package:tsmobile/src/providers/tikets_provider.dart';
import 'package:tsmobile/src/providers/visit_provider.dart';
import 'package:tsmobile/src/services/tecnical_visitis_service.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import 'package:tsmobile/src/widgets/edit_visit_card_log.dart';

class RepairLogFormData extends StatefulWidget {
  final String ticketId;

  RepairLogFormData({required this.ticketId});

  @override
  _RepairLogFormDataState createState() => _RepairLogFormDataState();
}

class _RepairLogFormDataState extends State<RepairLogFormData> {
  final ImagePicker _picker = ImagePicker();
  late Future<void> _fetchVisitsFuture;

  @override
  void initState() {
    super.initState();
    tz.initializeTimeZones();
    _fetchVisitsFuture = _fetchVisits();
  }

  Future<void> _fetchVisits() async {
    final visitProvider = Provider.of<VisitProvider>(context, listen: false);
    await visitProvider.fetchVisitsByTicket(widget.ticketId);
  }

  void _navigateToEditPage(BuildContext context, Visit visit, String tipo) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            EditVisitPage(visit: visit, ticketId: widget.ticketId, type: tipo),
      ),
    ).then((_) => _fetchVisits());
  }

  Future<void> _selectDate(
      BuildContext context, TextEditingController controller) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        controller.text = DateFormat('dd/MM/yyyy').format(picked);
      });
    }
  }

  Future<void> _selectTime(
      BuildContext context, TextEditingController controller) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        controller.text = picked.format(context);
      });
    }
  }

  void _showAddVisitModal(BuildContext context) {
    final _titleController = TextEditingController();
    final _dateController = TextEditingController();
    final _timeController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: _titleController,
                    decoration: const InputDecoration(labelText: 'Motivo'),
                  ),
                  TextField(
                    controller: _dateController,
                    decoration: InputDecoration(
                      labelText: 'Fecha',
                      prefixIcon: IconButton(
                        icon: const Icon(Icons.calendar_today),
                        onPressed: () => _selectDate(context, _dateController),
                      ),
                    ),
                    readOnly: true,
                  ),
                  TextField(
                    controller: _timeController,
                    decoration: InputDecoration(
                      labelText: 'Hora',
                      prefixIcon: IconButton(
                        icon: const Icon(Icons.access_time),
                        onPressed: () => _selectTime(context, _timeController),
                      ),
                    ),
                    readOnly: true,
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () async {
                      if (_titleController.text.isEmpty ||
                          _dateController.text.isEmpty ||
                          _timeController.text.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content:
                                Text('Por favor, completa todos los campos.'),
                          ),
                        );
                        return;
                      }

                      final date =
                          DateFormat('dd/MM/yyyy').parse(_dateController.text);
                      final time = TimeOfDay(
                        hour: int.parse(_timeController.text.split(':')[0]),
                        minute: int.parse(
                            _timeController.text.split(':')[1].split(' ')[0]),
                      );

                      final caracas = tz.getLocation('America/Caracas');
                      final visitDate = tz.TZDateTime(
                        caracas,
                        date.year,
                        date.month,
                        date.day,
                        time.hour,
                        time.minute,
                      );

                      final newVisit = Visit(
                        id: 0,
                        title: _titleController.text,
                        type: 1,
                        status: 1,
                        selectedRepuestos: [],
                        selectedServicios: [],
                        necesitaRepuesto: false,
                        ticketId: 0,
                        visitDate: visitDate,
                        reprogramming: [],
                        services: [],
                        createdAt: DateTime.now(),
                        updatedAt: DateTime.now(),
                      );

                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (BuildContext context) {
                          return const AlertDialog(
                            content: Row(
                              children: [
                                CircularProgressIndicator(),
                                SizedBox(width: 20),
                                Text("Guardando..."),
                              ],
                            ),
                          );
                        },
                      );

                      _saveDetails(newVisit);
                      Navigator.pop(context); // Close the loading dialog
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          Colors.blue, // Cambiar el color de fondo a azul
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.save, color: Colors.white),
                        SizedBox(
                            width: 8), // Espacio entre el icono y el texto
                        Text(
                          'Añadir visita',
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _showReprogramVisitModal(BuildContext context, Visit visit) {
    final _dateController = TextEditingController(
        text: DateFormat('dd/MM/yyyy').format(visit.visitDate));
    final _timeController = TextEditingController(
        text: TimeOfDay.fromDateTime(visit.visitDate).format(context));
    final _reasonController = TextEditingController();
    String _selectedReason = 'Motivo 1'; // Default selected reason
    final List<String> _reasons = ['Motivo 1', 'Motivo 2', 'Motivo 3'];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Reprogramar Visita',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Título: ${visit.title}',
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _dateController,
                    decoration: InputDecoration(
                      labelText: 'Fecha',
                      prefixIcon: IconButton(
                        icon: const Icon(Icons.calendar_today),
                        onPressed: () => _selectDate(context, _dateController),
                      ),
                    ),
                    readOnly: true,
                  ),
                  TextField(
                    controller: _timeController,
                    decoration: InputDecoration(
                      labelText: 'Hora',
                      prefixIcon: IconButton(
                        icon: const Icon(Icons.access_time),
                        onPressed: () => _selectTime(context, _timeController),
                      ),
                    ),
                    readOnly: true,
                  ),
                  const SizedBox(height: 10),
                  DropdownButtonFormField<String>(
                    value: _selectedReason,
                    items: _reasons.map((String reason) {
                      return DropdownMenuItem<String>(
                        value: reason,
                        child: Text(reason),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedReason = newValue!;
                      });
                    },
                    decoration: const InputDecoration(
                        labelText: 'Motivo de reprogramación'),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      if (_selectedReason.isEmpty ||
                          _dateController.text.isEmpty ||
                          _timeController.text.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content:
                                Text('Por favor, completa todos los campos.'),
                          ),
                        );
                        return;
                      }

                      final date =
                          DateFormat('dd/MM/yyyy').parse(_dateController.text);
                      final time = TimeOfDay(
                        hour: int.parse(_timeController.text.split(':')[0]),
                        minute: int.parse(
                            _timeController.text.split(':')[1].split(' ')[0]),
                      );

                      final caracas = tz.getLocation('America/Caracas');
                      final visitDate = tz.TZDateTime(
                        caracas,
                        date.year,
                        date.month,
                        date.day,
                        time.hour,
                        time.minute,
                      );

                      setState(() {
                        visit.visitDate = visitDate;
                      });

                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (BuildContext context) {
                          return const AlertDialog(
                            content: Row(
                              children: [
                                CircularProgressIndicator(),
                                SizedBox(width: 20),
                                Text("Guardando..."),
                              ],
                            ),
                          );
                        },
                      );

                      _handleReprogramVisit(
                          context, visit.id, visit, _selectedReason);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          Colors.blue, // Cambiar el color de fondo a azul
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.save, color: Colors.white),
                        SizedBox(width: 8), // Espacio entre el icono y el texto
                        Text(
                          'Reprogramar Visita',
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> _handleReprogramVisit(
      BuildContext context, int visitId, Visit visit, String reason) async {
    await _saveDetailsUpdateReprogramming(visitId, visit, reason);

    Navigator.pop(context); // Close the loading dialog
    Navigator.pop(context); // Close the bottom sheet
  }

  Future<void> _saveDetailsUpdateReprogramming(
      int visitId, Visit newVisit, String reason) async {
    final visitProvider = Provider.of<VisitProvider>(context, listen: false);
    final ticketProvider = Provider.of<TicketProvider>(context, listen: false);

    final caracas = tz.getLocation('America/Caracas');
    final visitDate = tz.TZDateTime.from(newVisit.visitDate, caracas);
    String formattedDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(visitDate);

    Map<String, dynamic> data = {
      "new_date": formattedDate,
      "extend_reason": reason,
      "reason": "3"
    };
    var visitService = VisitService();
    Visit? visit =
        await visitService.sendDataVisitReprogramming(data, visitId.toString());

    if (visit != null) {
      print('Visita recibida: ${visit.title}');
    } else {
      print('Error al enviar y recibir la visita.');
    }

    await visitProvider.fetchVisitsByTicket(widget.ticketId);
    await ticketProvider.loadTicketById(widget.ticketId);

    if (mounted) {
      _fetchVisits(); // Refrescar las visitas después de reprogramar
    }
  }

  void _saveDetails(Visit newVisit) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const AlertDialog(
          content: Row(
            children: [
              CircularProgressIndicator(),
              SizedBox(width: 20),
              Text("Guardando..."),
            ],
          ),
        );
      },
    );

    final caracas = tz.getLocation('America/Caracas');
    final visitDate = tz.TZDateTime.from(newVisit.visitDate, caracas);
    String formattedDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(visitDate);

    final Map<String, dynamic> dataVisit = {
      'visit_date': formattedDate.toString(),
      'title': newVisit.title,
      'ticket_id': widget.ticketId.toString()
    };

    final visistService = VisitService();
    var visit = await visistService.sendDataVisit(dataVisit);

    Navigator.pop(context); // Close the loading dialog

    if (visit != null) {
      print('Visita recibida:');
    } else {
      print('Error al enviar y recibir la visita.');
    }

    if (mounted) {
      _fetchVisits();
      Navigator.pop(context); // Close the modal bottom sheet
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: _fetchVisitsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          return Consumer<VisitProvider>(
            builder: (context, visitProvider, child) {
              if (visitProvider.isLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              return Card(
                color: Colors.white,
                elevation: 20,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        'Bitácora de visitas',
                        textAlign: TextAlign.left,
                        style: AppStyle.txtPoppinsMedium18Black,
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: visitProvider.visits.length,
                        itemBuilder: (context, index) {
                          final visit = visitProvider.visits[index];
                          final visitTime =
                              TimeOfDay.fromDateTime(visit.visitDate);
                          print('visit $visit');
                          return Card(
                            color: Colors.white,
                            margin: const EdgeInsets.symmetric(
                                vertical: 8.0, horizontal: 16.0),
                            elevation: 5,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    visit.title.isEmpty
                                        ? 'Nueva visita'
                                        : visit.title,
                                    style: AppStyle.txtPoppinsBold14Black,
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    children: [
                                      const Icon(Icons.calendar_today,
                                          size: 16),
                                      const SizedBox(width: 4),
                                      Text(
                                        'Fecha: ${visit.visitDate.toIso8601String().split('T')[0]}',
                                        style: const TextStyle(fontSize: 14),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  Row(
                                    children: [
                                      const Icon(Icons.access_time, size: 16),
                                      const SizedBox(width: 4),
                                      Text(
                                        'Hora: ${visitTime.format(context)}',
                                        style: const TextStyle(fontSize: 14),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Chip(
                                    label: Text(
                                      visit.status == 1
                                          ? 'En progreso'
                                          : 'Finalizado',
                                      style:
                                          const TextStyle(color: Colors.white),
                                    ),
                                    backgroundColor: visit.status == 1
                                        ? Colors.orangeAccent
                                        : Colors.green,
                                    avatar: Icon(
                                      visit.status == 1
                                          ? Icons.timelapse
                                          : Icons.check_circle,
                                      color: Colors.white,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(25.0),
                                      side: const BorderSide(
                                          color: Colors.transparent),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      IconButton(
                                        icon: const Icon(Icons.edit),
                                        onPressed: () => _navigateToEditPage(
                                            context, visit, 'Edit'),
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.schedule),
                                        onPressed: visit.reprogramming.length <
                                                3
                                            ? () => _showReprogramVisitModal(
                                                context, visit)
                                            : null,
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.delete),
                                        onPressed: () =>
                                            _eliminarVisita(visit.id),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    Center(
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xff051937),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        onPressed: () => _showAddVisitModal(context),
                        icon: const Icon(Icons.add, color: Colors.white),
                        label: const Text('Añadir nueva visita',
                            style: TextStyle(color: Colors.white)),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        }
      },
    );
  }

  void _agregarNuevaReparacion() {
    final visitProvider = Provider.of<VisitProvider>(context, listen: false);
    setState(() {
      visitProvider.visits.add(
        Visit(
          id: 0,
          title: 'Nueva visita',
          type: 1,
          status: 1,
          selectedRepuestos: [],
          selectedServicios: [],
          necesitaRepuesto: false,
          ticketId: 0,
          visitDate: DateTime.now(),
          reprogramming: [],
          services: [],
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
      );
    });
    _fetchVisits();
  }

  void _eliminarVisita(int index) {
    final scaffoldContext = context; // Capturar el contexto del Scaffold

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmar eliminación'),
          content:
              const Text('¿Estás seguro de que deseas eliminar esta visita?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Aceptar'),
              onPressed: () async {
                Navigator.of(context)
                    .pop(); // Cerrar el diálogo de confirmación

                // Mostrar el diálogo de "Eliminando..." en un nuevo contexto
                showDialog(
                  context: scaffoldContext,
                  barrierDismissible: false,
                  builder: (BuildContext context) {
                    return const AlertDialog(
                      content: Row(
                        children: [
                          CircularProgressIndicator(),
                          SizedBox(width: 20),
                          Text("Eliminando..."),
                        ],
                      ),
                    );
                  },
                );

                try {
                  final visitProvider =
                      Provider.of<VisitProvider>(context, listen: false);
                  var visit = await visitProvider.deleteVisits(index);

                  // Usar el contexto capturado para cerrar el diálogo de "Eliminando..."
                  if (mounted) {
                    Navigator.of(scaffoldContext, rootNavigator: true)
                        .pop(); // Cerrar el diálogo de "Eliminando..."
                    _fetchVisits(); // Refrescar las visitas después de eliminar
                  }

                  if (visit != null) {
                    Fluttertoast.showToast(
                      msg: "Visita eliminada exitosamente",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.green,
                      textColor: Colors.white,
                      fontSize: 16.0,
                    );
                  } else {
                    Fluttertoast.showToast(
                      msg: "Error al eliminar la visita",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.red,
                      textColor: Colors.white,
                      fontSize: 16.0,
                    );
                  }
                } catch (e) {
                  Fluttertoast.showToast(
                    msg: "Error al eliminar la visita: $e",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIosWeb: 1,
                    backgroundColor: Colors.red,
                    textColor: Colors.white,
                    fontSize: 16.0,
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }
}
