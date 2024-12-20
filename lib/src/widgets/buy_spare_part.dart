import 'dart:convert';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tsmobile/src/models/images_model.dart';
import 'package:tsmobile/src/services/service_ticket_service.dart';
import 'package:tsmobile/src/widgets/image_uploader_buy_spare_part_technical.dart';

class BuySparePart extends StatefulWidget {
  final Map<String, dynamic> reparacion;
  final int visitId;
  final String name;
  final String observation;

  BuySparePart({
    required this.reparacion,
    required this.visitId,
    required this.name,
    required this.observation,
  });

  @override
  _BuySparePartState createState() => _BuySparePartState();
}

class _BuySparePartState extends State<BuySparePart> {
  final ImagePicker _picker = ImagePicker();
  List<String> imagePaths = [];
  late Map<String, dynamic> reparacion;
  late List<ImageData> _imagesSend = [];
  @override
  void initState() {
    super.initState();
    reparacion = Map<String, dynamic>.from(widget.reparacion);
  }

  Future<void> _pickImage(BuildContext context, String imageType) async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
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
      setState(() {
        _imagesSend = data.map((item) => ImageData.fromJson(item)).toList();
      });
    } else {
      print('Error fetching images: ${response.statusCode}');
    }
  }

  Future<void> sendUpdateDataVisitPartRequestPresupuest(
      Map<String, dynamic> data, int idTicket, List<String> imagePaths) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('auth_token');
    print('data $data $apiUrl');

    try {
      final response = await http.put(
        Uri.parse(
            'http://3.137.100.242:3000/api/v1/part-requests/${widget.visitId}'),
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
          await sendFile(path, 'PartRequest',
              jsonResponse['data']['id'].toString(), 'budget');
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

  Future<void> sendFile(String path, String modelType, String modelId,
      String collectionName) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('auth_token');

    var request = http.MultipartRequest(
        'POST', Uri.parse('http://3.137.100.242:3000/api/v1/media'));
    request.headers['Authorization'] = 'Bearer $token';
    request.fields['model_type'] = modelType;
    request.fields['model_id'] = modelId;
    request.fields['collection_name'] = collectionName;
    request.files.add(await http.MultipartFile.fromPath('file', path));

    var response = await request.send();

    if (response.statusCode == 200) {
      print('Archivo enviado correctamente');
    } else {
      print('Error al enviar archivo: ${response.statusCode}');
    }
  }

  Future<void> _submitForm() async {
    final data = {
      'status': 6,
      'budget_amount': reparacion['montoRepuesto'],
    };

    await sendUpdateDataVisitPartRequestPresupuest(data, widget.visitId, []);
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
            decoration: const InputDecoration(labelText: 'Costo del repuesto'),
            onChanged: (value) {
              setState(() {
                reparacion['montoRepuesto'] = value;
              });
            },
          ),
          ElevatedButton(
            onPressed: _submitForm,
            child: const Text('Enviar presupuesto'),
          ),
          ImageUploaderBuySparePartTechnical(
            initialImages: _imagesSend,
          )
        ],
      ),
    );
  }
}
