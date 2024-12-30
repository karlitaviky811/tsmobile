import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:tsmobile/src/core/theme/app.styles.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tsmobile/src/providers/tikets_provider.dart';
import 'dart:io';
import 'package:tsmobile/src/services/service_ticket_service.dart';
import 'package:tsmobile/src/widgets/images_loaders/image_loader_close_ticket.dart';

class CloseTicketForm extends StatefulWidget {
  final Function(DateTime?, String, List<File>) onSave;
  var idTicket;

  CloseTicketForm({required this.onSave, required this.idTicket});

  @override
  _CloseTicketFormState createState() => _CloseTicketFormState();
}

class _CloseTicketFormState extends State<CloseTicketForm> {
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _observationsController = TextEditingController();
  final List<File> _images = [];
  final ImagePicker _picker = ImagePicker();
  bool _isImagePickerActive = false;
  late Future<void> _loadTicketFuture;
  DateTime? _selectedDate;
  bool isDateInitialized = false;
  bool isObservationsInitialized = false;
  bool _isFormActive = false;
  String? _selectedReason;

  final List<String> _reasons = [
    'Producto irreparable',
    'Fuera de garantía',
    'Cliente no desea reparación',
    'Repuesto no disponible',
    'Otro',
  ];

  Future<void> _pickDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
        _dateController.text = "${picked.day}/${picked.month}/${picked.year}";
      });
    }
  }

  Future<void> _pickImage() async {
    if (!_isImagePickerActive) {
      setState(() {
        _isImagePickerActive = true;
      });

      try {
        final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
        if (image != null) {
          setState(() {
            _images.add(File(image.path));
          });
        }
      } catch (e) {
        print("Error al seleccionar imagen: $e");
      } finally {
        setState(() {
          _isImagePickerActive = false;
        });
      }
    }
  }

  String getFormattedDate(DateTime date) {
    var outputFormat = DateFormat('dd/MM/yyyy');
    return outputFormat.format(date);
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

            if (!isDateInitialized && item.solutionDate != null) {
              _selectedDate = item.solutionDate!;
              _dateController.text = getFormattedDate(_selectedDate!);
              isDateInitialized = true;
            }
            if (!isObservationsInitialized && item.solutionDetail != null) {
              _observationsController.text = item.solutionDetail ?? '';
              isObservationsInitialized = true;
            }

            return Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Padding(
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
                                'Cierre del ticket',
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
                                    onPressed: _isFormActive ? () => _pickDate(context) : null,
                                  ),
                                ),
                                readOnly: !_isFormActive,
                              ),
                              const SizedBox(height: 16),
                              TextField(
                                controller: _observationsController,
                                decoration: const InputDecoration(labelText: 'Observaciones'),
                                readOnly: !_isFormActive,
                              ),
                              const SizedBox(height: 16),
                              DropdownButtonFormField<String>(
                                decoration: const InputDecoration(labelText: 'Motivo de cierre'),
                                value: _selectedReason,
                                items: _reasons.map((String reason) {
                                  return DropdownMenuItem<String>(
                                    value: reason,
                                    child: Text(reason),
                                  );
                                }).toList(),
                                onChanged: _isFormActive ? (String? newValue) {
                                  setState(() {
                                    _selectedReason = newValue;
                                  });
                                } : null,
                              ),
                              const SizedBox(height: 16),
                              ImageUploaderCloseTicket(
                                initialImages: [],
                                showAddButton: _isFormActive,
                              ),
                              const SizedBox(height: 30),
                              Center(
                                child: ElevatedButton.icon(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: _isFormActive ? Colors.green : const Color(0xff051937),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                  ),
                                  icon: Icon(_isFormActive ? Icons.save : Icons.edit, size: 18, color: Colors.white),
                                  onPressed: () async {
                                    if (_isFormActive) {
                                      if (_selectedDate != null && _selectedReason != null) {
                                        serviceUpdateTicket.savecloseTicketFormData(
                                          _selectedDate!.toIso8601String(),
                                          _observationsController.text,
                                          _images,
                                          widget.idTicket,
                                        );
                                      } else {
                                        print('Por favor, selecciona una fecha y un motivo.');
                                      }
                                    } else {
                                      setState(() {
                                        _isFormActive = true;
                                      });
                                    }
                                  },
                                  label: Text(
                                    _isFormActive ? 'Guardar Información' : 'Editar',
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}