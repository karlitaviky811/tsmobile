import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tsmobile/src/core/theme/app.styles.dart';
import 'package:tsmobile/src/models/images_model.dart';
import 'package:tsmobile/src/models/part_request.dart';
import 'package:http/http.dart' as http;
import 'package:tsmobile/src/models/visit_model.dart';
import 'package:tsmobile/src/providers/image_provider_spare_parts.dart';
import 'package:tsmobile/src/widgets/buy_spare_part.dart';
import 'package:tsmobile/src/services/tecnical_visitis_service.dart';
import 'package:tsmobile/src/widgets/image_uploader_spare_parts.dart';

class RepuestoScreen extends StatefulWidget {
  final Visit visit;

  RepuestoScreen({required this.visit});

  @override
  _RepuestoScreenState createState() => _RepuestoScreenState();
}

class _RepuestoScreenState extends State<RepuestoScreen> {
  List<Repuesto> repuestos = [];
  String repuestoName = '';
  List<String> imagePaths = [];
  List<Repuesto> partRequests = [];

  bool _isSubmitting = false;
  TextEditingController _repuestoController = TextEditingController();
  TextEditingController _comentariosGeneralesController =
      TextEditingController();
  bool _isLoading = true; // Añadir estado de carga
  @override
  void initState() {
    super.initState();
    _fetchPartRequests();
  }

  Color _getChipColor(int estado) {
    switch (estado) {
      case 1:
        return Colors.lightBlue.shade300;
      case 2:
        return Colors.lightGreen.shade300;
      case 3:
        return Colors.deepOrange.shade200;
      case 4:
        return Colors.deepPurple.shade200;
      case 5:
        return Colors.pink.shade200;
      default:
        return Colors.grey.shade300;
    }
  }

  IconData _getChipIcon(int estado) {
    switch (estado) {
      case 1:
        return Icons.create;
      case 2:
        return Icons.check_circle;
      case 3:
        return Icons.work;
      case 4:
        return Icons.done;
      case 5:
        return Icons.close;
      default:
        return Icons.info;
    }
  }

