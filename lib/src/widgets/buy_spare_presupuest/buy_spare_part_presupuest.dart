import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tsmobile/src/models/images_model.dart';
import 'package:tsmobile/src/providers/provider_technical_buy_spare_parts.dart';
import 'package:tsmobile/src/services/send_file_service.dart';
import 'package:tsmobile/src/services/service_ticket_service.dart';
import 'package:tsmobile/src/widgets/images_loaders/image_uploader_buy_spare_part_technical.dart';
import 'package:tsmobile/src/widgets/images_loaders/image_uploader_spare_parts.dart';

class BuySparePartPresupuest extends StatefulWidget {
  final Map<String, dynamic> reparacion;
  final int visitId;
  final String name;
  final String observation;
  final double montoRepuesto;
  final int status; // Agregando el parámetro status

  BuySparePartPresupuest({
    required this.reparacion,
    required this.visitId,
    required this.name,
    required this.observation,
    required this.montoRepuesto,
    required this.status, // Nuevo parámetro
  });

  @override
  _BuySparePartState createState() => _BuySparePartState();
}

class _BuySparePartState extends State<BuySparePartPresupuest> {
  final ImagePicker _picker = ImagePicker();
  List<String> imagePaths = [];
  List<String> _imagesSend = [];

  late Map<String, dynamic> reparacion;
  late List<ImageData> _imagesInital = [];
  late List<ImageData> _imagesInitalSpareParts = [];

  late TextEditingController _montoController;

  @override
  void initState() {
    super.initState();
    _montoController =
        TextEditingController(text: widget.montoRepuesto.toString());
    _fetchImages();
    _fetchImagesBySparts();
    reparacion = Map<String, dynamic>.from(widget.reparacion);
  }

  @override
  void dispose() {
    _montoController.dispose();
    super.dispose();
  }

  Future<void> _pickImage(BuildContext context, String imageType) async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      if (mounted) {
        setState(() {
          if (imagePaths.length < 5) {
            imagePaths.add(pickedFile.path);
            reparacion[imageType] =
                pickedFile.path; // Actualizar el mapa mutable
          } else {
            _showToast(context, 'Solo se pueden cargar hasta 5 imágenes');
          }
        });
      }
    }
  }

  Future<void> _fetchImages() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('auth_token');
    final response = await http.get(
      Uri.parse(
          'http://3.137.100.242:3000/api/v1/media?model_type=PartRequest&model_id=${widget.visitId}&collection_name=budget'),
      headers: {
        'Content-Type': 'application/json',
        "Accept": "application/json",
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body)['data'];
      if (mounted) {
        setState(() {
          _imagesInital = data.map((item) => ImageData.fromJson(item)).toList();
        });
      }
    } else {
      print('Error fetching images: ${response.statusCode}');
    }
  }

  Future<void> _fetchImagesBySparts() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('auth_token');
    
    final response = await http.get(
      Uri.parse(
          'http://3.137.100.242:3000/api/v1/media?model_type=PartRequest&model_id=${widget.visitId}&collection_name=part'),
      headers: {
        'Content-Type': 'application/json',
        "Accept": "application/json",
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body)['data'];
      setState(() {
        _imagesInitalSpareParts =
            data.map((item) => ImageData.fromJson(item)).toList();
      });
    } else {
      print('Error fetching images: ${response.statusCode}');
    }
  }

 Future<void> sendUpdateDataVisitPartRequestPresupuest(
    Map<String, dynamic> data, int idTicket, List<String> imagePaths) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  String? token = prefs.getString('auth_token');
  print('data $data');

  try {
    final response = await http.put(
      Uri.parse('http://3.137.100.242:3000/api/v1/part-requests/${widget.visitId}'),
      headers: {
        'Content-Type': 'application/json',
        "Accept": "application/json",
        'Authorization': 'Bearer $token',
      },
      body: json.encode(data),
    );

    print('response ${response}');
    var jsonResponse = jsonDecode(response.body);

    if (response.statusCode == 200) {
      print('Presupuesto solicitado éxitosamente ${jsonResponse}');

      // Enviar imágenes
      for (String path in imagePaths) {
        await sendFile(File(path), 'PartRequest',
            jsonResponse['data']['id'].toString(), 'budget');
      }

      if (mounted) { setState(() {}); }

      Fluttertoast.showToast(
          msg: "Presupuesto creado exitosamente",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0);
    } else {
      print('Error al enviar los datos: ${response.statusCode}');
      print('Respuesta del servidor: ${response.body}');
      Fluttertoast.showToast(
          msg: "Error al enviar presupuesto",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  } catch (e) {
    print('Error al enviar la solicitud: $e');
    Fluttertoast.showToast(
        msg: "Error al crear la solicitud",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0);
  }
}

 

  Future<void> _submitForm() async {
    final data = {
      'status': 6,
      'budget_amount': double.parse(_montoController.text),
    };

    final imageProvider = Provider.of<ImageProviderTechnicalBuySpareParts>(
        context,
        listen: false);

    List<String> imagePaths = imageProvider.newImagePaths;
    List<File> imageFiles = imagePaths.map((path) => File(path)).toList();
    await sendUpdateDataVisitPartRequestPresupuest(
        data, widget.visitId, imagePaths);

    // Realizar reload general y resetear el provider de las imágenes
    imageProvider.clearImages();
    setState(() {
      _fetchImages();
      _fetchImagesBySparts();
    });
  }

  void _showToast(BuildContext context, String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ExpansionTile(
        title: Text('Compra de Repuesto'),
        children: [
          TextField(
            controller: _montoController,
            decoration: const InputDecoration(labelText: 'Costo del repuesto'),
            keyboardType: TextInputType.number,
            readOnly: widget.status ==
                6, // Deshabilitar para edición si el estado es 6
            onChanged: (value) {
              if (mounted) {
                setState(() {
                  reparacion['montoRepuesto'] = value;
                });
              }
            },
          ),
          ImageUploaderSpareParts(
            initialImages: _imagesInitalSpareParts,
            showAddButton: false,
          ),
          ImageUploaderBuySparePartTechnical(
            initialImages: _imagesInital,
            showAddButton:
                widget.status != 7, // Ocultar botón si el estado es 6
          ),
          const SizedBox(height: 10),
          if (widget.status != 7)
            ElevatedButton(
              onPressed: _submitForm,
              child: const Text('Enviar presupuesto'),
            ),
        ],
      ),
    );
  }
}
