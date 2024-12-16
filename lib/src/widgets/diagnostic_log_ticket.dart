import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:tsmobile/src/core/theme/app.styles.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tsmobile/src/providers/image_provider.dart';
import 'package:tsmobile/src/providers/tikets_provider.dart';
import 'dart:io';
import 'package:tsmobile/src/services/service_ticket_service.dart';

class DiagnosticForm extends StatefulWidget {
  final Function(DateTime?, String, List<File>) onSave;
  var idTicket;

  DiagnosticForm({required this.onSave, required this.idTicket});

  @override
  _DiagnosticFormState createState() => _DiagnosticFormState();
}

class _DiagnosticFormState extends State<DiagnosticForm> {
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _observationsController = TextEditingController();
  final List<File> _images = [];
  final ImagePicker _picker = ImagePicker();
  late Future<void> _loadTicketFuture;
  DateTime? _selectedDate; // Variable para almacenar la fecha seleccionada
  bool isDateInitialized = false;
  bool isObservationsInitialized = false;

  Future<void> _pickDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked; // Almacena la fecha seleccionada
        _dateController.text = DateFormat('dd/MM/yyyy').format(picked);
      });
    }
  }

  Future<void> _pickImage() async {
    final imagePickerProvider = Provider.of<ImagePickerProvider>(context, listen: false);
    imagePickerProvider.setImagePickerActive(true);
    
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _images.add(File(image.path));
      });
    }
    
    imagePickerProvider.setImagePickerActive(false);
  }

  void _removeImage(int index) {
    if (index >= 0 && index < _images.length) {
      setState(() {
        _images.removeAt(index);
      });
    } else {
      print('Índice inválido: $index');
    }
  }

  @override
  void initState() {
    super.initState();
    final ticketProvider = Provider.of<TicketProvider>(context, listen: false);
    _loadTicketFuture = ticketProvider.loadTicketById(widget.idTicket);
  }


  @override
  Widget build(BuildContext context) {
    final serviceUpdateTicket = TicketService();
    final ticketProvider = Provider.of<TicketProvider>(context);

    return SingleChildScrollView(
      child: FutureBuilder(
        future: _loadTicketFuture,
        builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final item = ticketProvider.ticketInfo;

            if (item == null) {
              return const Center(child: Text('No se encontró el ticket'));
            }

            if (!isDateInitialized && item.diagnosisDate != null) {
              _selectedDate = item.diagnosisDate; // Guarda el DateTime
              _dateController.text = DateFormat('dd/MM/yyyy').format(_selectedDate!);
              isDateInitialized = true;
            }
            if (!isObservationsInitialized && item.diagnosisDetail != null) {
              _observationsController.text = item.diagnosisDetail ?? '';
              isObservationsInitialized = true;
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    color: Colors.white,
                    elevation: 20,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Diagnóstico',
                            textAlign: TextAlign.left,
                            style: AppStyle.txtPoppinsMedium18Black,
                          ),
                          const SizedBox(height: 16),
                          TextField(
                            controller: _dateController,
                            decoration: InputDecoration(
                              labelText: 'Fecha',
                              prefixIcon: IconButton(
                                icon: const Icon(Icons.calendar_today),
                                onPressed: () => _pickDate(context),
                              ),
                            ),
                            readOnly: true,
                          ),
                          const SizedBox(height: 16),
                          TextField(
                            controller: _observationsController,
                            decoration: const InputDecoration(labelText: 'Observaciones'),
                          ),
                          const SizedBox(height: 16),
                          TextButton.icon(
                            icon: Icon(Icons.add_photo_alternate),
                            label: Text('Añadir Imagen'),
                            onPressed: _pickImage,
                          ),
                          const SizedBox(height: 16),
                          _buildImageThumbnails(),
                          const SizedBox(height: 30),
                          Center(
                            child: ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xff051937),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                              icon: const Icon(Icons.save, size: 18, color: Colors.white),
                              onPressed: () async {
                                if (_selectedDate != null) {
                                  await serviceUpdateTicket.saveFormData(
                                    _selectedDate!.toIso8601String(), // Convierte DateTime a String
                                    _observationsController.text,
                                    _images,
                                    widget.idTicket,
                                  );
                                } else {
                                  print('Por favor, selecciona una fecha.');
                                }
                              },
                              label: const Text(
                                'Guardar Información',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }

  Widget _buildImageThumbnails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Imágenes Añadidas:',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        SizedBox(
          height: 100,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: _images.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.all(4.0),
                child: Stack(
                  children: [
                    Image.file(
                      _images[index],
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                    ),
                    Positioned(
                      right: 0,
                      child: GestureDetector(
                        onTap: () => _removeImage(index),
                        child: Icon(
                          Icons.remove_circle,
                          color: Colors.red,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
