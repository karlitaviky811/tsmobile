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
import 'package:tsmobile/src/providers/provider_invoice_spare_parts.dart';
import 'package:tsmobile/src/providers/provider_technical_buy_spare_parts.dart';

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

        final imageProviderSpareParts =
            Provider.of<ImageProviderSpareParts>(context, listen: false);

        final imageProviderTechnicalBuySpareParts =
            Provider.of<ImageProviderTechnicalBuySpareParts>(context,
                listen: false);

        final imageProviderTechnicalInvoice =
            Provider.of<ImageProviderTechnicalInvoice>(context, listen: false);

        setState(() {
          imageProviderSpareParts.clearImages();
          imageProviderSpareParts.clearImages();
          imageProviderTechnicalBuySpareParts.clearImages();
        });
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

  Future<void> _submitForm() async {
    if (_repuestoController.text.isEmpty ||
        _comentariosGeneralesController.text.isEmpty) {
      _showToast('Por favor, complete todos los campos.');
      return;
    }

    setState(() {
      _isSubmitting = true; // Mostrar indicador de envío
    });

    // Implementa tu lógica de guardado aquí await
    Future.delayed(const Duration(seconds: 2));

    Map<String, dynamic> repuestos = {
      "technical_visit_id": widget.visit.id,
      "name": _repuestoController.text,
      "observation": _comentariosGeneralesController.text,
    };
    final imageProvider =
        Provider.of<ImageProviderSpareParts>(context, listen: false);
    List<String> imagePaths = imageProvider.newImagePaths;
    List<File> imageFiles = imagePaths.map((path) => File(path)).toList();
    print('images $imageFiles');
    var serviceVisit = VisitService();
    var res = await serviceVisit.sendUpdateDataVisitPartRequest(
        repuestos, widget.visit.id, imageFiles);

    setState(() {
      _isSubmitting = false; // Ocultar indicador de envío
    });
    //_fetchPartRequests();
    Navigator.pop(context); // Cerrar el modal después del envío
    _fetchPartRequests();
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
                initialImages: [],
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
                child: const Text('Solicitar nuevo repuesto',
                    style: TextStyle(color: Colors.white)),
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
                              return Column(
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
                                          subtitle: Text(
                                            request.observation,
                                            style: AppStyle
                                                .txtPoppinsRegular12Gray,
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
                                            visitId: 3,
                                            //status: request.status,
                                          ),
                                        if (request.status == 5)
                                          Column(
                                            children: [
                                              BuySparePartPresupuest(
                                                status: 1,
                                                name: _repuestoController.text,
                                                montoRepuesto:
                                                    request.budgetAmount ?? 0.0,
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
                                                requestId: request.id,
                                                //status: request.status,
                                              ),
                                              FutureBuilder<List<ImageData>>(
                                                future: getImagesForRequest(
                                                    request.id),
                                                builder: (context, snapshot) {
                                                  if (snapshot
                                                          .connectionState ==
                                                      ConnectionState.waiting) {
                                                    return const CircularProgressIndicator();
                                                  } else if (snapshot
                                                      .hasError) {
                                                    return const Text(
                                                        'Error al cargar imágenes');
                                                  } else if (!snapshot
                                                          .hasData ||
                                                      snapshot.data!.isEmpty) {
                                                    return const Text(
                                                        'No hay imágenes disponibles');
                                                  }

                                                  final initialImages =
                                                      snapshot.data!;
                                                  return ChangeNotifierProvider(
                                                    create: (_) =>
                                                        ImageProviderSpareParts(),
                                                    child:
                                                        ImageUploaderSpareParts(
                                                            showAddButton: true,
                                                            initialImages:
                                                                initialImages),
                                                  );
                                                },
                                              ),
                                            ],
                                          ),
                                        if (request.status == 6)
                                          Column(
                                            children: [
                                              BuySparePartPresupuest(
                                                status: 6,
                                                requestId: request.id,
                                                name: _repuestoController.text,
                                                observation:
                                                    _comentariosGeneralesController
                                                        .text,
                                                montoRepuesto:
                                                    request.budgetAmount ?? 0.0,
                                                reparacion: {
                                                  'nombreRepuesto':
                                                      request.name ?? '',
                                                  'montoRepuesto':
                                                      request.budgetAmount,
                                                  'presupuestoRepuesto': '',
                                                },
                                                //status: request.status,
                                              ),
                                            ],
                                          ),
                                        if (request.status == 1)
                                          InvoiceSparePart(
                                              visitId: request.id,
                                              initialImages: []),
                                        if (request.status == 8)
                                          InvoiceSparePartFinal(
                                            showButtons: false,
                                            budgetAmount:
                                                request.budgetAmount ?? 0.0,
                                            requestId: request.id.toString(),
                                            initialImages: [],
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
