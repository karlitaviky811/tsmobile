import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tsmobile/src/models/images_model.dart';
import 'package:tsmobile/src/widgets/image_uploader_buy_spare_part_technical.dart';
import 'package:tsmobile/src/widgets/image_uploader_invoice_spare_parts.dart';
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

  Future<List<ImageData>> getImagesForRequestInvoice(int requestPart) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('auth_token');

    final response = await http.get(
      Uri.parse(
          'http://3.137.100.242:3000/api/v1/media?model_type=PartRequest&model_id=$requestPart&collection_name=invoice'),
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
    // Aquí puedes añadir la lógica para enviar las imágenes de la factura
    // por ejemplo: serviceUpdateTicket.saveInvoiceData(imageFiles, widget.visitId);
    print("Factura comprada y enviada");
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          ImageUploaderInvoiceThecnical(
            initialImages: _imagesSend,
          ),
          ElevatedButton(
            onPressed: _submitForm,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xff051937),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text(
              'He comprado el repuesto',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
