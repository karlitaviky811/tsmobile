import 'dart:convert';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tsmobile/src/models/images_model.dart';
import 'package:tsmobile/src/services/send_file_service.dart';
import 'package:tsmobile/src/services/service_ticket_service.dart';
import 'package:tsmobile/src/widgets/images_loaders/image_uploader_spare_parts.dart';

class BuySparePartInitial extends StatefulWidget {
  final Map<String, dynamic> reparacion;
  final int visitId;
  final String name;
  final String observation;

  BuySparePartInitial({
    required this.reparacion,
    required this.visitId,
    required this.name,
    required this.observation,
  });

  @override
  _BuySparePartInitialState createState() => _BuySparePartInitialState();
}

class _BuySparePartInitialState extends State<BuySparePartInitial> {
  final ImagePicker _picker = ImagePicker();
  List<String> imagePaths = [];
  late Map<String, dynamic> reparacion;

  @override
  void initState() {
    super.initState();
    reparacion = Map<String, dynamic>.from(widget.reparacion);
  }

  Future<List<ImageData>> _fetchImages() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('auth_token');
    final response = await http.get(
      Uri.parse('http://3.137.100.242:3000/api/v1/media?model_type=PartRequest&model_id=${widget.visitId}&collection_name=part'),
      headers: {
        'Content-Type': 'application/json',
        "Accept": "application/json",
        'Authorization': 'Bearer $token',
      },
    );

      print('response ${response}');
      var jsonResponse = jsonDecode(response.body);

      if (jsonResponse['success'] == true) {
      List<dynamic> data = json.decode(response.body)['data'];
      return data.map((item) => ImageData.fromJson(item)).toList();
    } else {
      print('Error fetching images: ${response.statusCode}');
      return [];
    }
  }

  Future<void> sendUpdateDataVisitPartRequestPresupuest(
      Map<String, dynamic> data, int idTicket, List<String> imagePaths) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('auth_token');
    print('data $data $apiUrl');

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
      var jsonResponse = jsonDecode(response.body);
      print('response ${response} ${jsonResponse['success'] == true}');


      if (jsonResponse['success'] == true) {
        print('Presupuesto solicitado éxitosamente ${jsonResponse}');

        // Enviar imágenes
        for (String path in imagePaths) {
          await sendFile(File(path), 'PartRequest',
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
        if (mounted) {
          setState(() {});
        }

     
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

 /* Future<void> sendFile(String path, String modelType, String modelId,
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
  }*/

  Future<void> _submitForm() async {
    final data = {
      'status': 6,
      'budget_amount': reparacion['montoRepuesto'],
    };
//cuidado con el perro
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
    return FutureBuilder<List<ImageData>>(
      future: _fetchImages(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('No hay imágenes disponibles.'));
        } else {
          final images = snapshot.data!;
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: ExpansionTile(
              title: Text('Imagenes del repuesto solicitado'),
              children: [
                ImageUploaderSpareParts(
                  initialImages: images,
                  showAddButton: false,
                )
              ],
            ),
          );
        }
      },
    );
  }
}
