import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tsmobile/src/core/theme/app.styles.dart';
import 'package:tsmobile/src/features/main/screens/card_detail_ticket.dart';
import 'package:tsmobile/src/features/main/screens/chat_screen.dart';
import 'package:tsmobile/src/features/main/screens/detail_ticket_accept_decline_view.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:tsmobile/src/interfaces/ticket.dart';
import 'package:tsmobile/src/widgets/diagnostic_log_ticket.dart';
import 'package:tsmobile/src/widgets/repair_log_form.dart';

class TicketAcceptedProgressDetailPage extends StatefulWidget {
  final Ticket ticket;
  static const String route = 'ticket-accepted-decline-ticket-route';
  TicketAcceptedProgressDetailPage({required this.ticket});

  @override
  _TicketDetailPageState createState() => _TicketDetailPageState();
}

class _TicketDetailPageState extends State<TicketAcceptedProgressDetailPage> {
  bool _needsReplacement = false;
  DateTime? _selectedDate;
  final _inputController1 = TextEditingController();
  final _inputController2 = TextEditingController();
  final _replacementCodeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
             backgroundColor: Color(0xffF3F5FD),
        title: Text('Detalles del Ticket', style: AppStyle.txtPoppinsRegular18Black),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ChatScreen()),
          );
        },
        child: Icon(Icons.chat_rounded, color: Colors.blueAccent,),
        backgroundColor: Colors.white,
      ),
      body: Container(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Expanded(
                child: ListView(
                  children: [
                    TicketDetails(
                      status: 'in_progress',
                      title: 'Reparación de Aire Acondicionado',
                      description:
                          'El aire acondicionado no enfría adecuadamente.',
                      ticketType: 'Reparación',
                      product: 'Aire Acondicionado',
                      scheduledDate: '2024-11-15',
                      customerLocation: 'Caracas, Venezuela',
                      customerName: 'Juan Pérez',
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Bitácora ticket',
                              style: AppStyle.txtPoppinsRegular18Black),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    Column(
                      children: [
                        ExpansionTile(
                          title: Text('Diagnóstico',
                              style: AppStyle.txtPoppinsRegular18Black),
                          children: [
                            DiagnosticForm(
                              onSave: (selectedDate, observations, comments) {
                                // Lógica para guardar los datos del formulario
                                print('Fecha: $selectedDate');
                                print('Observaciones: $observations');
                                print('Comentarios: $comments');
                              },
                            )
                          ],
                        ),
                        const SizedBox(height: 20.0),
                        ExpansionTile(
                          title: Text('Reparación',
                              style: AppStyle.txtPoppinsRegular18Black),
                          children: [
                            RepairLogFormTest(),
                          ],
                        ),
                      ],
                    ),
                    // Más apartados como Prueba y Cierre pueden ser añadidos aquí...
                  ],
                ),
              ),
            ],
          ),
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

class _detailTicketInfo extends StatelessWidget {
  const _detailTicketInfo({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  children: [
                    Text(
                      'ID del Ticket: ',
                      style: AppStyle.txtPoppinsBold18Black,
                    ),
                    Text(
                      '#12345',
                      style: AppStyle.txtPoppinsRegular14BlueDaka,
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                getStatusChip('in_progress'),
              ],
            ),
            Row(
              children: [
                Text(
                  'Fecha: ',
                  style: AppStyle.txtPoppinsBold18Black,
                ),
                Text(
                  '11/10/2024',
                  style: AppStyle.txtPoppinsRegular18Black,
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text('Tipo: ', style: AppStyle.txtPoppinsBold18Black),
              const SizedBox(height: 10),
              Text('Reparación', style: AppStyle.txtPoppinsRegular18Black),
            ]),
        const SizedBox(height: 10),
        Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text('Título:  ', style: AppStyle.txtPoppinsBold18Black),
              const SizedBox(height: 10),
              Text('Problema con el software.',
                  style: AppStyle.txtPoppinsRegular18Black),
            ]),
        const SizedBox(height: 10),
        Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text('Producto:  ', style: AppStyle.txtPoppinsBold18Black),
              const SizedBox(height: 10),
              Text('REFRIGERADOR 19 PIE TF  ...',
                  style: AppStyle.txtPoppinsRegular18Black),
            ]),
        const SizedBox(height: 10),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text('Descripción:  ', style: AppStyle.txtPoppinsBold18Black),
            const SizedBox(height: 10),
            Text('Problema con el software.',
                style: AppStyle.txtPoppinsRegular18Black),
          ],
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            const SizedBox(height: 10),
            Row(
              children: [
                const Icon(Icons.location_on_outlined),
                const SizedBox(width: 4),
                Text('Vía Av. Caracas y Av. P.º Caroni',
                    style: AppStyle.txtPoppinsRegular18Black)
              ],
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            const Icon(Icons.account_circle),
            const SizedBox(width: 4),
            Text(
              'Andrea Suarez',
              style: AppStyle.txtPoppinsRegular18Black,
            )
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            const Icon(Icons.lock_clock),
            const SizedBox(width: 4),
            Text(
              'Visita: ',
              style: AppStyle.txtPoppinsRegular18Black,
            ),
            Text(
              '15/11/2024 - 5:30pm ',
              style: AppStyle.txtPoppinsRegular18Black,
            )
          ],
        ),
        const SizedBox(height: 30),
        const SizedBox(height: 20),
      ],
    );
  }
}

class RepairLogForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return RepairLogFormContent();
  }
}

class RepairLogFormContent extends StatefulWidget {
  @override
  _RepairLogFormContentState createState() => _RepairLogFormContentState();
}

class _RepairLogFormContentState extends State<RepairLogFormContent> {
  List<Widget> _repairEntries = [];

  @override
  void initState() {
    super.initState();
    _addRepairEntry();
  }

  void _addRepairEntry() {
    setState(() {
      _repairEntries.add(RepairEntryForm());
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          ..._repairEntries,

          
          ElevatedButton.icon(
            onPressed: _addRepairEntry,
            label: const Text('Añadir nueva entrada'),
               style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xff051937),
              
                // Cambia este color al que desees onPrimary: Colors.white, // Color del texto del botón
              ),
          icon: const Icon(Icons.save ,size: 18, color: Colors.white),
          ),
        ],
      ),
    );
  }
}

class RepairEntryForm extends StatefulWidget {
  @override
  _RepairEntryFormState createState() => _RepairEntryFormState();
}

class _RepairEntryFormState extends State<RepairEntryForm> {
  DateTime? _selectedDate;
  final List<String> _services = ['Servicio 1', 'Servicio 2', 'Servicio 3'];
  final List<String> _parts = ['Insumo 1', 'Insumo 2', 'Insumo 3'];
  final List<String> _selectedServices = [];
  final List<String> _selectedParts = [];
  bool _needsReplacement = false;
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _replacementController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  List<XFile>? _images;

  Future<void> _pickDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _dateController.text =
            "${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}";
      });
    }
  }

  Future<void> _pickImages() async {
    final List<XFile>? pickedImages = await _picker.pickMultiImage();
    if (pickedImages != null && pickedImages.length <= 3) {
      setState(() {
        _images = pickedImages;
      });
    } else {
      // Manejo del caso en que se seleccionen más de 3 imágenes
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            controller: _dateController,
            decoration: InputDecoration(
              labelText: 'Fecha',
              suffixIcon: IconButton(
                icon: const Icon(Icons.calendar_today),
                onPressed: () => _pickDate(context),
              ),
            ),
            readOnly: true,
          ),
        ),
        MultiSelectDialogField(
          items: _services
              .map((service) => MultiSelectItem(service, service))
              .toList(),
          title: const Text("Servicios realizados"),
          selectedColor: const Color(0xff051937),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.transparent, width: 1),
          ),
          buttonIcon: const Icon(
            Icons.arrow_drop_down,
            color: Colors.deepPurple,
          ),
          buttonText: const Text(
            "Seleccionar Servicios",
            style: TextStyle(
              color: Color(0xff051937),
              fontSize: 16,
            ),
          ),
          onConfirm: (results) {
            setState(() {
              _selectedServices.clear();
              _selectedServices.addAll(List<String>.from(results));
            });
          },
        ),
        MultiSelectDialogField(
          items: _parts.map((part) => MultiSelectItem(part, part)).toList(),
          title: const Text("Insumos utilizados"),
          selectedColor: const Color(0xff051937),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.transparent, width: 1),
          ),
          buttonIcon: const Icon(
            Icons.arrow_drop_down,
            color: Colors.deepPurple,
          ),
          buttonText: const Text(
            "Seleccionar Insumos",
            style: TextStyle(
              color: Color(0xff051937),
              fontSize: 16,
            ),
          ),
          onConfirm: (results) {
            setState(() {
              _selectedParts.clear();
              _selectedParts.addAll(List<String>.from(results));
            });
          },
        ),
        CheckboxListTile(
          title: const Text('¿Necesita repuesto?'),
          value: _needsReplacement,
          onChanged: (bool? value) {
            setState(() {
              _needsReplacement = value!;
            });
          },
        ),
        if (_needsReplacement)
          TextField(
            controller: _replacementController,
            decoration:
                const InputDecoration(labelText: 'Detalle del repuesto'),
          ),
        if (_needsReplacement)
          ElevatedButton(
            onPressed: _pickImages,
            child: const Text('Cargar imágenes'),
          ),
        if (_needsReplacement && _images != null)
          Column(
            children: _images!.map((image) {
              return Image.file(File(image.path), width: 100, height: 100);
            }).toList(),
          ),
        const Divider(),
      ],
    );
  }
}
