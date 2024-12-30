import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tsmobile/src/core/theme/app.styles.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tsmobile/src/providers/image_provider_diagnostic.dart';
import 'package:tsmobile/src/models/images_model.dart';
import 'package:tsmobile/src/providers/tikets_provider.dart';
import 'dart:io';
import 'package:tsmobile/src/services/service_ticket_service.dart';
import 'package:http/http.dart' as http;
import 'package:tsmobile/src/widgets/images_loaders/image_loader.dart';

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
  late List<File> _images = [];
  late List<ImageData> _imagesSend = [];
  final ImagePicker _picker = ImagePicker();
  late Future<void> _loadTicketFuture;
  DateTime? _selectedDate;
  bool isDateInitialized = false;
  bool isObservationsInitialized = false;
  bool _isFormActive = false; // Variable para controlar el estado del formulario

  @override
  void initState() {
    super.initState();
    _loadTicketFuture = _loadTicketData();
  }

  Future<void> _loadTicketData() async {
    final ticketProvider = Provider.of<TicketProvider>(context, listen: false);
    await ticketProvider.loadTicketById(widget.idTicket);
    await _fetchImages();
  }

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
        _dateController.text = DateFormat('dd/MM/yyyy').format(picked);
      });
    }
  }

  Future<void> _pickImage() async {
    final imagePickerProvider = Provider.of<ImageProviderDiagnostic>(context, listen: false);
    imagePickerProvider.setImagePickerActive(true);

    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _images.add(File(image.path));
      });
    }

    imagePickerProvider.setImagePickerActive(false);
  }

  Future<void> _fetchImages() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('auth_token');
      if (token == null) {
        throw Exception('Token is null');
      }

      final response = await http.get(
        Uri.parse(
            'http://3.137.100.242:3000/api/v1/media?model_type=Ticket&model_id=${widget.idTicket}&collection_name=diagnostic'),
        headers: {
          'Content-Type': 'application/json',
          "Accept": "application/json",
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body)['data'];
        setState(() {
          _imagesSend = data.map((item) => ImageData.fromJson(item)).toList();
        });
      } else {
        print('Error fetching images: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching images: $e');
    }
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

  void _resetProvider() {
    Provider.of<ImageProviderDiagnostic>(context, listen: false).resetImage();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _fetchImages();
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
              _selectedDate = item.diagnosisDate;
              _dateController.text =
                  DateFormat('dd/MM/yyyy').format(_selectedDate!);
              isDateInitialized = true;
            }
            if (!isObservationsInitialized && item.diagnosisDetail != null) {
              _observationsController.text = item.diagnosisDetail ?? '';
              isObservationsInitialized = true;
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  child: Card(
                    color: Colors.white,
                    elevation: 10,
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
                                onPressed: _isFormActive
                                    ? () => _pickDate(context)
                                    : null,
                              ),
                            ),
                            readOnly: !_isFormActive,
                          ),
                          const SizedBox(height: 16),
                          TextField(
                            controller: _observationsController,
                            decoration: const InputDecoration(
                                labelText: 'Observaciones'),
                            readOnly: !_isFormActive,
                          ),
                          const SizedBox(height: 16),
                          ImageUploaderDiagnostic(
                            initialImages: _imagesSend,
                            showAddButton:
                                _isFormActive, // Mostrar o no el botón de añadir imágenes
                          ),
                          const SizedBox(height: 30),
                          Center(
                            child: ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: _isFormActive ? Colors.yellow : Colors.blue,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                              icon: Icon(
                                _isFormActive ? Icons.save : Icons.edit,
                                color: Colors.white,
                              ),
                              onPressed: () async {
                                if (_isFormActive) {
                                  // Validar que los campos no estén vacíos
                                  if (_dateController.text.isEmpty || _observationsController.text.isEmpty) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: const Text('Por favor, completa todos los campos.'),
                                      ),
                                    );
                                    return;
                                  }

                                  // Obtener imágenes del proveedor
                                  final imageProvider =
                                      Provider.of<ImageProviderDiagnostic>(
                                          context,
                                          listen: false);
                                  List<String> imagePaths =
                                      imageProvider.newImagePaths;
                                  List<File> imageFiles = imagePaths
                                      .map((path) => File(path))
                                      .toList();
                                  _resetProvider();
                                  if (_selectedDate != null) {
                                    bool success = await serviceUpdateTicket.saveFormData(
                                      _selectedDate!.toIso8601String(),
                                      _observationsController.text,
                                      imageFiles,
                                      widget.idTicket,
                                    );
                                      await _fetchImages();
                                    /*if (success) {
                                      await _fetchImages();
                                    }*/
                                    setState(() {
                                      _isFormActive = false;
                                      _imagesSend.clear();
                                      imageProvider.clearImages();
                                    });
                                    await ticketProvider.loadTicketById(widget.idTicket);
                                  } else {
                                    print('Por favor, selecciona una fecha.');
                                  }
                                } else {
                                  setState(() {
                                    _isFormActive = true;
                                  });
                                }
                              },
                              label: Text(
                                _isFormActive ? 'Guardar' : 'Editar',
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
              ],
            );
          }
        },
      ),
    );
  }
}