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
import 'package:tsmobile/src/widgets/images_loaders/image_uploader_buy_spare_part_technical.dart';
import 'package:tsmobile/src/widgets/images_loaders/image_uploader_spare_parts.dart';

class BuySparePartPresupuest extends StatefulWidget {
  final Map<String, dynamic> reparacion;
  final int requestId;
  final String name;
  final String observation;
  final double montoRepuesto;
  final int status;

  BuySparePartPresupuest({
    required this.reparacion,
    required this.requestId,
    required this.name,
    required this.observation,
    required this.montoRepuesto,
    required this.status,
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
    _montoController = TextEditingController(text: widget.montoRepuesto.toString());
    _fetchAllImages();
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
            reparacion[imageType] = pickedFile.path; // Actualizar el mapa mutable
          } else {
            _showToast(context, 'Solo se pueden cargar hasta 5 imágenes');
          }
        });
      }
    }
  }

  Future<Map<String, List<ImageData>>> _fetchAllImages() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('auth_token');

    final budgetResponse = await http.get(
      Uri.parse(
          'http://3.137.100.242:3000/api/v1/media?model_type=PartRequest&model_id=${widget.requestId}&collection_name=budget'),
      headers: {
        'Content-Type': 'application/json',
        "Accept": "application/json",
        'Authorization': 'Bearer $token',
      },
    );

    final partResponse = await http.get(
      Uri.parse(
          'http://3.137.100.242:3000/api/v1/media?model_type=PartRequest&model_id=${widget.requestId}&collection_name=part'),
      headers: {
        'Content-Type': 'application/json',
        "Accept": "application/json",
        'Authorization': 'Bearer $token',
      },
    );

    if (budgetResponse.statusCode == 200 && partResponse.statusCode == 200) {
      List<dynamic> budgetData = json.decode(budgetResponse.body)['data'];
      List<dynamic> partData = json.decode(partResponse.body)['data'];

      return {
        'budget': budgetData.map((item) => ImageData.fromJson(item)).toList(),
        'part': partData.map((item) => ImageData.fromJson(item)).toList(),
      };
    } else {
      throw Exception('Error fetching images');
    }
  }

  Future<void> sendUpdateDataVisitPartRequestPresupuest(
      Map<String, dynamic> data, int idTicket, List<String> imagePaths) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('auth_token');
    print('data $data');

    try {
      final response = await http.put(
        Uri.parse(
            'http://3.137.100.242:3000/api/v1/part-requests/${widget.requestId}'),
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

        if (mounted) {
          setState(() {});
        }

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
        data, widget.requestId, imagePaths);

    // Realizar reload general y resetear el provider de las imágenes
    imageProvider.clearImages();
    setState(() {
      _fetchAllImages();
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
    return FutureBuilder<Map<String, List<ImageData>>>(
      future: _fetchAllImages(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No hay imágenes disponibles.'));
        } else {
          final budgetImages = snapshot.data!['budget']!;
          final partImages = snapshot.data!['part']!;
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: ExpansionTile(
              title: const Text('Compra de Repuesto'),
              children: [
                ImageUploaderSpareParts(
                  initialImages: partImages,
                  showAddButton: false,
                ),
                TextField(
                  controller: _montoController,
                  decoration: const InputDecoration(labelText: 'Costo del repuesto'),
                  keyboardType: TextInputType.number,
                  readOnly: widget.status == 6, // Deshabilitar para edición si el estado es 6
                  onChanged: (value) {
                    if (mounted) {
                      setState(() {
                        reparacion['montoRepuesto'] = value;
                      });
                    }
                  },
                ),
                ImageUploaderBuySparePartTechnical(
                  initialImages: budgetImages,
                  showAddButton: widget.status != 7, // Ocultar botón si el estado es 6
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
      },
    );
  }
}