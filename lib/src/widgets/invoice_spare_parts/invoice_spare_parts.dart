import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tsmobile/src/models/images_model.dart';
import 'package:tsmobile/src/providers/provider_invoice_spare_parts.dart';
import 'package:tsmobile/src/services/send_file_service.dart';
import 'package:tsmobile/src/widgets/images_loaders/image_uploader_invoice_spare_parts.dart';
import 'package:http/http.dart' as http;

class InvoiceSparePart extends StatefulWidget {
  final int visitId;
  final List<ImageData> initialImages;

  InvoiceSparePart({
    required this.visitId,
    required this.initialImages,
  });

  @override
  _InvoiceSparePartState createState() => _InvoiceSparePartState();
}

class _InvoiceSparePartState extends State<InvoiceSparePart> {
  List<String> imagePaths = [];
  late List<ImageData> _imagesSend = [];

  @override
  void initState() {
    super.initState();
    getImagesForRequestInvoice(widget.visitId);
  }

   Future<Map<String, List<ImageData>>> _fetchAllImages() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('auth_token');

    final budgetResponse = await http.get(
      Uri.parse(
          '${dotenv.env['API_URL']}media?model_type=PartRequest&model_id=${widget.visitId}&collection_name=budget'),
      headers: {
        'Content-Type': 'application/json',
        "Accept": "application/json",
        'Authorization': 'Bearer $token',
      },
    );

    final partResponse = await http.get(
      Uri.parse(
          '${dotenv.env['API_URL']}media?model_type=PartRequest&model_id=${widget.visitId}&collection_name=part'),
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

  Future<List<ImageData>> getImagesForRequestInvoice(int requestPart) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('auth_token');

    final response = await http.get(
      Uri.parse(
          '${dotenv.env['API_URL']}media?model_type=PartRequest&model_id=$requestPart&collection_name=invoice'),
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
          _imagesSend = data.map((item) => ImageData.fromJson(item)).toList();
        });
      }
      return data.map((item) => ImageData.fromJson(item)).toList();
    } else {
      // Manejar errores
      print('Error fetching images: ${response.statusCode}');
      return []; // Retornar una lista vacía en caso de error
    }
  }

  Future<void> _submitForm() async {

    final data = {
      'status': 8,
    };
    final imageProvider =
        Provider.of<ImageProviderTechnicalInvoice>(context, listen: false);

    await sendUpdateDataVisitPartRequestPresupuest(
        data, widget.visitId, imageProvider.newImagePaths);
  }

  Future<void> sendUpdateDataVisitPartRequestPresupuest(
      Map<String, dynamic> data, int idTicket, List<String> imagePaths) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('auth_token');
    final fileService = new FileService();
    print('data $data');

    try {
      final response = await http.put(
        Uri.parse(
            '${dotenv.env['API_URL']}part-requests/${widget.visitId}'),
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
        print('Factura enviada éxitosamente ${jsonResponse}');

        // Enviar imágenes
        for (String path in imagePaths) {
          await fileService.sendFile(File(path), 'PartRequest',
              jsonResponse['data']['id'].toString(), 'invoice');
        }

        if (mounted) {
          setState(() {});
        }

        Fluttertoast.showToast(
            msg: "Factura enviada éxitosamente",
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
            msg: "Error al enviar factura",
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
          msg: "Error al enviar datos",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
        title: const Text(
          'Registre factura de la compra',
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ImageUploaderInvoiceThecnical(
                  initialImages: _imagesSend,
                  showAddButton: true,
                ),
                Consumer<ImageProviderTechnicalInvoice>(
                  builder: (context, imageProvider, child) {
                    return ElevatedButton.icon(
                      onPressed: imageProvider.newImagePaths.isNotEmpty
                          ? _submitForm
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      icon: const Icon(Icons.check, color: Colors.white),
                      label: const Text(
                        'He comprado el repuesto',
                        style: TextStyle(color: Colors.white),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ]);
  }
}


 