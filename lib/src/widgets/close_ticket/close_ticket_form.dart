import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tsmobile/src/core/theme/app.styles.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tsmobile/src/providers/tikets_provider.dart';
import 'package:tsmobile/src/models/images_model.dart';
import 'package:tsmobile/src/providers/image_provider_close_ticket.dart';
import 'dart:io';
import 'package:tsmobile/src/services/service_ticket_service.dart';
import 'package:http/http.dart' as http;
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
  late List<File> _images = [];
  late List<ImageData> _imagesSend = [];
  final ImagePicker _picker = ImagePicker();
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
    final imagePickerProvider = Provider.of<ImageProviderCloseTicketManagement>(context, listen: false);
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
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('auth_token');
    final response = await http.get(
      Uri.parse(
          '${dotenv.env['API_URL']}media?model_type=Ticket&model_id=${widget.idTicket}&collection_name=closed'),
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
    Provider.of<ImageProviderCloseTicketManagement>(context, listen: false).resetImage();
  }

  String getFormattedDate(DateTime date) {
    var outputFormat = DateFormat('dd/MM/yyyy');
    return outputFormat.format(date);
  }

  @override
  void initState() {
    super.initState();
    _fetchImages();
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
                                    onPressed: _isFormActive
                                        ? () => _pickDate(context)
                                        : null,
                                  ),
                                ),
                                readOnly: !_isFormActive,
                              ),
                              const SizedBox(height: 16),
                              DropdownButtonFormField<String>(
                                decoration: const InputDecoration(
                                    labelText: 'Motivo de cierre'),
                                value: _selectedReason,
                                items: _reasons.map((String reason) {
                                  return DropdownMenuItem<String>(
                                    value: reason,
                                    child: Text(reason),
                                  );
                                }).toList(),
                                onChanged: _isFormActive
                                    ? (String? newValue) {
                                        setState(() {
                                          _selectedReason = newValue;
                                        });
                                      }
                                    : null,
                              ),
                              const SizedBox(height: 16),
                              TextField(
                                controller: _observationsController,
                                decoration: const InputDecoration(
                                    labelText: 'Observaciones'),
                                readOnly: !_isFormActive,
                              ),
                              const SizedBox(height: 16),
                              ImageUploaderCloseTicket(
                                initialImages: _imagesSend,
                                showAddButton: _isFormActive,
                              ),
                              const SizedBox(height: 30),
                              Center(
                                child: ElevatedButton.icon(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: _isFormActive
                                        ? Colors.yellow
                                        : Colors.blue,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                  ),
                                  icon: Icon(
                                      _isFormActive ? Icons.save : Icons.edit,
                                      size: 18,
                                      color: Colors.white),
                                  onPressed: () async {
                                    if (_isFormActive) {
                                      if (_selectedDate != null &&
                                          _selectedReason != null) {
                                        // Obtener imágenes del proveedor
                                        final imageProvider =
                                            Provider.of<ImageProviderCloseTicketManagement>(
                                                context,
                                                listen: false);
                                        List<String> imagePaths =
                                            imageProvider.newImagePaths;
                                        List<File> imageFiles = imagePaths
                                            .map((path) => File(path))
                                            .toList();
                                        _resetProvider();
                                        try {
                                          await serviceUpdateTicket
                                              .savecloseTicketFormData(
                                            _selectedDate!.toIso8601String(),
                                            _observationsController.text,
                                            imageFiles,
                                            widget.idTicket,
                                          );
                                          Fluttertoast.showToast(
                                            msg: "Datos guardados con éxito",
                                            toastLength: Toast.LENGTH_SHORT,
                                            gravity: ToastGravity.BOTTOM,
                                            timeInSecForIosWeb: 1,
                                            backgroundColor: Colors.green,
                                            textColor: Colors.white,
                                            fontSize: 16.0,
                                          );
                                          setState(() {
                                            _isFormActive = false;
                                            _imagesSend.clear();
                                            imageProvider.clearImages();
                                          });
                                          _fetchImages();
                                          final ticketProvider =
                                              Provider.of<TicketProvider>(
                                                  context,
                                                  listen: false);
                                          _loadTicketFuture = ticketProvider
                                              .loadTicketById(widget.idTicket);
                                        } catch (e) {
                                          Fluttertoast.showToast(
                                            msg: "Error al guardar los datos",
                                            toastLength: Toast.LENGTH_SHORT,
                                            gravity: ToastGravity.BOTTOM,
                                            timeInSecForIosWeb: 1,
                                            backgroundColor: Colors.red,
                                            textColor: Colors.white,
                                            fontSize: 16.0,
                                          );
                                        }
                                      } else {
                                        Fluttertoast.showToast(
                                          msg: "Por favor, selecciona una fecha y un motivo.",
                                          toastLength: Toast.LENGTH_SHORT,
                                          gravity: ToastGravity.BOTTOM,
                                          timeInSecForIosWeb: 1,
                                          backgroundColor: Colors.red,
                                          textColor: Colors.white,
                                          fontSize: 16.0,
                                        );
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