  Future<void> _fetchPartRequests() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('auth_token');
    final response = await http.get(
      Uri.parse(
          'http://3.137.100.242:3000/api/v1/part-requests?technical_visit_id=${widget.visit.id}&page=1'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      if (data.containsKey('data')) {
        final List<dynamic> partRequestsJson = data['data'];
        setState(() {
          partRequests =
              partRequestsJson.map((json) => Repuesto.fromJson(json)).toList();
        });
      }
      _isLoading = false;
    } else {
      print('Error fetching part requests: ${response.body}');
    }
  }

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        imagePaths.add(pickedFile.path);
      });
    }
  }

  void _showToast(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        action: SnackBarAction(
          label: 'OK',
          onPressed: ScaffoldMessenger.of(context).hideCurrentSnackBar,
        ),
      ),
    );
  }

  Future<void> _submitForm() async {
    if (_repuestoController.text.isEmpty ||
        _comentariosGeneralesController.text.isEmpty) {
      _showToast('Por favor, complete todos los campos.');
      return;
    }

    setState(() {
      _isSubmitting = true; // Mostrar indicador de envío
    });

    Map<String, dynamic> repuestos = {
      "technical_visit_id": widget.visit.id,
      "name": _repuestoController.text,
      "observation": _comentariosGeneralesController.text,
    };
    final imageProvider =
        Provider.of<ImageProviderSpareParts>(context, listen: false);
    List<String> imagePaths = imageProvider.newImagePaths;
    List<File> imageFiles = imagePaths.map((path) => File(path)).toList();
    var serviceVisit = VisitService();
    var res = await serviceVisit.sendUpdateDataVisitPartRequest(
        repuestos, widget.visit.id, imageFiles);

    setState(() {
      _isSubmitting = false; // Ocultar indicador de envío
    });

    Navigator.pop(context); // Cerrar el modal después del envío
  }

  void _openRepuestoForm() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Solcitud de repuesto',
                  style: AppStyle.txtPoppinsBold14Black),
              const SizedBox(height: 10),
              const Text('Información necesaria'),
              TextField(
                decoration: const InputDecoration(
                  labelText: 'Nombre del repuesto',
                  labelStyle: TextStyle(color: Colors.black54, fontSize: 16),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey, width: 1),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Color(0xff051937), width: 1),
                  ),
                ),
                controller: _repuestoController,
              ),
              const SizedBox(height: 10),
              TextField(
                decoration: const InputDecoration(
                  labelText: 'Observaciones',
                  labelStyle: TextStyle(color: Colors.black54, fontSize: 16),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey, width: 1),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Color(0xff051937), width: 1),
                  ),
                ),
                controller: _comentariosGeneralesController,
              ),
              const SizedBox(height: 10),
              ImageUploaderSpareParts(
                initialImages: [],
              ),
              const SizedBox(height: 10),
              _isSubmitting // Mostrar el indicador de carga mientras se envía el formulario
                  ? CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: _submitForm,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xff051937),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text('Enviar solicitud',
                          style: TextStyle(color: Colors.white)),
                    ),
            ],
          ),
        );
      },
    );
  }

  Future<List<ImageData>> getImagesForRequest(int requestPart) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('auth_token');

    final response = await http.get(
      Uri.parse(
          'http://3.137.100.242:3000/api/v1/media?model_type=PartRequest&model_id=$requestPart&collection_name=part'),
      headers: {
        'Content-Type': 'application/json',
        "Accept": "application/json",
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body)['data'];
      return data.map((item) => ImageData.fromJson(item)).toList();
    } else {
      // Manejar errores
      print('Error fetching images: ${response.statusCode}');
      return []; // Retornar una lista vacía en caso de error
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        child: Card(
          color: Colors.white,
          elevation: 20,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            children: [
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: _openRepuestoForm,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xff051937),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text('Solicitar nuevo repuesto',
                    style: TextStyle(color: Colors.white)),
              ),
              _isLoading
                  ? CircularProgressIndicator() // Mostrar indicador de carga
                  : partRequests.isEmpty
                      ? const Text('No hay solicitudes de repuesto.')
                      : Expanded(
                          child: ListView.builder(
                            itemCount: partRequests.length,
                            itemBuilder: (context, index) {
                              final request = partRequests[index];

                              return Column(
                                children: [
                                  Card(
                                    margin: EdgeInsets.all(8.0),
                                    color: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Column(
                                      children: [
                                        ListTile(
                                          leading: Icon(
                                            Icons.build,
                                            color:
                                                _getChipColor(request.status),
                                          ),
                                          title: Text(
                                            request.name ??
                                                'Repuesto Desconocido',
                                            style: AppStyle
                                                .txtPoppinsRegular12Gray,
                                          ),
                                          subtitle: Text(
                                            request.observation,
                                            style: AppStyle
                                                .txtPoppinsRegular12Gray,
                                          ),
                                          trailing: Chip(
                                            label: Text(
                                              request.status == 1
                                                  ? 'Solicitado'
                                                  : 'Entregado',
                                              style: const TextStyle(
                                                  color: Colors.white),
                                            ),
                                            backgroundColor:
                                                _getChipColor(request.status),
                                            avatar: Icon(
                                              _getChipIcon(request.status),
                                              color: Colors.white,
                                            ),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(25.0),
                                              side: const BorderSide(
                                                  color: Colors.transparent),
                                            ),
                                          ),
                                        ),
                                        FutureBuilder<List<ImageData>>(
                                          future:
                                              getImagesForRequest(request.id),
                                          builder: (context, snapshot) {
                                            if (snapshot.connectionState ==
                                                ConnectionState.waiting) {
                                              return CircularProgressIndicator();
                                            } else if (snapshot.hasError) {
                                              return Text(
                                                  'Error al cargar imágenes');
                                            } else if (!snapshot.hasData ||
                                                snapshot.data!.isEmpty) {
                                              return Text(
                                                  'No hay imágenes disponibles');
                                            }

                                            final initialImages =
                                                snapshot.data!;
                                            return ChangeNotifierProvider(
                                              create: (_) =>
                                                  ImageProviderSpareParts(),
                                              child: ImageUploaderSpareParts(
                                                  showAddButton:
                                                      request.status == 2,
                                                  initialImages: initialImages),
                                            );
                                          },
                                        ),
                                        if (request.status == 1)
                                          BuySparePart(
                                            visitId: request.id,
                                            name: _repuestoController.text,
                                            observation:
                                                _comentariosGeneralesController
                                                    .text,
                                            reparacion: {
                                              'nombreRepuesto':
                                                  request.name ?? '',
                                              'montoRepuesto': '',
                                              'presupuestoRepuesto': '',
                                            },
                                          ),
                                      ],
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
            ],
          ),
        ),
      ),
    );
  }
}
