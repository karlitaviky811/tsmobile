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
import 'package:tsmobile/src/providers/image_provider_new.dart';
import 'package:tsmobile/src/providers/image_provider_spare_parts.dart';
import 'package:tsmobile/src/providers/provider_invoice_spare_parts.dart';
import 'package:tsmobile/src/providers/provider_technical_buy_spare_parts.dart';
import 'package:tsmobile/src/services/send_file_service.dart';

import 'package:tsmobile/src/services/tecnical_visitis_service.dart';
import 'package:tsmobile/src/widgets/buy_spare_parts/buy_spare_part.dart';
import 'package:tsmobile/src/widgets/buy_spare_presupuest/buy_spare_part_presupuest.dart';
import 'package:tsmobile/src/widgets/final_report_buy_parts/final_report_buy_parts.dart';
import 'package:tsmobile/src/widgets/image_uploader_new.dart';
import 'package:tsmobile/src/widgets/images_loaders/image_uploader_spare_parts.dart';
import 'package:tsmobile/src/widgets/invoice_spare_parts/invoice_spare_parts.dart';

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
  final ImagePicker _picker = ImagePicker();
  final Map<int, List<String>> _imagePaths = {};
  bool _isSubmitting = false;
  bool _isImagePickerActive = false;
  final TextEditingController _repuestoController = TextEditingController();
  final TextEditingController _comentariosGeneralesController =
      TextEditingController();

  bool _isLoading = true; // Añadir estado de carga
  @override
  void initState() {
    super.initState();
    _fetchPartRequests();
  }

  Future<void> _fetchPartRequests() async {
    setState(() {
      _isLoading = true;
    });
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

    final responseBody = json.decode(response.body);
    print('response $responseBody');

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      if (data.containsKey('data')) {
        final List<dynamic> partRequestsJson = data['data'];
        if (mounted) {
          setState(() {
            partRequests = partRequestsJson
                .map((json) => Repuesto.fromJson(json))
                .toList();
            _isLoading = false;
          });
        }
      }
    } else {
      print('Error fetching part requests: ${response.body}');
      if (mounted) {
        setState(() {
          partRequests = [];
          _isLoading = false;
        });
      }
    }
  }

  void _pickImage(int index, ImageProviderSpareParts imageProvider) async {
    if (_isImagePickerActive) return; // No abrir si ya está activo
    _isImagePickerActive = true;
    try {
      final pickedFile =
          await ImagePicker().pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        imageProvider.addImage(pickedFile.path);
      }
    } catch (e) {
      print('Error picking image: $e');
    } finally {
      _isImagePickerActive = false;
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

  String _getStatusLabel(int status) {
    switch (status) {
      case 1:
        return 'Nueva solicitud';
      case 2:
        return 'Repuesto aprobado';
      case 3:
        return 'Repuesto rechazado';
      case 4:
        return 'Entregado';
      case 5:
        return 'Compra requerida';
      case 6:
        return 'Presupuesto nuevo';
      case 7:
        return 'Presupuesto aprobado';
      case 8:
        return 'Repuesto comprado';
      default:
        return 'Desconocido';
    }
  }

  Color _getChipColor(int status) {
    switch (status) {
      case 1:
        return Colors.blue;
      case 2:
        return Colors.green;
      case 3:
        return Colors.red;
      case 4:
        return Colors.purple;
      case 5:
        return Colors.orange;
      case 6:
        return Colors.amber;
      case 7:
        return Colors.teal;
      case 8:
        return Colors.indigo;
      default:
        return Colors.grey;
    }
  }

  IconData _getChipIcon(int status) {
    switch (status) {
      case 1:
        return Icons.new_releases;
      case 2:
        return Icons.check_circle;
      case 3:
        return Icons.cancel;
      case 4:
        return Icons.local_shipping;
      case 5:
        return Icons.shopping_cart;
      case 6:
        return Icons.attach_money;
      case 7:
        return Icons.approval;
      case 8:
        return Icons.shopping_bag;
      default:
        return Icons.help;
    }
  }

  Future<void> _submitForm2() async {
    final imageProvider =
        Provider.of<ImageProviderSparePartsNew>(context, listen: false);
    final List<File> imageFiles =
        imageProvider.newImagePaths.map((path) => File(path)).toList();
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

    var serviceVisit = VisitService();
    print('iamges files ${imageFiles}');

    var res = await serviceVisit.sendUpdateDataVisitPartRequest(
        repuestos, widget.visit.id, imageFiles);

    if (res) {
      _fetchPartRequests();
    }
    setState(() {
      _isSubmitting = false; // Ocultar indicador de envío
    });

    Navigator.pop(context); // Cerrar el modal después del envío
  }

// Variable para manejar el estado de envío

  void _submitForm() async {
    setState(() {
      _isSubmitting = true; // Mostrar indicador de carga
    });

    final imageProvider =
        Provider.of<ImageProviderSparePartsNew>(context, listen: false);
    final List<File> imageFiles =
        imageProvider.newImagePaths.map((path) => File(path)).toList();
    if (_repuestoController.text.isEmpty ||
        _comentariosGeneralesController.text.isEmpty) {
      _showToast('Por favor, complete todos los campos.');
      return;
    }

    // Mostrar el diálogo de carga
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
    try {
      // Simulación de envío de datos
      // Aquí debes agregar tu lógica de envío, por ejemplo:
      // final response = await sendRequest({...});

      // Simular una breve espera para el ejemplo

      var serviceVisit = VisitService();
      print('iamges files ${imageFiles}');

      Map<String, dynamic> repuestos = {
        "technical_visit_id": widget.visit.id,
        "name": _repuestoController.text,
        "observation": _comentariosGeneralesController.text,
      };
      var res = await serviceVisit.sendUpdateDataVisitPartRequest(
          repuestos, widget.visit.id, imageFiles);
      // Luego de obtener la respuesta del servicio, limpiar los controladores
      _repuestoController.clear();
      _comentariosGeneralesController.clear();
      // Limpiar las imágenes cargadas
      Provider.of<ImageProviderSparePartsNew>(context, listen: false)
          .clearImages();

      // Mostrar un mensaje de éxito
      Fluttertoast.showToast(
        msg: "Solicitud enviada exitosamente",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      await _fetchPartRequests();
    } catch (e) {
      // Manejo de errores
      print('Error al enviar la solicitud: $e');
      Fluttertoast.showToast(
        msg: "Error al enviar la solicitud",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    } finally {
      setState(() {
        _isSubmitting = false; // Ocultar indicador de carga
      });

      // Cerrar el diálogo de carga
      Navigator.of(context).pop();

      // Cerrar el modal bottom sheet
      Navigator.of(context).pop();
    }
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
              ImageUploaderSparePartsNew(
                initialImages: const [],
              ),
              const SizedBox(height: 10),
              _isSubmitting // Mostrar el indicador de carga mientras se envía el formulario
                  ? const CircularProgressIndicator()
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

  bool _isUrl(String path) {
    try {
      Uri uri = Uri.parse(path);
      return uri.isAbsolute && (uri.scheme == 'http' || uri.scheme == 'https');
    } catch (e) {
      return false;
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
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: _openRepuestoForm,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xff051937),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Icon(Icons.add, color: Colors.white),
                    SizedBox(
                        width: 8), // Espacio entre el icono y el texto
                    Text(
                      'Solicitar nuevo repuesto',
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
              _isLoading
                  ? const CircularProgressIndicator()
                  : partRequests.isEmpty
                      ? const Text('No hay solicitudes de repuesto.')
                      : Expanded(
                          child: ListView.builder(
                            itemCount: partRequests.length,
                            itemBuilder: (context, index) {
                              final request = partRequests[index];
                              return ChangeNotifierProvider(
                                create: (_) => ImageProviderSpareParts(),
                                child: Column(
                                  children: [
                                    Card(
                                      margin: const EdgeInsets.all(8.0),
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
                                            subtitle: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  request.observation,
                                                  style: AppStyle
                                                      .txtPoppinsRegular12Gray,
                                                ),
                                                /*Consumer<ImageProviderSpareParts>(
                                                  builder: (context, imageProvider, child) {
                                                    return Wrap(
                                                      children: imageProvider.initialImagePaths.isEmpty && imageProvider.newImagePaths.isEmpty
                                                          ? [Text('No hay imágenes disponibles')]
                                                          : [
                                                              Container()
                                                            ],
                                                    );
                                                  },
                                                ),*/
                                              ],
                                            ),
                                            trailing: Chip(
                                              label: Text(
                                                _getStatusLabel(request.status),
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
                                            onTap: () {
                                              final imageProvider = Provider.of<
                                                      ImageProviderSpareParts>(
                                                  context,
                                                  listen: false);
                                              _pickImage(index, imageProvider);
                                            },
                                          ),
                                          if (request.status == 1)
                                            BuySparePartInitial(
                                              name: _repuestoController.text,
                                              observation:
                                                  _comentariosGeneralesController
                                                      .text,
                                              reparacion: {
                                                'nombreRepuesto':
                                                    request.name ?? '',
                                                'montoRepuesto':
                                                    request.budgetAmount,
                                                'presupuestoRepuesto': '',
                                              },
                                              visitId: request.id,
                                              //status: request.status,
                                            ),
                                          if (request.status == 5 ||
                                              request.status == 6)
                                            Column(
                                              children: [
                                                BuySparePartPresupuest(
                                                  requestId: request.id,
                                                  status: 1,
                                                  name:
                                                      _repuestoController.text,
                                                  montoRepuesto:
                                                      request.budgetAmount ??
                                                          0.0,
                                                  observation:
                                                      _comentariosGeneralesController
                                                          .text,
                                                  reparacion: {
                                                    'nombreRepuesto':
                                                        request.name ?? '',
                                                    'montoRepuesto':
                                                        request.budgetAmount ??
                                                            0.0,
                                                    'presupuestoRepuesto': '',
                                                  },
                                                  //status: request.status,
                                                )
                                              ],
                                            ),
                                          /*if (request.status == 7)
                                            InvoiceSparePart(
                                              visitId: request.id,
                                              initialImages: const [],
                                            ),*/
                                          if (request.status == 8 || request.status == 7)
                                            InvoiceSparePartFinal(
                                              showButtons: request.status == 7 ? true : false,
                                              requestId: request.id.toString(),
                                              initialImages: const [],
                                              budgetAmount:
                                                  request.budgetAmount ?? 0.0,
                                            ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
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
